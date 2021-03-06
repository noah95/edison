/*
* @Author: Noah Huetter
* @Date:   2020-04-13 13:56:56
* @Last Modified by:   Noah Huetter
* @Last Modified time: 2020-05-17 15:57:17
*/
#include "microphone.h"

#include "main.h"
#include "util.h"
#include "app.h"

#include "arm_math.h"

/**
 * f_ckin     Clock frequency of data line: f_ckin = 80e6 / clockDivider
 * f_osr      Filter oversampling ratio = oversampling
 * f_ord      Filter order, [1,5] for sinc
 * I_osr      Integrator oversampling ratio, [1,256] = intOversampling
 * 
 * Output datarate for FAST=0, SincX filter
 *    DR [Samples/s] = f_ckin / (f_osr * (I_osr - 1 + f_ord ) + (f_ord + 1) )
 * Output datarate for FAST=0, FastSinc filter
 *    DR [Samples/s] = f_ckin / (f_osr * (I_osr - 1 + 4 ) + (2 + 1) )
 * Output datarate for FAST=1
 *    DR [Samples/s] = f_ckin / (f_osr * I_osr)
 *   
 * Cut-off frequency
 *    fg = f_ckin / f_osr
 */

/*------------------------------------------------------------------------------
 * Types
 * ---------------------------------------------------------------------------*/

/**
 * experimentally determined offset from output
 */
// #define OFFSET_DATA 316736
#define OFFSET_DATA 0

/**
 * Mic gain is G = GAIN * 2**SHIFT_GAIN
 * 
 * Work as much as possible with shift gain to get more bits of of data
 */
#define SHIFT_GAIN 6
#define GAIN 1

typedef struct 
{
  // 2..256
  uint32_t clockDivider;
  // 1..32
  uint16_t oversampling;
  // between Min_Data = 0x00 and Max_Data = 0x1F
  uint32_t rightBitShift;
  // between Min_Data = -8388608 and Max_Data = 8388607
  int32_t offset;
  // DFSDM_FILTER_FASTSINC_ORDER
  // DFSDM_FILTER_SINC1_ORDER
  // DFSDM_FILTER_SINC2_ORDER
  // DFSDM_FILTER_SINC3_ORDER
  // DFSDM_FILTER_SINC4_ORDER
  // DFSDM_FILTER_SINC5_ORDER
  uint32_t sincOrder;
  // 1..256
  uint32_t intOversampling;
} filterSettings_t;
/**
 * Results in 5kHz sample rate
 */
const filterSettings_t fs5k = {33, 484, 0x00, OFFSET_DATA, DFSDM_FILTER_SINC3_ORDER,1};
const filterSettings_t fs10k = {33, 242, 0x00, OFFSET_DATA, DFSDM_FILTER_SINC3_ORDER,1};
const filterSettings_t fs44k = {33, 55, 0x00, OFFSET_DATA, DFSDM_FILTER_SINC3_ORDER,1};
const filterSettings_t fs16k = {33, 152, 0x00, OFFSET_DATA, DFSDM_FILTER_SINC3_ORDER,1};
const filterSettings_t fs8krs16 = {33, 242, 16, OFFSET_DATA, DFSDM_FILTER_SINC3_ORDER,1};


/*------------------------------------------------------------------------------
 * Settings
 * ---------------------------------------------------------------------------*/

/**
 * In continuous mode, each block of sampels requested contains that many samples
 */
#define CONTINUOUS_MODE_SAMPLE_SIZE 1024

#define RAW_BUFFER_SIZE (2*CONTINUOUS_MODE_SAMPLE_SIZE)
#define MIC_8BIT_BUF_SIZE (2*CONTINUOUS_MODE_SAMPLE_SIZE)
#define MIC_16BIT_BUF_SIZE (2*CONTINUOUS_MODE_SAMPLE_SIZE)

const filterSettings_t* filterSettings = &fs16k;

