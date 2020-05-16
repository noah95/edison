/*
* @Author: Noah Huetter
* @Date:   2020-05-14 21:05:15
* @Last Modified by:   Noah Huetter
* @Last Modified time: 2020-05-15 15:54:22
* 
* WS2811 code adapted from https://github.com/MaJerle/stm32-ws2812b-tim-pwm-dma/blob/master/Src/main.c
*/
#include "led.h"

#include <string.h>

/*------------------------------------------------------------------------------
 * Settings
 * ---------------------------------------------------------------------------*/
#define TIM_INSTANTE TIM2
#define TIM_PERIOD 99 // (80MHz/800kHz-1)

#define LED_CFG_BYTES_PER_LED           3
#define LED_CFG_RAW_BYTES_PER_LED       (LED_CFG_BYTES_PER_LED * 8)

/*------------------------------------------------------------------------------
 * Data
 * ---------------------------------------------------------------------------*/
static uint8_t leds;

// Array of 4x (or 3x) number of leds (R, G, B[, W] colors)
static uint8_t leds_colors[LED_CFG_BYTES_PER_LED * LED_CFG_LEDS_CNT];
// Temporary array for dual LED with extracted PWM duty cycles
/* 
* We need LED_CFG_RAW_BYTES_PER_LED bytes for PWM setup to send all bits.
* Before we can send data for first led, we have to send reset pulse, which must be 50us long.
* PWM frequency is 800kHz, to achieve 50us, we need to send 40 pulses with 0 duty cycle = make array size MAX(2 * LED_CFG_RAW_BYTES_PER_LED, 40)
*/
static uint32_t tmp_led_data[2 * LED_CFG_RAW_BYTES_PER_LED];

static uint8_t          is_reset_pulse;     /*!< Status if we are sending reset pulse or led data */
static volatile uint8_t is_updating;        /*!< Is updating in progress? */
static uint32_t         current_led;        /*!< Current LED number we are sending */

/*------------------------------------------------------------------------------
 * Types
 * ---------------------------------------------------------------------------*/
 

/*------------------------------------------------------------------------------
 * Prototype
 * ---------------------------------------------------------------------------*/
static void updateSequence(uint8_t tc);

static uint8_t fillLedPwmData(size_t ledx, uint32_t* ptr);
static uint8_t startResetPulse(uint8_t num);

/*------------------------------------------------------------------------------
 * Publics
 * ---------------------------------------------------------------------------*/
void ledInit(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  leds = 0;
  // D0 -> Rx4
  // D1 -> Tx4

  // D2 -> D14
  // D3 -> B0
  // D4 -> A3
  // D5 -> B4

  // D6 -> B1
  // D7 -> A4
  // D8 -> B2
  // D9 -> A15

  // D10 -> A2 -> WS2811 -> TIM2_CH3
  // D11 -> A7
  // D12 -> A6
  // D13 -> A5
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_4|GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  GPIO_InitStruct.Pin = GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_2|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7|GPIO_PIN_15;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
  GPIO_InitStruct.Pin = GPIO_PIN_14;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  /**
   * @brief WS2811
   */
  __HAL_RCC_TIM2_CLK_ENABLE();
  TIM_MasterConfigTypeDef sMasterConfig = {0};
  TIM_OC_InitTypeDef sConfigOC = {0};

  htim2.Instance = TIM_INSTANTE;
  htim2.Init.Prescaler = 0;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = TIM_PERIOD;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_PWM_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 0;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim2, &sConfigOC, TIM_CHANNEL_3) != HAL_OK)
  {
    Error_Handler();
  }
   __HAL_RCC_TIM2_CLK_ENABLE();
  
  /* TIM2 DMA Init */
  /* TIM2_CH3 Init */
  hdma_tim2_ch3.Instance = LED_DMA_INSTANCE;
  hdma_tim2_ch3.Init.Request = LED_DMA_REQUEST;
  hdma_tim2_ch3.Init.Direction = DMA_MEMORY_TO_PERIPH;
  hdma_tim2_ch3.Init.PeriphInc = DMA_PINC_DISABLE;
  hdma_tim2_ch3.Init.MemInc = DMA_MINC_ENABLE;
  hdma_tim2_ch3.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
  hdma_tim2_ch3.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
  hdma_tim2_ch3.Init.Mode = DMA_NORMAL;//CIRCULAR;
  hdma_tim2_ch3.Init.Priority = DMA_PRIORITY_VERY_HIGH;
  __HAL_RCC_DMA1_CLK_ENABLE();
  if (HAL_DMA_Init(&hdma_tim2_ch3) != HAL_OK)
  {
    Error_Handler();
  }
  HAL_NVIC_SetPriority(DMA1_Channel1_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA1_Channel1_IRQn);

  __HAL_LINKDMA(&htim2, hdma[TIM_DMA_ID_CC3],hdma_tim2_ch3);

  __HAL_RCC_GPIOA_CLK_ENABLE();
  GPIO_InitStruct.Pin = GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF1_TIM2;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

}

