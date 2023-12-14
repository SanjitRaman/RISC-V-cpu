# Design Specification for Control Unit (RV32I)

## Overview
The control unit is a crucial component of a RISC-V 32I processor. It is responsible for generating control signals based on the instruction opcode, funct3, and funct7 fields. These control signals guide the operation of other components in the processor, such as the ALU, memory, and registers.

## Inputs
The control unit takes the following inputs:

- `op`: The opcode of the current instruction (7 bits).
- `funct3`: The funct3 field of the current instruction (3 bits).
- `funct7_5`: Bit 5 of the funct7 field of the current instruction (1 bit).
- `Zero`: A signal indicating whether the ALU result is zero (1 bit).
- `N`: A signal indicating whether the ALU result is negative (1 bit).
- `C`: A signal indicating whether a carry occurred in the ALU operation (1 bit).
- `V`: A signal indicating whether a signed overflow occurred in the ALU operation (1 bit).

## Outputs
The control unit generates the following outputs:

- `PCSrc`: A signal indicating the source of the next program counter value (1 bit).
- `ResultSrc`: A signal indicating the source of the result to be written back to the register file (2 bits).
- `MemWrite`: A signal indicating whether a memory write operation should be performed (1 bit).
- `ALUControl`: A signal controlling the operation of the ALU (4 bits).
- `ALUSrc`: A signal indicating the source of the second operand for the ALU (1 bit).
- `ImmSrc`: A signal indicating the source of the immediate value (3 bits).
- `RegWrite`: A signal indicating whether a register write operation should be performed (1 bit).
- `Jump`: A signal indicating whether a jump operation should be performed (1 bit).

## Functionality
The control unit decodes the opcode, funct3, and funct7 fields of the current instruction (where they exist) and generates the appropriate control signals. It uses two submodules, `main_decoder` and `alu_decoder`, to perform this decoding.

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


The `alu_decoder` generates the `ALUControl` signal based on the opcode, funct3, funct7_5, and `ALUOp` signals. 

**TODO:** **[Insert link to ALU operations table.]**

The control unit also contains logic to generate the `PCSrc` signal, which determines the source of the next program counter value. This logic handles jump and branch instructions.

**TODO:** **[Insert logic table using flags for this]**

## Constraints and Assumptions
The control unit is designed for a RISC-V 32I processor and assumes that instructions are 32 bits wide. It also assumes that the processor uses a little-endian memory system.