/*------------------------------------------------------------------------------
 * Private data
 * ---------------------------------------------------------------------------*/
static int32_t dataBuffer [RAW_BUFFER_SIZE];
static int8_t proc8bitBuffer [MIC_8BIT_BUF_SIZE];
static int16_t proc16bitBuffer [MIC_16BIT_BUF_SIZE];
static int32_t exdMaxValue, exdMinValue;

static volatile bool regConvCplt = false;
static volatile bool regConvHalfCplt = false;

static volatile uint32_t dbg32;

/*------------------------------------------------------------------------------
 * Prototypes
 * ---------------------------------------------------------------------------*/
static void preprocess8bit(int8_t * outPtr, int32_t * srcPtr, uint32_t nProcess);
static void preprocess16bit(int16_t * outPtr, int32_t * srcPtr, uint32_t nProcess);

/*------------------------------------------------------------------------------
 * Publics
 * ---------------------------------------------------------------------------*/
/**
 * @brief Inits all necessary peripherals for microphone sampling
 * @details 
 */
void micInit(void)
{
  // Init DFSM module
  hdfsdm1_ch1.Instance = DFSDM1_Channel2;
  hdfsdm1_ch1.Init.OutputClock.Activation = ENABLE;
  hdfsdm1_ch1.Init.OutputClock.Selection = DFSDM_CHANNEL_OUTPUT_CLOCK_SYSTEM;
  hdfsdm1_ch1.Init.OutputClock.Divider = filterSettings->clockDivider; // from Cube: 2
  hdfsdm1_ch1.Init.Input.Multiplexer = DFSDM_CHANNEL_EXTERNAL_INPUTS;
  hdfsdm1_ch1.Init.Input.DataPacking = DFSDM_CHANNEL_STANDARD_MODE;
  hdfsdm1_ch1.Init.Input.Pins = DFSDM_CHANNEL_SAME_CHANNEL_PINS;
  hdfsdm1_ch1.Init.SerialInterface.Type = DFSDM_CHANNEL_SPI_RISING;
  hdfsdm1_ch1.Init.SerialInterface.SpiClock = DFSDM_CHANNEL_SPI_CLOCK_INTERNAL;
  hdfsdm1_ch1.Init.Awd.FilterOrder = DFSDM_CHANNEL_FASTSINC_ORDER;
  hdfsdm1_ch1.Init.Awd.Oversampling = 1;
  hdfsdm1_ch1.Init.Offset = filterSettings->offset;
  hdfsdm1_ch1.Init.RightBitShift = filterSettings->rightBitShift;
  if (HAL_DFSDM_ChannelInit(&hdfsdm1_ch1) != HAL_OK)
  {
    Error_Handler();
  }

  // Init DMA 
  __HAL_RCC_DMA1_CLK_ENABLE();
  HAL_NVIC_SetPriority(DMA1_Channel4_IRQn, MAIN_IRQ_DMA1_CH4_PRE, MAIN_IRQ_DMA1_CH4_SUB);
  HAL_NVIC_EnableIRQ(DMA1_Channel4_IRQn);
  hdma_dfsdm1_flt0.Instance = DMA1_Channel4;
  hdma_dfsdm1_flt0.Init.Request = DMA_REQUEST_0; // ref man page 340 CxS value
  hdma_dfsdm1_flt0.Init.Direction = DMA_PERIPH_TO_MEMORY;
  hdma_dfsdm1_flt0.Init.PeriphInc = DMA_PINC_DISABLE;
  hdma_dfsdm1_flt0.Init.MemInc = DMA_MINC_ENABLE;
  hdma_dfsdm1_flt0.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD; // BYTE HALFWORD WORD
  hdma_dfsdm1_flt0.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
  hdma_dfsdm1_flt0.Init.Mode = DMA_CIRCULAR; // cicular
  hdma_dfsdm1_flt0.Init.Priority = MAIN_DMA_PRIO_DFSDM1_FLT0; // LOW MEDIUM HIGH VERYHIGH
  if (HAL_DMA_Init(&hdma_dfsdm1_flt0) != HAL_OK)
  {
    Error_Handler();
  }
  // Link DMA1_CH4 to DFSDM1_FLT0 regular channel
  __HAL_LINKDMA(&hdfsdm1_filter0,hdmaInj,hdma_dfsdm1_flt0);
  __HAL_LINKDMA(&hdfsdm1_filter0,hdmaReg,hdma_dfsdm1_flt0);

  // Init filter channel
  hdfsdm1_filter0.Instance = DFSDM1_Filter0;
  hdfsdm1_filter0.Init.RegularParam.Trigger = DFSDM_FILTER_SW_TRIGGER;
  hdfsdm1_filter0.Init.RegularParam.FastMode = ENABLE;
  hdfsdm1_filter0.Init.RegularParam.DmaMode = ENABLE;
  hdfsdm1_filter0.Init.FilterParam.SincOrder = filterSettings->sincOrder;
  hdfsdm1_filter0.Init.FilterParam.Oversampling = filterSettings->oversampling; // 100->24kHz, 242->10Khz, 484->5kHz
  hdfsdm1_filter0.Init.FilterParam.IntOversampling = filterSettings->intOversampling;
  if (HAL_DFSDM_FilterInit(&hdfsdm1_filter0) != HAL_OK)
  {
    Error_Handler();
  }

  // (#) Select regular channel and enable/disable continuous mode using
  //     HAL_DFSDM_FilterConfigRegChannel().
  if (HAL_DFSDM_FilterConfigRegChannel(&hdfsdm1_filter0, DFSDM_CHANNEL_2, DFSDM_CONTINUOUS_CONV_ON) != HAL_OK)
  {
    Error_Handler();
  }

}