void ledSet(uint8_t s)
{
  leds = s;

  // set: GPIOx->BSRR = (uint32_t)GPIO_Pin;
  // reset: GPIOx->BRR = (uint32_t)GPIO_Pin;
  if(leds & 0x01) GPIOD->BSRR = GPIO_PIN_14; else GPIOD->BRR = GPIO_PIN_14;
  if(leds & 0x02) GPIOB->BSRR = GPIO_PIN_0; else GPIOB->BRR = GPIO_PIN_0;
  if(leds & 0x04) GPIOA->BSRR = GPIO_PIN_3; else GPIOA->BRR = GPIO_PIN_3;
  if(leds & 0x08) GPIOB->BSRR = GPIO_PIN_4; else GPIOB->BRR = GPIO_PIN_4;
  
  if(leds & 0x10) GPIOB->BSRR = GPIO_PIN_1; else GPIOB->BRR = GPIO_PIN_1;
  if(leds & 0x20) GPIOA->BSRR = GPIO_PIN_4; else GPIOA->BRR = GPIO_PIN_4;
  if(leds & 0x40) GPIOB->BSRR = GPIO_PIN_2; else GPIOB->BRR = GPIO_PIN_2;
  if(leds & 0x80) GPIOA->BSRR = GPIO_PIN_15; else GPIOA->BRR = GPIO_PIN_15;
}

uint8_t ledGet(void)
{
  return leds;
}

/**
 * \brief           Set R,G,B color for specific LED
 * \param[in]       index: LED index in array, starting from `0`
 * \param[in]       r,g,b: Red, Green, Blue values
 * \return          `1` on success, `0` otherwise
 */
uint8_t ledSetColor(size_t index, uint8_t r, uint8_t g, uint8_t b)
{
  if (index < LED_CFG_LEDS_CNT) 
  {
    leds_colors[index * LED_CFG_BYTES_PER_LED + 0] = r;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 1] = g;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 2] = b;
    return 0;
  }
  return 1;
}
uint8_t ledSetColorAll(uint8_t r, uint8_t g, uint8_t b)
{
  size_t index;
  for (index = 0; index < LED_CFG_LEDS_CNT; index++)
  {
    leds_colors[index * LED_CFG_BYTES_PER_LED + 0] = r;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 1] = g;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 2] = b;
  }
  return 0;
}
uint8_t ledSetColorRgb(size_t index, uint32_t rgb)
{
  if (index < LED_CFG_LEDS_CNT) 
  {
    leds_colors[index * LED_CFG_BYTES_PER_LED + 0] = (rgb >> 24) & 0xFF;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 1] = (rgb >> 16) & 0xFF;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 2] = (rgb >> 8) & 0xFF;
    return 0;
  }
  return 1;
}
uint8_t ledSetColorAllRgb(uint32_t rgb)
{
  size_t index;
  for (index = 0; index < LED_CFG_LEDS_CNT; index++) 
  {
    leds_colors[index * LED_CFG_BYTES_PER_LED + 0] = (rgb >> 24) & 0xFF;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 1] = (rgb >> 16) & 0xFF;
    leds_colors[index * LED_CFG_BYTES_PER_LED + 2] = (rgb >> 8) & 0xFF;
  }
  return 0;
}

