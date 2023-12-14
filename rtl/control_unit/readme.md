# Design Specification for Control Unit (RV32I)

## Overview
The control unit is a crucial component of a RISC-V 32I processor. It is responsible for generating control signals based on the instruction opcode, funct3, and funct7 fields. These control signals guide the operation of other components in the processor, such as the ALU, memory, and registers.

## Parameters

| Parameter       | Default Value | Description                                      |
|-----------------|---------------|--------------------------------------------------|
| OP_WIDTH        | 7             | Width of the opcode field in the instruction     |
| FUNCT3_WIDTH    | 3             | Width of the funct3 field in the instruction     |
| ALU_CTRL_WIDTH  | 4             | Width of the ALUControl signal                   |
| IMM_SRC_WIDTH   | 3             | Width of the ImmSrc signal                       |
| ALU_OP_WIDTH    | 3             | Width of the ALUOp signal                        |


## Inputs
The control unit takes the following inputs:

| Signal   | Width | Description                                                  |
|----------|-------|--------------------------------------------------------------|
| op       | `OP_WIDTH`     | The opcode of the current instruction                         |
| funct3   | `FUNCT3_WIDTH`     | The funct3 field of the current instruction                   |
| funct7_5 | 1     | Bit 5 of the funct7 field of the current instruction          |
| Zero     | 1     | A signal indicating whether the ALU result is zero            |
| N        | 1     | A signal indicating whether the ALU result is negative        |
| C        | 1     | A signal indicating whether a carry occurred in the ALU       |
| V        | 1     | A signal indicating whether a signed overflow occurred in the ALU |

## Outputs
The control unit generates the following outputs:

| Signal      | Width | Description                                                  |
|-------------|-------|--------------------------------------------------------------|
| PCSrc       | 1     | A signal indicating the source of the next program counter value |
| ResultSrc   | 2     | A signal indicating the source of the result to be written back to the register file |
| MemWrite    | 1     | A signal indicating whether a memory write operation should be performed |
| ALUControl  | `ALU_CONTROL_WIDTH`     | A signal controlling the operation of the ALU |
| ALUSrc      | 1     | A signal indicating the source of the second operand for the ALU |
| ImmSrc      | `IMM_SRC_WIDTH`     | A signal indicating the source of the immediate value |
| RegWrite    | 1     | A signal indicating whether a register write operation should be performed |
| Jump        | 1     | A signal indicating whether a jalr operation should be performed |

## Functionality
The control unit decodes the opcode, funct3, and funct7 fields of the current instruction (where they exist) and generates the appropriate control signals. It uses two submodules, `main_decoder` and `alu_decoder`, to perform this decoding.

## Main Decoder

The `main_decoder` generates most of the control signals, including `Branch`, `ResultSrc`, `MemWrite`, `ALUSrc`, `ImmSrc`, `RegWrite`, `ALUOp`, and `Jump`.

### R-type Control Path
![single-cycle-control-path-r-type](/images/r-type_control_path.png)

### I-type Control Path
![single-cycle-control-path-i-type](/images/i-type_control_path.png)

### S-type Control Path
![single-cycle-control-path-s-type](/images/s-type_control_path.png)

### B-type Control Path
![single-cycle-control-path-b-type](/images/b-type_control_path.png)

### AUIPC Control Path
![single-cycle-control-path-auipc](/images/AUIPC_control_path.png)

### LUI Control Path
![single-cycle-control-path-lui](/images/LUI_control_path.png)

### JALR Control Path
![single-cycle-control-path-jalr](/images/JALR_control_path.png)

### J-type Control Path (JAL)
![single-cycle-control-path-j-type](/images/JAL_control_path.png)


## ALU Decoder

The `alu_decoder` generates the `ALUControl` signal based on the opcode, funct3, funct7_5, and `ALUOp` signals. 

![](/images/ALU_decoder.png)

## Control unit 

The control unit also contains logic to generate the `PCSrc` signal, which determines the source of the next program counter value. This logic handles jump and branch instructions and is derived using the flags N (negative), C (carry), Z (zero), V (signed error) and B (branch) in junction with the intermediary signal: S (signed_greater_than).

The logic for S is: `(~N & ~V) | Z | (N & V)`, effectively checking for a zero, or a positive result in from signed subtraction. 

| Instruction type | Instruction | Function                                   | PCSrc  |
|------------------|-------------|--------------------------------------------|--------|
| J-Type           | JAL         | Jump and Link                              | 1      |
| J-Type           | JALR        | Jump and Link Register                     | 1      |
| B-Type           | BEQ         | Branch if equal                            | B & Z  |
| B-Type           | BNE         | Branch if not equal                        | B & ~Z |
| B-Type           | BLT         | Branch if less than                        | B & ~S |
| B-Type           | BGE         | Branch if greater than or equal            | B & S  |
| B-Type           | BLTU        | Branch if less than (unsigned)             | B & C  |
| B-Type           | BGEU        | Branch if greater than or equal (unsigned) | B & ~C |
| -                | -           | Default/Other case                         | 0      |

## Constraints and Assumptions
The control unit is designed for a RISC-V 32I processor and assumes that instructions are 32 bits wide. It also assumes that the processor uses a little-endian memory system.
