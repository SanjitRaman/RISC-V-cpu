# Design Specification for a RISC-V 32I ALU

## Overview

The Arithmetic Logic Unit (ALU) is a fundamental component of a RISC-V 32I processor. It performs various arithmetic and logical operations based on the control signals it receives.

## Parameters

| Parameter           | Default Value | Description                                        |
|---------------------|-------|----------------------------------------------------|
| `DATA_WIDTH`        | 32    | The width of the input and output data (in bits)    |
| `ALU_CTRL_WIDTH`    | 4     | The width of the ALU control signal (in bits)       |
| `SHIFT_WIDTH`       | 5     | The width of the shift amount (in bits)             |

## Inputs

The ALU takes the following inputs:

| Signal        | Width  | Description                                        |
|--------------|-------|------------------------------------------------------|
| `SrcA`       |   `DATA_WIDTH`  | The first operand for the ALU operation               |
| `SrcB`       | `DATA_WIDTH`  | The second operand for the ALU operation              |
| `ALUControl` | `ALU_CONTROL_WIDTH`  | A control signal that determines the ALU operation   |

## Outputs

The ALU generates the following outputs:

| Signal     | Width | Description                                            |
|------------|-------|--------------------------------------------------------|
| `ALUResult`| `DATA_WIDTH`    | The result of the ALU operation                         |
| `Zero`     | 1     | A signal indicating whether the ALU result is zero      |
| `N`        | 1     | A signal indicating whether the ALU result is negative |
| `C`        | 1     | A signal indicating whether a unsigned overflow occurred            |
| `V`        | 1     | A signal indicating whether a signed overflow occurred        |

### `ALUResult`

The `ALUResult` is the result of the ALU operation and represents the outcome of the arithmetic or logical operation performed on the input operands. The table below shows the supported ALU operations and its encoding as a `ALUControl` signal:

| ALU Control | Instruction | Operation              | English Translation | Description                                                     |
|-------------|-------------|------------------------|---------------------|-----------------------------------------------------------------|
| 0000        | ADD         | rd = rs1 + rs2         | Addition            | Performs addition of rs1 and rs2 and stores the result in rd.    |
| 0001        | SUB         | rd = rs1 - rs2         | Subtraction         | Performs subtraction of rs2 from rs1 and stores the result in rd.|
| 0010        | SLL         | rd = rs1 << rs2<sub>[4:0]</sub>         | Logical Shift Left  | Performs logical shift left of rs1 by rs2 bits and stores the result in rd. |
| 0011        | SLT         | rd = rs1 < rs2         | Set Less Than       | Sets rd to 1 if rs1 is less than rs2, otherwise sets rd to 0.    |
| 0100        | SLTU        | rd = rs1 < rs2         | Set Less Than Unsigned | Sets rd to 1 if rs1 is less than rs2 (unsigned comparison), otherwise sets rd to 0. |
| 0101        | XOR         | rd = rs1 ^ rs2         | XOR                 | Performs bitwise XOR of rs1 and rs2 and stores the result in rd.|
| 0110        | SRL         | rd = rs1 >> rs2<sub>[4:0]</sub>        | Logical Shift Right | Performs logical shift right of rs1 by rs2 bits and stores the result in rd. |
| 0111        | SRA         | rd = rs1 >>> rs2<sub>[4:0]</sub>         | Arithmetic Shift Right | Performs arithmetic shift right of rs1 by rs2 bits and stores the result in rd. |
| 1000        | OR          | rd = rs1 \| rs2        | OR                  | Performs bitwise OR of rs1 and rs2 and stores the result in rd. |
| 1001        | AND         | rd = rs1 & rs2         | AND                 | Performs bitwise AND of rs1 and rs2 and stores the result in rd. |
| 1010        | LUI         | rd = rs1 \| (rs2 << 12) | Load Upper Immediate | Loads the upper 20 bits of rs2, left-shifted by 12 bits, and ORs it with rs1. The result is stored in rd. |

The ALU performs the operation specified by the `ALUControl` signal on the `SrcA` and `SrcB` operands. The operations include addition, subtraction, logical shift left, set less than, set less than unsigned, XOR, logical shift right, arithmetic shift right, OR, AND, and load upper immediate.

The `Zero`, `N`, `C`, and `V` signals are generated based on the result of the ALU operation. The `Zero` signal is set if the result is zero. The `N` signal is set if the result is negative. The `C` signal is set if a carry occurred in the operation. The `V` signal is set if an overflow occurred in the operation.


The logical expressions to generate these flags within the ALU using SrcA, SrcB, and ALUResult are as follows:


| Signal   | Expression                                   |
|----------|----------------------------------------------|
| Zero     | `(ALUResult == 0)`                     |
| N        | `(ALUResult < 0)`                         |
| C        | `Overflow bit from SrcA±SrcB`             |
| V        | `((SrcA < 0 & SrcB < 0 & ALUResult >= 0) \| (SrcA >= 0 & SrcB >= 0 & ALUResult < 0))` |




## Constraints and Assumptions

The ALU is designed for a RISC-V 32I processor and assumes that operands are 32 bits wide. It also assumes that the processor uses a little-endian memory system.