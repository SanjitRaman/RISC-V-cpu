# Design Specification for the ld_decoder Module

## Overview
The `ld_decoder` module is a load instruction decoder for a RISC-V processor. It is designed to decode load instructions and perform sign extension or zero extension based on the `funct3` field of the instruction.

## Schematic
![ld_decoder schematic](/images/ld_decoder_schematic.png)

## Parameters
- `DATA_WIDTH`: The width of the data bus. Default is 32.

## Inputs
- `RD`: The data read from memory.
- `funct3`: The `funct3` field of the load instruction.

## Outputs
- `RDOut`: The output data after decoding the load instruction.

## Functionality
The `ld_decoder` module uses a combinational always block to decode the load instruction based on the `funct3` field.

| funct3   | Operation                      | Output                  |
|----------|--------------------------------|-------------------------|
| 3'b000   | Sign extension on byte load    | Sign-extended byte      |
| 3'b001   | Sign extension on half-word load | Sign-extended half-word |
| 3'b010   | Word load                      | Word                    |
| 3'b100   | Zero extension on byte load    | Zero-extended byte      |
| 3'b101   | Zero extension on half-word load | Zero-extended half-word |
| Other    | Error                          | Zero                    |
