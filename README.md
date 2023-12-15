# RISC-V CPU

This repository contains design and testing work for a RISC-V CPU by a group of students at Imperial College London for the Autumn Term Coursework of Instruction Architectures and Compilers course.

There is a single-cycle implementation, as well as a 5-stage pipeline implementation of the CPU.

The course is designed to work with a piece of hardware developed by Imperial College called the VBuddy. This is a board containing a microprocessor and a number of peripherals that allow for SystemVerilog designs to be simulated in Verilator and simultaneously outputing to peripherals such as the TFT Screen and NeoPixel LEDs. You can read more about the VBuddy [here](http://www.ee.ic.ac.uk/pcheung/teaching/EIE2-IAC/Lecture%203%20-%20Verilator%20&%20Testbenches%20(notes).pdf)

Note: this is only a partial implementation of cache to a 5 stage pipelined RISC-V processor

## Folder Structure
* [rtl](/rtl/) contains the SystemVerilog code for the CPU. Each module has its own folder, containing any sub-modules.

* [programs](/programs/) contains the assembly code and data memory files for the programs that can be run on the CPU. 

    * To run a new program: add a folder with the program name and add the assembly code and data memory files to the folder. The makefile will automatically assemble the assembly code into a memory file that can be loaded into the CPU.


## Installation and Setup:

1. Simulation is done on Verilator, and the Makefile uses the assembler from the RISC-V toolchain. You can install these dependencies by following the instructions in [Lab 0 Dev Tools and Dependencies](https://github.com/EIE2-IAC-Labs/Lab0-devtools)

2. Additionally, To support google tests, you will need to install the Google Test library. This can be done by running the following command:

    ```make gtest```

    This will install google test in the a new directory called `googletest/`.

3. To configure VBuddy, modify `vbuddy/vbuddy.cfg` to point to the correct usb port.

## Usage

The makefile supports multiple tasks:

1. Each of the below programs assembles the corresponding assembly file from [programs](/programs/) into a instr_mem.mem file. This, along with the data_mem.mem file is loaded into the memory of the CPU for simulation.

    a. Counter Program

    ```make runtest GTEST=0 VBUDDY=1 PROGRAM_NAME=counter```

    b. Sinegen Program

    ```make runtest GTEST=0 VBUDDY=1 PROGRAM_NAME=sinegen```
    
    c. Starting Light Program

    ```make runtest GTEST=0 VBUDDY=1 PROGRAM_NAME=f1_starting_light```

    d. PDF Program

    ```make runtest GTEST=0 VBUDDY=1 PROGRAM_NAME=pdf```
    
    **Note**: the contents of [data_mem.mem](/programs/pdf/data_mem.mem) must be manually replaced with the data set you would like to run the pdf program on. Sample data sets can be found in the [programs/pdf](/programs/pdf/) directory.

2. Run a simulation of the entire CPU for each instruction and generate a waveform
    
    ```make runtest GTEST=1 VBUDDY=0 SINGLE_INSTRUCTION_TESTS=1```


## Contributions

| Group Members       | GitHub Username     | Individual Statements |
|---------------------|---------------------|-----------------------|
| Sanjit Raman        | [@SanjitRaman](https://github.com/SanjitRaman) | [Statement](/statements/sanjit.md) |
| Sriyesh Bogadapati  | [@sri-yeah](https://github.com/sri-yeah) | [Statement](/statements/sriyesh.md) |
| Dhyey Trivedi       | [@Cheesypasta1](https://github.com/Cheesypasta1) | [Statement](/statements/dhyey.md) |
| Arav Swati-Abhay    | [@as9322](https://github.com/as9322) | [Statement](/statements/arav.md) |

We assigned different people to write the design and testbench of each module to:
-  maximise the number of people who would be able to understand the codebase,
- find the most errors in the implementation. 

To allow parallel development in extending the CPU from the [Reduced RISC-V Lab](https://github.com/SanjitRaman/Team-10-Reduced-RISC-V) we split up implementation of each instruction type to different people. This would also mean group members need to understand and modify the design of the modules they did not initially write.

The table below shows the modules that each person was responsible for. A detailed breakdown of the contributions of each person can be found in the [individual statements](/statements/).


Furthermore, to ensure that everyone was able to understand the codebase, we had a rule that pull requests could not be merged without review by another person. 

- x - represents a person was fully responsible for the task

- p - represents a person was partially responsible for the task

| Modules/Name       |           | Sanjit   | Sri  | Dhyey | Arav |
|--------------------|-----------|----------|------|-------|------|
|                    |           |  **Single Cycle**        |      |       |      |
| **alu**                | Design    |          | x    |       |      |
|                    | Testbench |          |      |       | x    |
| **control_unit**       | Design    | x        | p    |       |      |
|                    | Testbench | p        | p    |       |      |
| **data_mem**           | Design    |          |      |       | x    |
|                    | Testbench |          |      | x     |      |
| **instr_mem**          | Design    |          |      |       | x    |
|                    | Testbench |          |      | x     |      |
| **pc**                 | Design    |          |      | x     |      |
|                    | Testbench |          | x    |       |      |
| **pc_wrapper**         | Design    | x        |      |       |      |
|                    | Testbench | scrapped |      | x     |      |
| **reg_file**           | Design    |          | x    |       |      |
|                    | Testbench | x        |      |       |      |
| **sign_extend**        | Design    | x        |      |       |      |
|                    | Testbench |          | p    |       |      |
| **risc_v**             | Design    | p        |      |       | p    |
|                    | Testbench | x        |      |       |      |
| **Testbench**          |           | x        |      |       | x    |
| **R-type**             |           | (tb)     | x    |       |      |
| **I-type**             |           | (tb)     |      | p     | p    |
| **S-type**             |           |          |      | x     |      |
| **B-type**             |           | x        | (tb) |       |      |
| **U-type**             |           |          | x    |       |      |
| **J-type**             |           |          | x    |       |      |
|           |           |      **Extra**    |      |       |      |
| **Google tests**       |           | x        |      |       |      |
| **Make file**          |           | x        |      |       |      |
| **lw**                 |           | p        |      |       | p    |
| **Github CI Pipeline** |           | x        |      |       |      |
| | | **Pipelining** | | | | 
| **New top level schematic** | | | x | | | 
| **Update registers** | | | x | | | 
|  **Hazard unit** | | | | x | p | 
| **Updated top level** | |  | x | | | 
|  **Testing hazard unit** | | | | x | | 
|  **Integration testing** | | x | x | x | x | 
| | | **Cache** | | | | 
| **Cache module design** | | x | x | x | x | 
| **Cache module debugging** |  | x | x | x | x | 
|  **Updated hazard unit** | | x | x | x | x | 
|  **Updated top level** | | x | x | x | x | 

