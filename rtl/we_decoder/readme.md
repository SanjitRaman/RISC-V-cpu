# Design Specification for a Write Enable Decoder

## Overview
The Write Enable Decoder (`we_decoder`) is a critical component of a RISC-V 32I processor. It is responsible for generating write enable signals based on the `funct3` field of the current instruction and the `MemWrite` signal.

## Schematic

**TODO: [Insert ISSIE Schematic Here]**

## Inputs
The `we_decoder` takes the following inputs:
- `funct3`: The funct3 field of the current instruction (3 bits).
- `MemWrite`: A signal indicating whether a memory write operation should be performed (1 bit).

## Outputs
The `we_decoder` generates the following outputs:
- `WE0`: A write enable signal for the least significant byte (1 bit).
- `WE1`: A write enable signal for the second least significant byte (1 bit).
- `WE2`: A write enable signal for the second most significant byte (1 bit).
- `WE3`: A write enable signal for the most significant byte (1 bit).

## Functionality
The `we_decoder` decodes the `funct3` field of the current instruction and generates the appropriate write enable signals. It supports the following store operations:
- Store byte (sb): Only `WE0` is enabled.
- Store half (sh): `WE0` and `WE1` are enabled.
- Store word (sw): All write enable signals (`WE0` to `WE3`) are enabled.

If the `funct3` field does not match any of the above operations or if MemWrite is not asserted, all write enable signals are deasserted.

## Constraints and Assumptions
The `we_decoder` is designed for a RISC-V 32I processor and assumes that instructions are 32 bits wide. It also assumes that the processor uses a little-endian memory system, and thus the least significant byte is stored at the lowest address.