/**
 * @brief Samples n samples once and returns pointer to buffer
 * @details 
 * 
 * @param n number of samples to get
 * @return pointer to data buffer
 */
uint32_t micSampleSingle(int32_t ** data, uint32_t n)
{
  uint32_t len = (n>RAW_BUFFER_SIZE)?RAW_BUFFER_SIZE:n;
  uint32_t unused;

  if (len < 1) return 0;
  regConvCplt = false;

  // start extrem value detection and reset the values
  // hdfsdm1_filter0.Instance->FLTCR2 &= ~(DFSDM_FLTCR2_EXCH);
  // hdfsdm1_filter0.Instance->FLTCR2 |= ((0x3f) << DFSDM_FLTCR2_EXCH_Pos); // enable channel 2
  // exdMaxValue = ((int32_t)hdfsdm1_filter0.Instance->FLTEXMAX/256);
  // exdMinValue = ((int32_t)hdfsdm1_filter0.Instance->FLTEXMIN/256);
  if(HAL_DFSDM_FilterExdStart(&hdfsdm1_filter0, DFSDM_CHANNEL_0) != HAL_OK)
  {
    Error_Handler();
  }
  exdMaxValue = HAL_DFSDM_FilterGetExdMaxValue(&hdfsdm1_filter0, &unused);
  exdMinValue = HAL_DFSDM_FilterGetExdMinValue(&hdfsdm1_filter0, &unused);

  // (#) Start regular conversion using HAL_DFSDM_FilterRegularStart(),
  //     HAL_DFSDM_FilterRegularStart_IT(), HAL_DFSDM_FilterRegularStart_DMA() or
  //     HAL_DFSDM_FilterRegularMsbStart_DMA().
  if (HAL_DFSDM_FilterRegularStart_DMA(&hdfsdm1_filter0, dataBuffer, len) != HAL_OK)
  {
    Error_Handler();
  }

  // (#) In polling mode, use HAL_DFSDM_FilterPollForRegConversion() to detect
  //     the end of regular conversion.
  while(!regConvCplt);
  // if (HAL_DFSDM_FilterPollForRegConversion(&hdfsdm1_filter0, HAL_MAX_DELAY) != HAL_OK) // block
  // {
  //   Error_Handler();
  // }

  // (#) In interrupt mode, HAL_DFSDM_FilterRegConvCpltCallback() will be called
  //     at the end of regular conversion.
  // (#) Get value of regular conversion and corresponding channel using
  //     HAL_DFSDM_FilterGetRegularValue().
  // (#) In DMA mode, HAL_DFSDM_FilterRegConvHalfCpltCallback() and
  //     HAL_DFSDM_FilterRegConvCpltCallback() will be called respectively at the
  //     half transfer and at the transfer complete. Please note that
  //     HAL_DFSDM_FilterRegConvHalfCpltCallback() will be called only in DMA
  //     circular mode.
  // (#) Stop regular conversion using HAL_DFSDM_FilterRegularStop(),
  //     HAL_DFSDM_FilterRegularStop_IT() or HAL_DFSDM_FilterRegularStop_DMA().
  HAL_DFSDM_FilterRegularStop_DMA(&hdfsdm1_filter0);

  // store values and stop extreme detection
  // exdMaxValue = ((int32_t)hdfsdm1_filter0.Instance->FLTEXMAX/256);
  // exdMinValue = ((int32_t)hdfsdm1_filter0.Instance->FLTEXMIN/256);
  exdMaxValue = HAL_DFSDM_FilterGetExdMaxValue(&hdfsdm1_filter0, &unused);
  exdMinValue = HAL_DFSDM_FilterGetExdMinValue(&hdfsdm1_filter0, &unused);
  // if(HAL_DFSDM_FilterExdStop(&hdfsdm1_filter0) != HAL_OK)
  // {
  //   Error_Handler();
  // }

  *data = dataBuffer;
  return len;
}

