# Design Specification for Instruction Memory (RV32I)

## Overview

The instruction memory is an asynchronous ROM which will fetch the instruction corresponding to the Program Counter. The first instruction stored in the instruction memory is at address 0xBFC00000 according to the memory map.

## Instruction Memory Schematic

![Instruction Memory](https://github.com/SanjitRaman/Team-10-RISC-V/blob/master/images/InstructionMemory.png)

## Parameters

| Parameter | Default value | Description |
| ---------- | ------------ | ----------- |
| DATA_WIDTH | 32 | The size of a single instruction in bits |
| BYTE_WIDTH | 8 | Size of a byte in bits |
| ADDRESS_WIDTH | 32 |  The width of the instruction memory input A (size of Program Counter) |


## Inputs

| Signal | Width | Description |
| ------ | ----- | ----------- |
| A | ADDRESS_WIDTH | The address that is accessed in instruction memory |

## Outputs

| Signal | Width | Description |
| ------ | ----- | ----------- |
| RD | DATA_WIDTH | The instruction that is outputted from instruction memory |

## Functionality

The instruction memory reads the program counter and fetches the corresponding instruction from memory. The file "instr_mem.mem" is written to instruction memory when the module is instantiated.




