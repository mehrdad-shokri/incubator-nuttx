/************************************************************************************
 * boards/avr/at90usb/teensy-2.0/scripts/flash.ld
 *
 *   Copyright (C) 2011 Gregory Nutt. All rights reserved.
 *   Author: Gregory Nutt <gnutt@nuttx.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in
 *  the documentation and/or other materials provided with the
 *  distribution.
 * 3. Neither the name NuttX nor the names of its contributors may be
 *  used to endorse or promote products derived from this software
 *  without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 ************************************************************************************/

/* Memory Regions *******************************************************************/
/* ------------ ------ ------+------- -- ------ -- ------ --- ------ ----+------- ---
 *              FLASH        | REGISTERS I/O       EXT I/O    ISRAM      | EEPROM
 *                           |           REGISTERS REGISTERS             |
 * ------------ ------ ------+------- -- ------ -- ------ --- ------ ----+------- ---
 * AT90USB1286  0x0000 128Kb | 0x0000 32 0x0020 64 0x0060 160 0x0100 8Kb | 0x0000 4Kb
 * ------------ ------ ------+------- -- ------ -- ------ --- ------ ----+------- ---
 */

MEMORY
{
  flash    (rx) : ORIGIN = 0, LENGTH = 128K
  sram   (rw!x) : ORIGIN = 0x800100, LENGTH = 8K
  eeprom (rw!x) : ORIGIN = 0x810000, LENGTH = 4K
}

ENTRY(__start)

SECTIONS
{
    /* Read-only sections, merged into text segment: */

    .hash           : { *(.hash) }
    .dynsym         : { *(.dynsym) }
    .dynstr         : { *(.dynstr) }
    .gnu.version    : { *(.gnu.version) }
    .gnu.version_d  : { *(.gnu.version_d) }
    .gnu.version_r  : { *(.gnu.version_r) }
    .rel.init       : { *(.rel.init) }
    .rela.init      : { *(.rela.init) }

    .rel.text       :
        {
            *(.rel.text)
            *(.rel.text.*)
            *(.rel.gnu.linkonce.t*)
        }

    .rela.text      :
        {
            *(.rela.text)
            *(.rela.text.*)
            *(.rela.gnu.linkonce.t*)
        }

    .rel.fini       : { *(.rel.fini) }
    .rela.fini      : { *(.rela.fini) }

    .rel.rodata     :
        {
            *(.rel.rodata)
            *(.rel.rodata.*)
            *(.rel.gnu.linkonce.r*)
        }

    .rela.rodata    :
        {
            *(.rela.rodata)
            *(.rela.rodata.*)
            *(.rela.gnu.linkonce.r*)
        }

    .rel.data       :
        {
            *(.rel.data)
            *(.rel.data.*)
            *(.rel.gnu.linkonce.d*)
        }

    .rela.data      :
        {
            *(.rela.data)
            *(.rela.data.*)
            *(.rela.gnu.linkonce.d*)
        }

    .rel.ctors      : { *(.rel.ctors) }
    .rela.ctors     : { *(.rela.ctors) }
    .rel.dtors      : { *(.rel.dtors) }
    .rela.dtors     : { *(.rela.dtors) }
    .rel.got        : { *(.rel.got) }
    .rela.got       : { *(.rela.got) }
    .rel.bss        : { *(.rel.bss) }
    .rela.bss       : { *(.rela.bss) }
    .rel.plt        : { *(.rel.plt) }
    .rela.plt       : { *(.rela.plt) }

    .text           :
    {
        _stext = . ;
        *(.vectors)
        *(.init)
        *(.handlers)
        *(.progmem .progmem.*)
        *(.text)
        *(.text.*)
        _etext = . ;
    } > flash

    _eronly = ABSOLUTE(.);

    .data           :
    {
        _sdata = ABSOLUTE(.);
        *(.rodata .rodata.*)
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        CONSTRUCTORS
        _edata = ABSOLUTE(.);
    } > sram AT > flash

    .bss            :
    {
        _sbss = ABSOLUTE(.);
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        _ebss = ABSOLUTE(.);
    } > sram

    /* Global data not cleared after reset. */

    .noinit         :
    {
        _snoinit = ABSOLUTE(.);
        *(.noinit*)
        _enoinit = ABSOLUTE(.);
    }   > sram

    .eeprom         :
    {
        _seeprom = ABSOLUTE(.);
        *(.eeprom*)
        _eeeprom = ABSOLUTE(.);
    }   > eeprom

    /* Stabs debugging sections.    */

    .stab 0             : { *(.stab) }
    .stabstr 0          : { *(.stabstr) }
    .stab.excl 0        : { *(.stab.excl) }
    .stab.exclstr 0     : { *(.stab.exclstr) }
    .stab.index 0       : { *(.stab.index) }
    .stab.indexstr 0    : { *(.stab.indexstr) }
    .comment 0          : { *(.comment) }

    /* DWARF debug sections.
         Symbols in the DWARF debugging sections are relative to the beginning
         of the section so we begin them at 0.  */

    /* DWARF 1 */

    .debug 0            : { *(.debug) }
    .line 0             : { *(.line) }

    /* GNU DWARF 1 extensions */

    .debug_srcinfo 0    : { *(.debug_srcinfo) }
    .debug_sfnames 0    : { *(.debug_sfnames) }

    /* DWARF 1.1 and DWARF 2 */

    .debug_aranges 0    : { *(.debug_aranges) }
    .debug_pubnames 0   : { *(.debug_pubnames) }

    /* DWARF 2 */

    .debug_info 0       : { *(.debug_info) *(.gnu.linkonce.wi.*) }
    .debug_abbrev 0     : { *(.debug_abbrev) }
    .debug_line 0       : { *(.debug_line) }
    .debug_frame 0      : { *(.debug_frame) }
    .debug_str 0        : { *(.debug_str) }
    .debug_loc 0        : { *(.debug_loc) }
    .debug_macinfo 0    : { *(.debug_macinfo) }
}
