# RISC-V32I CPU Specification

## Overview

The RISC-V32I CPU is a 32-bit processor that implements the base integer instruction set (I) of the RISC-V open standard instruction set architecture (ISA). It is designed to be simple, efficient, and easy to implement, making it suitable for a wide range of applications.

## Section 1: Single Cycle 

### Features

- 32-bit architecture: The CPU operates on 32-bit data and addresses, allowing it to efficiently handle most common computing tasks.
- Base integer instruction set (I): The CPU implements the base integer instruction set of the RISC-V ISA, which includes instructions for integer arithmetic, logical operations, load/store into memory, and branching/jumping.
- Single-cycle execution: Each instruction is executed in a single cycle, which simplifies the CPU design and allows for high performance.
- All instructions except CSR are implemented.

### Schematic
![Single Cycle CPU Schematic](/images/single-cycle-schematic.png)


### Interfaces
#### Timing Interfaces
- Clock (CLK): The clock signal drives the operation of the CPU.
- Reset (RST): The reset signal initializes the CPU to a known state.
#### Debugging Interfaces
The design includes the following I/O ports for the purposes of debugging:
- PC Interface (`pc_viewer`) allows the user to view the PC
- Register file interface (`address_to_view`, `reg_output`) allows the user to view the value stored in the register file at the address specified by the `address_to_view`. To expose `a0` for the output of the reference program, the `address_to_view` should be `0xA`.

### Modules

The CPU is composed of several modules, each of which performs a specific function:

| Module           | Description                                                     |
|------------------|-----------------------------------------------------------------|
| PC               | Generates the address of the next instruction to be executed.    |
| Instruction memory | Fetches the instruction at the address provided by the PC.       |
| Control unit     | Decodes the instruction and constructs the control path.         |
| Register file    | Reads and writes data to the registers as directed by the control signals. |
| ALU              | Performs arithmetic and logical operations as directed by the control signals. |
| Data memory      | Reads and writes data to memory as directed by the control signals. |

### Operation

The operation of the CPU is driven by the clock signal. On each rising edge of the clock, the CPU fetches and decodes an instruction, reads data from the register file, performs an operation in the ALU, and writes data to the register file or memory as specified by the instruction. The CPU then updates the PC to the address of the next instruction, and the process repeats.


## Section 2: Pipelining 

### Features

- 32-bit architecture: The CPU operates on 32-bit data and addresses, allowing it to efficiently handle most common computing tasks.
- Base integer instruction set (I): The CPU implements the base integer instruction set of the RISC-V ISA, which includes instructions for integer arithmetic, logical operations, load/store into memory, and branching/jumping.
- 5 stage pipelined execution: Each instruction is executed in a single cycle, however the clock frequency is determined by the stage of the pipeline that takes the most amount of time, allowing for fast execution. 

### Pipelined schematic
Changes were made to get the pipelined schematic: 

Multiplexers added for new logic. 

![Pipelined CPU Schematic](/images/pipelined_schematic.png)


### Interfaces
Interfaces remained the same as single cycle. 

### Modules

The CPU is composed of several modules, each of which performs a specific function:

| Module           | Summary of changes                                              |
|------------------|-----------------------------------------------------------------|
| [**PC**](/rtl/pc/)| Stall F input signal added  |
| [Instruction memory](/rtl/instr_mem/) | |
| [Control unit](/rtl/control_unit/)    | |
| [Register file](/rtl/reg_file/)    |  |
| [ALU](/rtl/alu/)              | |
| [Data memory](/rtl/data_mem/)      | |
| [**Register file D**](/rtl/reg_file_d/) | Decode register added |
| [**Register file E**](/rtl/reg_file_e/) | Execute register added  |
| [**Register file M**](/rtl/reg_file_m/) | Memory register added  |
| [**Register file W**](/rtl/reg_file_w/) | Writeback register added  |
| [**Hazard unit**](/rtl/hazard_unit/) | Hazard unit added  |


### Operation

The operation of the CPU is driven by the clock signal. On each rising edge of the clock, the CPU fetches and decodes an instruction, reads data from the register file, performs an operation in the ALU, and writes data to the register file or memory as specified by the instruction. The CPU then updates the PC to the address of the next instruction, and the process repeats. 