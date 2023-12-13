# Design Specification for a Load Decoder

## Overview
The Load Decoder (`ld_decoder`) is a key component of a RISC-V 32I processor. It is responsible for decoding load instructions and preparing the data to be loaded into the register file, taking into account the little-endian memory system.

## Schematic

**TODO: [Insert ISSIE Schematic Here]**

## Inputs
The Load Decoder takes the following inputs:

- `RD`: The data read from the data memory or cache (32 bits).
- `funct3`: The `funct3` field of the current instruction (3 bits).

## Outputs
The Load Decoder generates the following output:

- `RDOut`: The data to be loaded into the register file (32 bits).

## Functionality
The Load Decoder decodes the `funct3` field of the current instruction and prepares the data to be loaded into the register file accordingly. It supports the following load operations:

**TODO: [Check the wording for little-endian-ism]**

- Load byte (`lb`): The least significant byte of `RD` is sign-extended and output on `RDOut`.
- Load half (`lh`): The two least significant bytes of `RD` are sign-extended and output on `RDOut`.
- Load word (`lw`): The four bytes of `RD` are reversed to account for the little-endian memory system and output on `RDOut`.
- Load byte unsigned (`lbu`): The least significant byte of `RD` is zero-extended and output on `RDOut`.
- Load half unsigned (`lhu`): The two least significant bytes of `RD` are zero-extended and output on `RDOut`.

If the `funct3` field does not match any of the above operations, `RDOut` is set to zero.

## Constraints and Assumptions
The Load Decoder is designed for a RISC-V 32I processor and assumes that instructions are 32 bits wide. It also assumes that the processor uses a little-endian memory system, and thus the byte order of the data read from memory is reversed for `lw` operations.
