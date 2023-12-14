# `data_mem_wrapper` Module

The `data_mem_wrapper` module is an integration-level testbench for the `data_mem`, `we_decoder`, and `ld_decoder` components of a RISC-V processor. It is designed to verify that the correct byte, half-word, or word is stored and loaded in a signed or unsigned manner.

## Overview

The `data_mem_wrapper` module takes as inputs the clock signal (`CLK`), the result of the ALU operation (`ALUResult`), the data to be written (`WriteData`), the `funct3` field of the instruction (`funct3`), and a signal indicating whether a memory write operation is to be performed (`MemWrite`). It outputs the data read from memory (`RDOut`).

Internally, the module instantiates the `data_mem`, `we_decoder`, and `ld_decoder` components and connects them according to the schematic:

## Schematic

![data_mem_wrapper schematic](/images/data_mem_wrapper_schematic.png)

### `data_mem` Component

The `data_mem` component is responsible for storing and retrieving data. It is parameterized by the data width, address width, byte width, and a memory file from which to load initial memory contents.

The `data_mem` component takes as inputs the clock signal, the address at which to write or from which to read data, the data to write to memory, and write enable signals for each byte of the data word. It outputs the data read from memory.

### `we_decoder` Component

The `we_decoder` component is responsible for decoding store instructions and generating write enable signals. It takes as inputs the `funct3` field of the store instruction and the `MemWrite` signal, and outputs write enable signals for each byte of the data word.

### `ld_decoder` Component

The `ld_decoder` component is responsible for decoding load instructions and performing sign extension or zero extension based on the `funct3` field of the instruction. It takes as inputs the data read from memory and the `funct3` field of the load instruction, and outputs the decoded data.

## Testing

The testbench can be found here: [testbench/data_mem_wrapper](/testbench/data_mem_wrapper/)
