# Design Specification for the data_mem Module

## Overview
The `data_mem` module is a data memory module for a RISC-V processor. It is designed to store and retrieve data during the execution of a program. The module is parameterized by the address width, data width, byte width, and a memory file.

## Parameters
- `ADDRESS_WIDTH`: The width of the address bus. Default is 17.
- `DATA_WIDTH`: The width of the data bus. Default is 32.
- `BYTE_WIDTH`: The width of a byte. Default is 8.
- `MEM_FILE`: The file from which to load initial memory contents. Default is "data_mem.mem".

## Inputs
- `CLK`: The clock signal.
- `WE0`, `WE1`, `WE2`, `WE3`: Write enable signals for each byte of the data word.
- `A`: The address at which to write or from which to read data.
- `WD`: The data to write to memory.

## Outputs
- `RD`: The data read from memory.

## Functionality
The `data_mem` module uses an array `ram_array` to simulate RAM. The array is indexed by the address `A` and each element is a byte of data.

At the positive edge of the clock, if a write enable signal `WEi` is high, the corresponding byte of the data word `WD` is written to the address `A+i` in `ram_array`.

The output `RD` is the 32-bit word read from `ram_array` at the address `A`. The word is constructed by concatenating the bytes at addresses `A+3`, `A+2`, `A+1`, and `A`.

At initialization, the `ram_array` is loaded with data from the file specified by `MEM_FILE` using the `$readmemh` system task.

## Limitations
Currently, the module does not support writing to addresses that are not aligned to word boundaries. This is noted as a TODO in the code.