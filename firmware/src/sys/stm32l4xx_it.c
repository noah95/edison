/*
* @Author: Noah Huetter
* @Date:   2020-04-13 13:51:28
* @Last Modified by:   Noah Huetter
* @Last Modified time: 2020-05-17 15:11:09
*/

#include "main.h"
#include "stm32l4xx_it.h"
#include "led.h"


/*------------------------------------------------------------------------------
 * Cortex-M4 Processor Interruption and Exception Handlers
 * ---------------------------------------------------------------------------*/

/**
  * @brief This function handles Non maskable interrupt.
  */
void NMI_Handler(void)
{

}

/**
  * @brief This function handles Hard fault interrupt.
  */
void HardFault_Handler(void)
{
  while (1)
  {
  }
}

/**
  * @brief This function handles Memory management fault.
  */
void MemManage_Handler(void)
{
  while (1)
  {
  }
}

/**
  * @brief This function handles Prefetch fault, memory access fault.
  */
void BusFault_Handler(void)
{
  while (1)
  {
  }
}

/**
  * @brief This function handles Undefined instruction or illegal state.
  */
void UsageFault_Handler(void)
{
  while (1)
  {
  }
}

/**
  * @brief This function handles System service call via SWI instruction.
  */
void SVC_Handler(void)
{
}

/**
  * @brief This function handles Debug monitor.
  */
void DebugMon_Handler(void)
{
}

/**
  * @brief This function handles Pendable request for system service.
  */
void PendSV_Handler(void)
{
}

/**
  * @brief This function handles System tick timer.
  */
void SysTick_Handler(void)
{
  HAL_IncTick();
}

/*------------------------------------------------------------------------------
 * STM32L4xx Peripheral Interrupt Handlers 
 * ---------------------------------------------------------------------------*/

void USART1_IRQHandler(void)
{
  HAL_UART_IRQHandler(&huart1);
}

/**
  * @brief This function handles DMA1 channel1 global interrupt.
  */
void DMA1_Channel1_IRQHandler(void)
{
  HAL_DMA_IRQHandler(&hdma_tim2_ch3);
}

/**
  * @brief This function handles DMA1 channel4 global interrupt.
  */
void DMA1_Channel4_IRQHandler(void)
{
  HAL_DMA_IRQHandler(&hdma_dfsdm1_flt0);
}

/**
  * @brief This function handles DFSDM1 filter0 global interrupt.
  */
void DFSDM1_FLT0_IRQHandler(void)
{
  HAL_DFSDM_IRQHandler(&hdfsdm1_filter0);
}

void TIM1_CC_IRQHandler(void)
{
  HAL_TIM_IRQHandler(&htim1);
}

void HAL_TIM_OC_DelayElapsedCallback(TIM_HandleTypeDef *htim)
{
  if(htim->Channel == HAL_TIM_ACTIVE_CHANNEL_1)
  {
    // set timer to new capture value
    __HAL_TIM_SET_COMPARE(htim, MAIN_TIM1_ANIMATION_CHANNEL, (__HAL_TIM_GET_COUNTER(htim)+MAIN_TIM1_CH1_INTERVAL_US/MAIN_TIM1_TICK_US)%0xffff );
    ledAnimationCallback();
  }
}

/**
  * @brief This function handles EXTI line[9:5] interrupts.
  */
void EXTI9_5_IRQHandler(void)
{
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_5);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_6);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_7);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_8);
}

/**
  * @brief This function handles EXTI line[15:10] interrupts.
  */
void EXTI15_10_IRQHandler(void)
{
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_10);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_11);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_13);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_14);
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_15);
}

