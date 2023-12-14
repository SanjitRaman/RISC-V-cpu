# Test Methodology Document for Data Memory Wrapper Testbench

## Introduction
This document outlines the testing methodology for the Data Memory Wrapper module. The testbench is written in C++ using the Google Test framework and Verilator for simulation. The tests are designed to verify the functionality of the data memory wrapper module, ensuring it behaves as expected according to the specification.

## Test Setup
Each test case is encapsulated within a Google Test fixture (`DataMemWrapperTest`). The fixture sets up the environment for each test, creating an instance of the data memory wrapper (`top`), and providing utility functions such as `clock_ticks` for simulating clock cycles and `sign_extend` as to predict the outcome of a sign extend operation.

## Schematic:
![data_mem_wrapper schematic](/images/data_mem_wrapper_schematic.png)

## Test Cases

### Load Byte (LB)
This test verifies that the module correctly loads a byte from memory. It iterates over a range of addresses, setting the `ALUResult` to the current address, `funct3` to `0b000` (indicating a byte load), and `MemWrite` to `0` (indicating a read operation). It then checks that the value read (`RDOut`) matches the expected value.

### Load Halfword (LH)
This test verifies that the module correctly loads a halfword (two bytes) from memory. It operates similarly to the `LB` test, but sets `funct3` to `0b001` to indicate a halfword load.

### Load Word (LW)
This test verifies that the module correctly loads a word (four bytes) from memory. It operates similarly to the `LB` and `LH` tests, but sets `funct3` to `0b010` to indicate a word load.

### Load Byte Unsigned (LBU)
This test verifies that the module correctly loads a byte from memory as an unsigned value. It operates similarly to the `LB` test, but sets `funct3` to `0b100` to indicate an unsigned byte load.

### Load Halfword Unsigned (LHU)
This test verifies that the module correctly loads a halfword from memory as an unsigned value. It operates similarly to the `LH` test, but sets `funct3` to `0b101` to indicate an unsigned halfword load.

### Store Byte (SB)
This test verifies that the module correctly stores a byte to memory. It operates similarly to the load tests, but sets `MemWrite` to `1` to indicate a write operation, and checks that the written value can be read back correctly.

### Store Halfword (SH)
This test verifies that the module correctly stores a halfword to memory. It operates similarly to the `SB` test, but sets `funct3` to `0b001` to indicate a halfword store.

### Store Word (SW)
This test verifies that the module correctly stores a word to memory. It operates similarly to the `SB` and `SH` tests, but sets `funct3` to `0b010` to indicate a word store.

## Test Execution
```make runtest RUN=module GTEST=1 MODULE=data_mem_wrapper MODULE.INCLUDE_DIRS="-y rtl/data_mem -y rtl/we_decoder -y rtl/ld_decoder"```

## Test Results

![data_num_wrapper_test_results](/images/data_mem_wrapper_test_results.png)

## Conclusion
This test methodology provides comprehensive coverage of the functionality of the Data Memory Wrapper module. By testing each operation (load and store, byte, halfword, and word, signed and unsigned) at a range of addresses, it ensures that the module behaves correctly under a wide range of conditions.

## Further Work:
It is not possible to test the data memory module with all the possible combinations of read/write addresses/data. 

Hence, it is recommended to test the data memory module with many random inputs in a UVM-style methodology to ensure that the module works as expected.

The testbench already implements a UVM-style methodology that has a scoreboard to check whether the output transaction is correct.

The covergroup would be the different types of operations (load/store, byte/halfword/word, signed/unsigned). 

Each of these tests would be run with random inputs. 

The coverpoints would be the number of times each test passes and fails. The goal would be to have 100% pass rate.

Given the limited time for this project, this was not possible to implement, though would be an easy addition.