# Design Specification for the `we_decoder` Module

## Overview
The `we_decoder` module is a write enable decoder for a RISC-V processor. It is designed to decode store instructions and generate write enable signals based on the `funct3` field of the instruction.

## Schematic

![we_decoder schematic](/images/we_decoder_schematic.png)

**Inputs**

The inputs for the module are as follows:

| Signal    | Width | Description                                                |
|-----------|-------|------------------------------------------------------------|
| `funct3`  | 3    | The `funct3` field of the store instruction.               |
| `MemWrite`| 1    | A signal indicating whether a memory write operation is to be performed.|

**Outputs**

The outputs for the module are as follows:

| Signal | Width | Description                                       |
|--------|-------|---------------------------------------------------|
| `WE0`  | 1    | Write enable signal for the least significant byte.|
| `WE1`  | 1    | Write enable signal for the second byte.           |
| `WE2`  | 1    | Write enable signal for the third byte.            |
| `WE3`  | 1    | Write enable signal for the most significant byte. |


## Functionality
The `we_decoder` module uses a combinational `always_comb` block to decode the store instruction based on the `funct3` field and the `MemWrite` signal.

| Type   | `funct3` | `MemWrite` | `WE3` | `WE2` | `WE1` | `WE0` |
| -      |----------|------------|-------|-------|-------|-------|
| byte   | 3'b000   | High       | Low   | Low   | Low   | High  |
| half   | 3'b001   | High       | Low   | Low   | High  | High  |
| word   | 3'b010   | High       | High  | High  | High  | High  |
|        | Other    | High       | Low   | Low   | Low   | Low   |
|        |   X      | Low        | Low   | Low   | Low   | Low   |