/**
 * @brief Runs endless loop of streaming microphone data to serial
 * @details 
 */
void micEndlessStream(void)
{
  int32_t* data = dataBuffer;
  const uint32_t chunksize=128;

  while(1)
  {
    regConvCplt = false; regConvHalfCplt = false;
    
    // start
    if (HAL_DFSDM_FilterRegularStart_DMA(&hdfsdm1_filter0, dataBuffer, chunksize) != HAL_OK)
    {
      Error_Handler();
    }

    while(!regConvHalfCplt);

    for(int i = 0; i < chunksize/2; i++)
    {
      printf("%d\r\n", data[i]>>16);
    }

    while(!regConvCplt);

    for(int i = 0; i < chunksize/2; i++)
    {
      printf("%d\r\n", data[chunksize/2+i]>>16);
    }

    HAL_DFSDM_FilterRegularStop_DMA(&hdfsdm1_filter0);
  }
}

/**
 * @brief Endless loop waiting for sample requests via serial
 * @details 
 */
void micHostSampleRequest(uint16_t nSamples)
{
  int32_t* datap = 0;
  uint8_t txdata;
  int32_t softMax, softMin;

  nSamples = micSampleSingle(&datap, nSamples);

  softMax = -8388608; softMin = 8388607;
  for(int i = 0; i < nSamples; i++)
  {
    // data register is aligned at 8th bit
    datap[i] /= 256;
    softMin = datap[i] < softMin ? datap[i] : softMin;
    softMax = datap[i] > softMax ? datap[i] : softMax;
  }

  // downsample to 8 bits
  // for(int i = 0; i < nSamples; i++)
  // {
  //   datap[i] = datap[i] >> 24;
  // }

  // HAL_Delay(1000);
  // printf("%x %x \n", datap, dataBuffer);
  // utilDumpHex(datap, 40);
  for(int i = 0; i < nSamples; i++)
  {
    txdata = (uint8_t)((datap[i] >> 24) & 0x000000ff);
    // printf("%02x\n", txdata); 
    HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
    txdata = (uint8_t)((datap[i] >> 16) & 0x000000ff);
    // printf("%02x\n", txdata); 
    HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
    txdata = (uint8_t)((datap[i] >>  8) & 0x000000ff);
    // printf("%02x\n", txdata); 
    HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
    txdata = (uint8_t)((datap[i] >>  0) & 0x000000ff);
    // printf("%02x\n", txdata); 
    HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
  }


  printf("Max = %d(%d) Min = %d(%d) \n", exdMaxValue, softMax, exdMinValue, softMin);

}

