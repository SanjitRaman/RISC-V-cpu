# Test Methodology Document for Register File Testbench

## Introduction
This document describes the test methodology used by the register file testbench located in [testbench/reg_file/reg_file_tb.cpp](TODOINSERTLINK) to validate the functionality of the register file as per the specification in [rtl/reg_file/readme.md](TODOINSERTLINK).

## Testbench Overview
The testbench uses the [Google Test framework](/testbench/readme.md) to define and run tests. It includes three test cases: ASYNCREAD, SYNCWRITE, and REG0. Each test case is designed to test a specific aspect of the register file's functionality.

## Test Cases
### ASYNCREAD
This test case verifies the asynchronous read functionality of the register file. It writes a unique value (the index) to each register and then reads back the values. The test asserts that the read values match the written values.

### SYNCWRITE
This test case verifies the synchronous write functionality of the register file. It writes a unique value (the index) to each register and then reads back the values in the same clock cycle. The test asserts that the read values match the written values.

### REG0
This test case verifies that register 0 is hardwired to 0 and cannot be changed. It attempts to write different values to register 0 and then reads back the value. The test asserts that the read value is always 0, regardless of the written value.

## Test Procedure
Each test case follows a similar procedure:
1. Write a value to a register.
2. Trigger a clock cycle using the `clock_ticks` function.
3. Read the value or values from the register or registers.
4. Compare the read value or values with the expected value or values using the `ASSERT_EQ` function.

## Conclusion
This testbench provides comprehensive coverage of the register file's functionality as per the specification. It verifies that the register file correctly implements asynchronous read, synchronous write, and the hardwiring of register 0.