/**
 * \brief           Start LEDs update procedure
 * \param[in]       block: Set to `1` to block for update process until finished
 * \return          `1` if update started, `0` otherwise
 */
uint8_t ledUpdate(uint8_t block) 
{
  if (is_updating) 
  {                          /* Check if update in progress already */
    return 1;
  }
  is_updating = 1;                            /* We are now updating */

  startResetPulse(1);                   /* Start reset pulse */
  if (block) 
  {
    while (!ledIsUpdateFinished());      /* Wait to finish */
  }
  return 1;
}

uint8_t ledIsUpdateFinished(void)
{
  return !is_updating;
}

/*------------------------------------------------------------------------------
 * Pruvate
 * ---------------------------------------------------------------------------*/
/**
 * \brief           Update sequence function, called on each DMA transfer complete or half-transfer complete events
 * \param[in]       tc: Transfer complete flag. Set to `1` on TC event, or `0` on HT event
 *
 * \note            TC = Transfer-Complete event, called at the end of block
 * \note            HT = Half-Transfer-Complete event, called in the middle of elements transfered by DMA
 *                  If block is 48 elements (our case),
 *                      HT is called when first LED_CFG_RAW_BYTES_PER_LED elements are transfered,
 *                      TC is called when second LED_CFG_RAW_BYTES_PER_LED elements are transfered.
 *
 * \note            This function must be called from DMA interrupt
 */
static void updateSequence(uint8_t tc) 
{    
  // Convert to 1 or 0 value only 
  tc = !!tc;                                  
  
  // Check for reset pulse at the end 
  if (is_reset_pulse == 2) 
  {                  
    HAL_TIM_PWM_Stop_DMA(&htim2, TIM_CHANNEL_3);
    
    // We are not updating anymore 
    is_updating = 0;                        
    return;
  }
  
  /* Check for reset pulse on beginning of PWM stream */
  // Check if we finished with reset pulse 
  if (is_reset_pulse == 1) 
  {                  
    /*
     * When reset pulse is active, we have to wait full DMA response,
     * before we can start modifying array which is shared with DMA and PWM
     */
    // We must wait for transfer complete 
    if (!tc) 
    {                              
      // Return and wait to finish 
      return;                             
    }
    
    /* Disable timer output and disable DMA stream */
    HAL_TIM_PWM_Stop_DMA(&htim2, TIM_CHANNEL_3);
    
    // Not in reset pulse anymore 
    is_reset_pulse = 0;                     
    // Reset current led 
    current_led = 0;                        
  } 
  else 
  {
    /*
     * When we are not in reset mode,
     * go to next led and process data for it
     */
    // Go to next LED 
    current_led++;                          
  }
  
  /*
   * This part is used to prepare data for "next" led,
   * for which update will start once current transfer stops in circular mode
   */
  if (current_led < LED_CFG_LEDS_CNT) 
  {
    /*
     * If we are preparing data for first time (current_led == 0)
     * or if there was no TC event (it was HT):
     *
     *  - Prepare first part of array, because either there is no transfer
     *      or second part (from HT to TC) is now in process for PWM transfer
     *
     * In other case (TC = 1)
     */
    if (current_led == 0 || !tc)
    {
      fillLedPwmData(current_led, &tmp_led_data[0]);
    } 
    else 
    {
      fillLedPwmData(current_led, &tmp_led_data[LED_CFG_RAW_BYTES_PER_LED]);
    }
    
    /*
     * If we are preparing first led (current_led = 0), then:
     * 
     *  - We setup first part of array for first led,
     *  - We have to prepare second part for second led to have one led prepared in advance
     *  - Set DMA to circular mode and start the transfer + PWM output
     */
    if (current_led == 0) 
    {
      // Go to next LED 
      current_led++;                      
      fillLedPwmData(current_led, &tmp_led_data[LED_CFG_RAW_BYTES_PER_LED]);   /* Prepare second LED too */
      
      /* Set DMA to circular mode and set length to 48 elements for 2 leds */
      hdma_tim2_ch3.Instance->CCR |= DMA_CCR_CIRC;
      HAL_TIM_PWM_Start_DMA(&htim2, TIM_CHANNEL_3, tmp_led_data, 2 * LED_CFG_RAW_BYTES_PER_LED);
    }
    
  /*
   * When we reached all leds, we have to wait to transmit data for all leds before we can disable DMA and PWM:
   *
   *  - If TC event is enabled and we have EVEN number of LEDS (2, 4, 6, ...)
   *  - If HT event is enabled and we have ODD number of LEDS (1, 3, 5, ...)
   */
  } 
  else if ((!tc && (LED_CFG_LEDS_CNT & 0x01)) || (tc && !(LED_CFG_LEDS_CNT & 0x01))) 
  {
    HAL_TIM_PWM_Stop_DMA(&htim2, TIM_CHANNEL_3);
    
    /* It is time to send final reset pulse, 50us at least */
    startResetPulse(2);                /* Start reset pulse at the end */
  }
}