/**
 * @brief Host interface helper for getting nSamples preprocessed
 * @details 
 * 
 * @param nSamples 
 */
void micHostSampleRequestPreprocessed(uint16_t nSamples, uint8_t bits)
{
  int8_t* data8p = 0;
  int16_t* data16p = 0;
  uint8_t txdata;

  if(bits == 8)
    nSamples = micSampleSinglePreprocessed((void**)&data8p, nSamples, bits);
  else
    nSamples = micSampleSinglePreprocessed((void**)&data16p, nSamples, bits);

  if(bits == 8)
  {
    for(int i = 0; i < nSamples; i++)
    {
      txdata = (uint8_t)(data8p[i]);
      HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
    }
  }
  else
  {
    for(int i = 0; i < nSamples; i++)
    {
      txdata = (uint8_t)((data16p[i] >>  8) & 0x00ff);
      HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
      txdata = (uint8_t)((data16p[i] >>  0) & 0x00ff);
      HAL_UART_Transmit(&huart1, &txdata, 1, HAL_MAX_DELAY);
    }
  }
}

/**
 * @brief Samples n samples and preprocesses them before returning
 * @details 
 * 
 * @param data pointer where output data is stored
 * @param n number of samples to fetch
 * 
 * @return 
 */
uint32_t micSampleSinglePreprocessed(void ** data, uint32_t n, uint8_t bits)
{
  uint32_t len = (n>MIC_8BIT_BUF_SIZE)?MIC_8BIT_BUF_SIZE:n;
  int8_t *outPtr8 = proc8bitBuffer;
  int16_t *outPtr16 = proc16bitBuffer;
  uint32_t nProcess, remaining;
  int32_t *srcPtr;
  // start fetching
  if (len < 1) return 0;

  dbg32 = 0;
  if(HAL_DFSDM_FilterRegularStart_DMA(&hdfsdm1_filter0, dataBuffer, RAW_BUFFER_SIZE) != HAL_OK)
  {
    Error_Handler();
  }

  regConvCplt = false; regConvHalfCplt = false;
  remaining = len;
  do
  {
    nProcess = remaining > (RAW_BUFFER_SIZE/2) ? RAW_BUFFER_SIZE/2 : remaining;
    // printf("%d/%d\n", nProcess, remaining);
    while( !regConvCplt && !regConvHalfCplt);
    if(regConvHalfCplt)
    {
      regConvHalfCplt = false;
      srcPtr = &dataBuffer[0];
    }
    else
    {
      regConvCplt = false;
      srcPtr = &dataBuffer[RAW_BUFFER_SIZE/2];
    }
    if(bits == 8)
    {
      preprocess8bit(outPtr8, srcPtr, nProcess); //dst, src, N
      outPtr8+=nProcess; 
    }
    else
    {
      preprocess16bit(outPtr16, srcPtr, nProcess); //dst, src, N
      outPtr16+=nProcess; 
    }
    remaining-=nProcess;
  } while(remaining);
  HAL_DFSDM_FilterRegularStop_DMA(&hdfsdm1_filter0);

  if(bits == 8) *data = proc8bitBuffer;
  else *data = proc16bitBuffer;

  return len;
}

/**
 * @brief Starts continuous mode, see miContinuouscGet
 * @details 
 */
