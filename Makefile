TARGET = firmware

CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size
ST_FLASH ?= st-flash

CPU = -mcpu=cortex-m3 -mthumb

C_DEFS = \
-DUSE_HAL_DRIVER \
-DSTM32F103xB

C_INCLUDES = \
-I. \
-IDrivers/CMSIS/Include \
-IDrivers/CMSIS/Device/ST/STM32F1xx/Include \
-IDrivers/STM32F1xx_HAL_Driver/Inc

CFLAGS = $(CPU) \
-O0 \
-g3 \
-Wall \
-ffunction-sections \
-fdata-sections \
$(C_DEFS) \
$(C_INCLUDES)

ASFLAGS = $(CPU) \
-g3 \
-c

LDFLAGS = $(CPU) \
-Tstm32f103c8.ld \
-Wl,--gc-sections \
-Wl,-Map=$(TARGET).map \
-specs=nano.specs \
-specs=nosys.specs

C_SOURCES = \
main.c \
system_stm32f1xx.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_i2c.c \
Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart.c

ASM_SOURCES = \
startup_stm32f103xb.s

C_OBJECTS = $(C_SOURCES:.c=.o)
ASM_OBJECTS = $(ASM_SOURCES:.s=.o)

all: $(TARGET).bin
	$(SIZE) $(TARGET).elf

$(TARGET).elf: $(C_OBJECTS) $(ASM_OBJECTS)
	$(LD) $(C_OBJECTS) $(ASM_OBJECTS) $(LDFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

flash: $(TARGET).bin
	$(ST_FLASH) write $< 0x08000000

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(C_OBJECTS) $(ASM_OBJECTS)
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).map

.PHONY: all flash clean
