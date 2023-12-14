# Specification for the sign_extend Module
## Overview
The `sign_extend` module in SystemVerilog is designed to perform sign extension on a given input instruction (`Instr`) based on the immediate source (`ImmSrc`). The sign extension is a process of increasing the number of bits of a binary number while preserving the number's sign (positive/negative) and value.

**Parameters** 

The parameters for the sign extend module are as follows: 

| Signal  | Default | Description                                                |
|-------------------|---------|------------------------------------------------------------|
| `DATA_WIDTH`      | 32      | The width of the data.                                     |
| `IMM_SRC_WIDTH`   | 3       | The width of the immediate source. Default is 3 as there are 5 ways of addressing the immediate input. |

**Inputs**  

The input signals for the sign extend module are as follows: 

|  Signal           | Width           | Description                                                |
|-------------------|-----------------|------------------------------------------------------------|
| `Instr`           | `DATA_WIDTH`    | A `DATA_WIDTH`-bit input instruction.                       |
| `ImmSrc`          | `IMM_SRC_WIDTH` | A `IMM_SRC_WIDTH`-bit immediate source.                     |

**Outputs** 

The output signals for the sign extend module are as follows: 

| Signal            | Width           | Description                                                |
|-------------------|-----------------|------------------------------------------------------------|
| `ImmOp`           | `DATA_WIDTH`    | A `DATA_WIDTH`-bit output after sign extension.             |


## Operation
The module performs different operations based on the value of ImmSrc:

| ImmSrc | Instruction Type | ImmOp                                             |
|--------|-----------------|--------------------------------------------------|
| 000    | I-type          | Concatenate Instr[31] and Instr[31:20]            |
| 001    | S-type          | Concatenate Instr[31], Instr[31:25], Instr[11:7]  |
| 010    | B-type          | Concatenate Instr[31], Instr[7], Instr[30:25], Instr[11:8], and 1'b0 |
| 011    | U-type          | Concatenate Instr[31:12] and 12'b0                |
| 100    | J-type          | Concatenate 11'b0, Instr[31], Instr[19:12], Instr[20], Instr[30:21], and 1'b0 |
| Other  | -               | Concatenate Instr[31] and Instr[31:20]            |
