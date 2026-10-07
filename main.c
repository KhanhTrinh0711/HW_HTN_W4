#include "stm32f1xx_hal.h"

#define LED_PA0_HALF_PERIOD_MS  5000U
#define LED_PA1_HALF_PERIOD_MS   500U
#define LED_PA2_HALF_PERIOD_MS    50U

static void SystemClock_Config(void);
static void GPIO_Init(void);
static void Task_LED_PA0(void);
static void Task_LED_PA1(void);
static void Task_LED_PA2(void);
static void Error_Handler(void);

int main(void)
{
    HAL_Init();
    SystemClock_Config();
    GPIO_Init();

    while (1)
    {
        Task_LED_PA0();
        Task_LED_PA1();
        Task_LED_PA2();
    }
}

static void GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    __HAL_RCC_GPIOA_CLK_ENABLE();

    GPIO_InitStruct.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_2;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;

    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
    HAL_GPIO_WritePin(
        GPIOA,
        GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_2,
        GPIO_PIN_RESET);
}

static void Task_LED_PA0(void)
{
    static uint32_t last_toggle = 0U;
    static uint8_t initialized = 0U;
    uint32_t now = HAL_GetTick();

    if (initialized == 0U)
    {
        last_toggle = now;
        initialized = 1U;
    }
    else if ((uint32_t)(now - last_toggle) >= LED_PA0_HALF_PERIOD_MS)
    {
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_0);
        last_toggle = now;
    }
}

static void Task_LED_PA1(void)
{
    static uint32_t last_toggle = 0U;
    static uint8_t initialized = 0U;
    uint32_t now = HAL_GetTick();

    if (initialized == 0U)
    {
        last_toggle = now;
        initialized = 1U;
    }
    else if ((uint32_t)(now - last_toggle) >= LED_PA1_HALF_PERIOD_MS)
    {
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_1);
        last_toggle = now;
    }
}

static void Task_LED_PA2(void)
{
    static uint32_t last_toggle = 0U;
    static uint8_t initialized = 0U;
    uint32_t now = HAL_GetTick();

    if (initialized == 0U)
    {
        last_toggle = now;
        initialized = 1U;
    }
    else if ((uint32_t)(now - last_toggle) >= LED_PA2_HALF_PERIOD_MS)
    {
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_2);
        last_toggle = now;
    }
}

static void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;

    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    RCC_ClkInitStruct.ClockType =
        RCC_CLOCKTYPE_HCLK |
        RCC_CLOCKTYPE_SYSCLK |
        RCC_CLOCKTYPE_PCLK1 |
        RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
    {
        Error_Handler();
    }
}

void SysTick_Handler(void)
{
    HAL_IncTick();
}

static void Error_Handler(void)
{
    __disable_irq();

    while (1)
    {
    }
}
