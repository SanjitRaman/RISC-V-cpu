# RISC-V CPU

This repository contains design and testing work for a RISC-V CPU by a group of students at Imperial College London for the Autumn Term Coursework of Instruction Architectures and Compilers course.

There is a single-cycle implementation, as well as a 5-stage pipeline implementation of the CPU.

The course is designed to work with a piece of hardware developed by Imperial College called the VBuddy. This is a board containing a microprocessor and a number of peripherals that allow for SystemVerilog designs to be simulated in Verilator and simultaneously outputing to peripherals such as the TFT Screen and NeoPixel LEDs. You can read more about the VBuddy [here](http://www.ee.ic.ac.uk/pcheung/teaching/EIE2-IAC/Lecture%203%20-%20Verilator%20&%20Testbenches%20(notes).pdf)

## Contributions
Group Members: Sanjit Raman, Sriyesh Bogadapati, Dhyey Trivedi, Arav Swati-Abhay

We assigned different people to write the design and testbench of each module to:
-  maximise the number of people who would be able to understand the codebase,
- find the most errors in the implementation. 

To allow parallel development in extending the CPU from the [Reduced RISC-V Lab](https://github.com/SanjitRaman/Team-10-Reduced-RISC-V) we split up implementation of each instruction type to different people. This would also mean group members need to understand and modify the design of the modules they did not initially write.

The table below shows the modules that each person was responsible for. A detailed breakdown of the contributions of each person can be found in the [individual statements](TODOINSERTLINK).


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
|                    | Testbench | X        |      |       |      |
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