void micContinuousStart (void)
{
  regConvCplt = false; regConvHalfCplt = false;
  if(HAL_DFSDM_FilterRegularStart_DMA(&hdfsdm1_filter0, dataBuffer, RAW_BUFFER_SIZE) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
 * @brief Stops continuous mode, see miContinuouscGet
 * @details [long description]
 */
void micContinuousStop (void)
{
  HAL_DFSDM_FilterRegularStop_DMA(&hdfsdm1_filter0);
}

/**
 * @brief Blocking wait for samples, returns pointer to buffer where samples are stored
 * frame size is fixed to CONTINUOUS_MODE_SAMPLE_SIZE
 * @details [long description]
 */
int16_t* micContinuousGet (void)
{
  int16_t *outPtr16 = proc16bitBuffer;
  int32_t *srcPtr;

  // wait for complete
  while( !regConvCplt && !regConvHalfCplt);

  // get pointer to valid data
  if(regConvHalfCplt)
  {
    regConvHalfCplt = false;
    srcPtr = &dataBuffer[0];
  }
  else
  {
    regConvCplt = false;
    srcPtr = &dataBuffer[RAW_BUFFER_SIZE/2];
  }

  // preprocess
  preprocess16bit(outPtr16, srcPtr, RAW_BUFFER_SIZE/2); //dst, src, N

  return outPtr16;
}

/*------------------------------------------------------------------------------
 * Privates
 * ---------------------------------------------------------------------------*/
/**
 * @brief Preprocess batch of samples
 * @details 
 * 
 * @param outPtr where to write the data
 * @param srcPtr where to fetch the data
 * @param nProcess number of values to process
 */
static void preprocess8bit(int8_t * outPtr, int32_t * srcPtr, uint32_t nProcess)
{
  int32_t min, max, peak;
  uint32_t idx, msb;

  arm_min_q31((q31_t *)srcPtr, nProcess, (q31_t *)&min, &idx);
  arm_max_q31((q31_t *)srcPtr, nProcess, (q31_t *)&max, &idx);

  peak = (max > -min) ? max : -min;
  msb = 30;
  for(; msb > 8; msb--)
  {
    if( peak & (1<<msb) ) break;
  }

  // experimental feature for detecting highest and lowest values.
  // msb could be used for AGC (automatic gain control), where the data is not always
  // shifted >>24 but only the amount required to not clip the audio
  
  // printf("ARM math min = %d max = %d peak: = %d msb = %d\n",min,max,peak,msb);

  // printf("out = %d in = %s\n", outPtr-proc8bitBuffer, (srcPtr==dataBuffer)?"base":"non-base");  
  for(int i = 0; i < nProcess; i++)
  {
    // get only 8 bits of data
    outPtr[i] = srcPtr[i] >> 24;
  }
}

/**
 * @brief Preprocess batch of samples
 * @details 
 * 
 * @param outPtr where to write the data
 * @param srcPtr where to fetch the data
 * @param nProcess number of values to process
 */
static void preprocess16bit(int16_t * outPtr, int32_t * srcPtr, uint32_t nProcess)
{
  for(int i = 0; i < nProcess; i++)
  {
    // get only 16 bits of data
    outPtr[i] = GAIN * (int16_t)( (srcPtr[i] >> (16-SHIFT_GAIN)) &0x0000ffff);
  }
}

/*------------------------------------------------------------------------------
 * Callbacks
 * ---------------------------------------------------------------------------*/
void HAL_DFSDM_FilterRegConvCpltCallback(DFSDM_Filter_HandleTypeDef *hdfsdm_filter)
{
  regConvCplt = true;

  // preprocess
  preprocess16bit(proc16bitBuffer, &dataBuffer[RAW_BUFFER_SIZE/2], RAW_BUFFER_SIZE/2); //dst, src, N

  appAudioEvent(2, proc16bitBuffer);
}

void HAL_DFSDM_FilterRegConvHalfCpltCallback(DFSDM_Filter_HandleTypeDef *hdfsdm_filter)
{
  regConvHalfCplt = true;
  dbg32++;

  // preprocess
  preprocess16bit(proc16bitBuffer, &dataBuffer[0], RAW_BUFFER_SIZE/2); //dst, src, N
    
  appAudioEvent(1, proc16bitBuffer);
}

