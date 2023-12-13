# Testbenches

This folder contains unit tests for each module, as well as the top-level testbench. 

The unit tests are lightweight tests that do not simulate the whole RISC-V CPU so can be used to quickly identify errors in the DUT. The unit tests are written in SystemVerilog and use the GoogleTest framework. 

The unit tests are run in a CI-pipeline, defined in the `.github/workflows/c-cpp.yml` file. The CI-pipeline runs on a locally-hosted runner which is a remote linux-server running Ubuntu 22:04 LTS. The unit tests run on every push and pull request to `master` branch.

## Table of Contents
- [Running the unit tests locally](#running-the-unit-tests-locally)
- [Unit Test Results](#unit-test-results)
    - [1. Register File](#1-register-file)
    - [2. ALU](#2-alu)
    - [3. Sign Extend](#3-sign-extend)
    - [4. Data Memory Wrapper](#4-data-memory-wrapper)
    - [5. Control Unit](#5-control-unit)
- [Single Instruction Tests](#single-instruction-tests)
    - [Run the Single Instruction Tests Locally](#run-the-single-instruction-tests-locally)
    - [Test Results](#test-results)
        - [1. ADDI](#1-addi)
        - [2. Load/Store Instructions](#loadstore-instructions)
        - [3. B-type Instructions](#b-type-instructions)
        - [4. U-type Instructions](#u-type-instructions)
        - [5. Jump Instructions](#jump-instructions)
        - [6. R-type Instructions](#r-type-instructions)



## Running the unit tests locally

If you would like to run the unit tests locally, you can do so by running the following command in the root directory of the project:

```make runtest GTEST=1 VBUDDY=0 RUN=module MODULE=<module_name> MODULE.INCLUDE_DIRS="-y <path_to_dir1> -y <path_to_dir2> ..."```

Where `<module_name>` refers to the name of the module, and `<path_to_dir1>` is the first dependent folder, `<path_to_dir2>` is the second dependent folder, and so on.

Note: Be sure to run `make clean` after running each test to clean up the generated files.

## Unit Test Results

### 1. Register File:
``` make runtest RUN=module GTEST=1 MODULE=reg_file MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/reg_file/readme.md).
![Alt text](/images/reg_file_test_results.png)

#### Line Coverage:
The register file unit tests hit all of the lines, except for the debug view lines, which do not affect the functionality of the module.
![Alt text](/images/reg_file_line_coverage.png)

### 2. ALU:
``` make runtest RUN=module GTEST=1 MODULE=alu MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/alu/readme.md).
![Alt text](/images/gtest-results-alu-testbench.png)

#### Line Coverage:
The ALU unit tests hit all of the lines.
![Alt text](/images/code-coverage-alu.png)

### 3. Sign Extend:

```make runtest RUN=module GTEST=1 MODULE=sign_extend MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/sign_extend/readme.md).

![Alt text](/images/sign_extend_test_results.png)

#### Line Coverage:

The sign extend unit tests hit all of the lines.

![Alt text](/images/sign_extend_line_coverage.png)

### 4. Data Memory Wrapper:

```make runtest RUN=module GTEST=1 MODULE=data_mem_wrapper MODULE.INCLUDE_DIRS="-y rtl/data_mem -y rtl/we_decoder -y rtl/ld_decoder"```

Details about the tests can be found [here](/testbench/data_mem_wrapper/readme.md).

![Alt text](/images/data_mem_wrapper_test_results.png)

#### Line Coverage:

Unfortunately due to a known bug, the line coverage for GoogleTests that use data memory (such as the unit test for data_mem_wrapper) available. The issue is a segmentation fault while running.
`VerilatedCov::write("logs/coverage_data_mem_wrapper.dat");`

We hope to fix this issue in the future. Pull requests are welcome!

### 5. Control Unit:

```make runtest GTEST=1 VBUDDY=0 RUN=module MODULE=control_unit MODULE.INCLUDE_DIRS="-y rtl/control_unit/decoders"```

![Alt text](/images/control_unit_test_results_excerpt.png)

#### Line Coverage:

![Alt text](/images/control_unit_line_coverage.png)


## Single Instruction Tests

### Run the Single Instruction Tests Locally
In order to verify the top-level behaviour of the CPU at each instruction, we have created a set of assembly programs that test a single instruction and can be found in [programs/single_instruction_tests](/programs/single_instruction_tests/) against a testbench that can be found in [risc_v_single_instruction_tests.h](/testbench/risc_v/versions/risc_v_single_instructions.h)

The testbench is run using the following command:

```make runtest RUN=unit GTEST=1 VBUDDY=0 SINGLE_INSTRUCTION_TESTS=1```

### Test Results

The tests are carried out in a sequential order and incorporating new instructions in each GoogleTest so that it is clear which instructions are failing. The results of the tests are shown below:

#### 1. ADDI

```addi a1, x0, 5```

![Alt text](/images/addi_waveform.png)

The test asserts that after one clock tick, the register file should have the value 5 in register a1.

#### Load/Store Instructions
##### 2. LB 
```
lui a1, 0x10 
lb a0, 0(a1) # Load the 1st byte in memory to a0
lb a0, 1(a1) # Load the 2nd byte in memory to a0
lb a0, 2(a1) # Load the 3rd byte in memory to a0
...
```

![Alt text](/images/lb_waveform.png)

The test does one clock tick to execute the LUI instruction. Then it does a number of clock cycles, after each one it asserts that the register loads the sign-extended byte from memory. The remaining load instructions are tested in the same way.

##### 3. LH
![Alt text](/images/lh_waveform.png)
##### 4. LW
![Alt text](/images/lw_waveform.png)
##### 5. LBU
![Alt text](/images/lbu_waveform.png)
##### 6. LHU
![Alt text](/images/lhu_waveform.png)

##### 7. SB
```
addi a0, zero, 0x12 # Compute value we want to store memory, and store in a0.
sb a0, 0x5(zero) # Store the value of a0 in the fifth byte of memory.
lbu a1, 0x5(zero) # Load the value in fifth byte of memory into a1 register.
```
The test asserts that storing 0x12 and loading it back from memory, we get 12.
![Alt text](/images/sb_waveform.png)

##### 8. SH
Similarly, the test asserts that storing 0x0123 and loading it back from memory, we get 0x0123.
![Alt text](/images/sh_waveform.png)
##### 9. SW
TODO: For some reason there isn't a SW test yet.
#### B-type Instructions
##### 10. BEQ
##### 11. BNE
##### 12. BGE
##### 13. BGEU
##### 14. BLT
##### 15. BLTU

#### U-type Instructions
##### 16. LUI
##### 17. AUIPC

#### Jump Instructions
##### 18. JAL
##### 19. JALR

#### R-type Instructions
Most instructions are tested, since the ALU is tested in the unit tests.
##### 20. ADD
##### 21. SUB
##### 22. SLL
##### 23. SLT
##### 24. AND
##### 25. OR
##### 26. XOR
