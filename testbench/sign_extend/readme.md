# Test Methodology for Sign Extend Module

## Introduction
This document outlines the test methodology for the `sign_extend` module in the `rtl/sign_extend/` directory. The tests are implemented in the `sign_extend_tb.cpp` file in the `testbench/` directory. The specification for the `sign_extend` module is provided in the `readme.md` file.

## Test Environment
The test environment is set up using the [Google Test framework](/testbench/readme.md). The `sign_extend` module is instantiated in the testbench, and its inputs and outputs are connected to the testbench signals.

## Test Cases

![Instruction format](/images/risc-v_instruction_format.png)

### Test Case 1: I-type Instructions (ImmSrc = 000)
This test verifies that the `sign_extend` module correctly extends I-type instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to 000 and checks that the output is the sign extenstion of `Instr[31]` concatenated with the 12 bit immediate `Instr[31:20]`.

### Test Case 2: S-type Instructions (ImmSrc = 001)
This test verifies that the `sign_extend` module correctly extends S-type instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to 001 and checks that the output is the sign extenstion of `Instr[31]` concatenated with the 12 bit immediate `Instr[31:25]` and `Instr[11:7]`.

### Test Case 3: B-type Instructions (ImmSrc = 010)
This test verifies that the `sign_extend` module correctly extends B-type instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to 010 and checks that the output is the sign extenstion of `Instr[31]` followed by the concatenation of `Instr[7]`, `Instr[30:25]`, `Instr[11:8]`, and `1'b0`.

### Test Case 4: U-type Instructions (ImmSrc = 011)
This test verifies that the `sign_extend` module correctly pads U-type instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to 011 and checks that the output is the concatenation of `Instr[31:12]` and `12'b0`.

### Test Case 5: J-type Instructions (ImmSrc = 100)
This test verifies that the `sign_extend` module correctly pads J-type instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to 100 and checks that the output is the concatenation of `11'b0`, `Instr[31]`, `Instr[19:12]`, `Instr[20]`, `Instr[30:21]`, and `1'b0`.

### Test Case 6: Other Instructions
This test verifies that the `sign_extend` module correctly extends other instructions. The test inputs a random instruction to the `sign_extend` module with `ImmSrc` set to a value other than 000, 001, 010, 011, or 100 and checks that the output is the sign extension of `Instr[31]` concatenated with `Instr[31:20]`.

## Test Execution
The tests are executed using the Google Test framework. The test results are logged and can be viewed in the console or in the log file.

## Conclusion
These tests provide comprehensive coverage of the `sign_extend` module functionality as described in the specification. By passing these tests, we can be confident that the `sign_extend` module is working as expected.