/**
 * \brief           Prepares data from memory for PWM output for timer
 * \note            Memory is in format R,G,B, while PWM must be configured in G,R,B[,W]
 * \param[in]       ledx: LED index to set the color
 * \param[out]      ptr: Output array with at least LED_CFG_RAW_BYTES_PER_LED-words of memory
 */
static uint8_t fillLedPwmData(size_t ledx, uint32_t* ptr) 
{
  size_t i;
  
  if (ledx < LED_CFG_LEDS_CNT) 
  {
    for (i = 0; i < 8; i++)
    {
      ptr[i] =        (leds_colors[LED_CFG_BYTES_PER_LED * ledx + 1] & (1 << (7 - i))) ? (2 * TIM_PERIOD / 3) : (TIM_PERIOD / 3);
      ptr[8 + i] =    (leds_colors[LED_CFG_BYTES_PER_LED * ledx + 0] & (1 << (7 - i))) ? (2 * TIM_PERIOD / 3) : (TIM_PERIOD / 3);
      ptr[16 + i] =   (leds_colors[LED_CFG_BYTES_PER_LED * ledx + 2] & (1 << (7 - i))) ? (2 * TIM_PERIOD / 3) : (TIM_PERIOD / 3);
    }
    return 0;
  }
  return 1;
}

/**
 * \brief           Start reset pulse sequence
 * \param[in]       num: Number indicating pulse is for beginning (1) or end (2) of PWM data stream
 */
static uint8_t startResetPulse(uint8_t num)
{
  is_reset_pulse = num;                       /* Set reset pulse flag */

  memset(tmp_led_data, 0, sizeof(tmp_led_data));   /* Set all bytes to 0 to achieve 50us pulse */

  if (num == 1) 
  {
    tmp_led_data[0] = TIM_INSTANTE->ARR / 2;
  }

  /* Set DMA to normal mode, set memory to beginning of data and length to 40 elements */
  /* 800kHz PWM x 40 samples = ~50us pulse low */
  hdma_tim2_ch3.Instance->CCR &= ~DMA_CCR_CIRC;
  HAL_TIM_PWM_Start_DMA(&htim2, TIM_CHANNEL_3, tmp_led_data, 40);

  return 1;
}

/*------------------------------------------------------------------------------
 * Callbacks
 * ---------------------------------------------------------------------------*/
void HAL_TIM_PWM_PulseFinishedHalfCpltCallback(TIM_HandleTypeDef *htim)
{
  updateSequence(0);                 /* Call update sequence as HT event */
}
void HAL_TIM_PWM_PulseFinishedCallback(TIM_HandleTypeDef *htim)
{
  updateSequence(1);                 /* Call update sequence as TC event */
}