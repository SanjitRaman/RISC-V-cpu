# Flags Design Specification

## Overview
The `flags` module is responsible for generating control signals related to program counter updates based on certain flags and opcode information. It facilitates the decision-making process for branching and jumping instructions. 

## Parameters
| Parameter       | Description                           | Default |
|-----------------|---------------------------------------|---------|
| OP_WIDTH        | Width of the operation code signal.    | 7       |
| FUNCT3_WIDTH    | Width of the funct3 signal.            | 3       |

## Inputs
| Signal          | Width | Description                                              |
|-----------------|-------|----------------------------------------------------------|
| `Zero`          | 1     | Zero flag indicating the result of an operation.         |
| `N`             | 1     | Negative flag indicating a negative result.              |
| `C`             | 1     | Carry flag indicating an arithmetic carry-out.           |
| `V`             | 1     | Overflow flag indicating a signed arithmetic overflow.   |
| `Branch`        | 1     | Branch control signal.                                   |
| `op`            | OP_WIDTH | Operation code signal.                                |
| `funct3`        | FUNCT3_WIDTH | Funct3 signal providing additional opcode information.|

## Outputs
| Signal          | Width | Description                                              |
|-----------------|-------|----------------------------------------------------------|
| `PCSrc`         | 1     | Program Counter Source control signal for branching/jumping instructions. |

## Functionality
The `flags` module utilizes a combination of input flags (`Zero`, `N`, `C`, `V`) and opcode information (`op` and `funct3`) to determine the `PCSrc` signal. This signal controls whether the program counter should be updated based on branching or jumping instructions. Below is the table showing the logic. 

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

This logic was extracted from the control unit, and moved into a new module to put the computation for the flags in the right part of the pipelining stage. 