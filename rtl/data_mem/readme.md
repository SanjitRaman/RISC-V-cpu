# Design Specification for the data_mem Module

## Overview
The `data_mem` module is a data memory module for a RISC-V processor. It is designed to store and retrieve data during the execution of a program. The module is parameterized by the address width, data width, byte width, and a memory file.

## Parameters

| Parameter       | Default Value    | Description                                            |
|-----------------|------------------|--------------------------------------------------------|
| `ADDRESS_WIDTH` | 17               | The width of the address bus.                          |
| `DATA_WIDTH`    | 32               | The width of the data bus.                             |
| `BYTE_WIDTH`    | 8                | The width of a byte.                                   |
| `MEM_FILE`      | "data_mem.mem"   | The file from which to load initial memory contents.    |


## Inputs
| Signal  | Width | Description                                      |
|---------|-------|--------------------------------------------------|
| `CLK`   |   1   | The clock signal.                                |
| `WE0`   |   1   | Write enable signal for the least significant byte of the data word. |
| `WE1`   |   1   | Write enable signal for the second least significant byte of the data word. |
| `WE2`   |   1   | Write enable signal for the second most significant byte of the data word. |
| `WE3`   |   1   | Write enable signal for the most significant byte of the data word. |
| `A`     |   `DATA_WIDTH`   | The address at which to write or from which to read data. |
| `WD`    | `DATA_WIDTH`      | The data to write to memory.                      |

## Outputs
| Signal  | Width | Description                                      |
|---------|-------|--------------------------------------------------|
| `RD`    | `DATA_WIDTH`    | The data read from memory.                        |

## Functionality
The `data_mem` module uses an array `ram_array` to simulate RAM. The array is indexed by the address `A` and each element is a byte of data.

At the positive edge of the clock, if a write enable signal `WEi` is high, the corresponding byte of the data word `WD` is written to the address `A+i` in `ram_array`.

The output `RD` is the 32-bit word read from `ram_array` at the address `A`. The word is constructed by concatenating the bytes at addresses `A+3`, `A+2`, `A+1`, and `A`.

At initialization, the `ram_array` is loaded with data from the file specified by `MEM_FILE` using the `$readmemh` system task.

## Limitations
Currently, the module does not support writing to addresses that are not aligned to word boundaries. This is noted as a TODO in the code.