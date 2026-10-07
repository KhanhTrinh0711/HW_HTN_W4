ENTRY(Reset_Handler)

_estack = ORIGIN(RAM) + LENGTH(RAM);

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    /* Interrupt Vector Table */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH


    /* Code */
    .text :
    {
        . = ALIGN(4);

        *(.text)
        *(.text*)

        *(.rodata)
        *(.rodata*)

        *(.glue_7)
        *(.glue_7t)

        . = ALIGN(4);
        _etext = .;
    } > FLASH


    /* C initialization */
    .preinit_array :
    {
        . = ALIGN(4);

        PROVIDE_HIDDEN (__preinit_array_start = .);

        KEEP(*(.preinit_array*))

        PROVIDE_HIDDEN (__preinit_array_end = .);

        . = ALIGN(4);
    } > FLASH


    .init_array :
    {
        . = ALIGN(4);

        PROVIDE_HIDDEN (__init_array_start = .);

        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array*))

        PROVIDE_HIDDEN (__init_array_end = .);

        . = ALIGN(4);
    } > FLASH


    .fini_array :
    {
        . = ALIGN(4);

        PROVIDE_HIDDEN (__fini_array_start = .);

        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array*))

        PROVIDE_HIDDEN (__fini_array_end = .);

        . = ALIGN(4);
    } > FLASH


    /* C runtime init/fini */
    .init :
    {
        . = ALIGN(4);
        KEEP(*(SORT_NONE(.init)))
        . = ALIGN(4);
    } > FLASH


    .fini :
    {
        . = ALIGN(4);
        KEEP(*(SORT_NONE(.fini)))
        . = ALIGN(4);
    } > FLASH


    /* Initialized data */
    _sidata = LOADADDR(.data);

    .data :
    {
        . = ALIGN(4);

        _sdata = .;

        *(.data)
        *(.data*)

        . = ALIGN(4);

        _edata = .;
    } > RAM AT > FLASH


    /* Uninitialized data */
    .bss :
    {
        . = ALIGN(4);

        _sbss = .;

        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);

        _ebss = .;
    } > RAM


    /* End of RAM */
    _end = .;
end = .;
}
