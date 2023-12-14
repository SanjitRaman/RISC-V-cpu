# Test Methodology for Control Unit

This testbench is written in C++ and uses the [Google Test framework](/testbench/readme.md) to test a control unit in a RISC-V processor. The control unit is responsible for generating control signals based on the instruction type and opcode.

## Class: ControlUnitTest

This class inherits from the Google Test class `::testing::Test`. It contains methods for setting up and tearing down the test environment, processing instructions, setting inputs, setting flags, evaluating inputs, and asserting control signals.

### Protected Members:

- `control_unit * top`: Pointer to the control unit being tested.
- `const uint32_t simcyc = 10'000'000`: Simulation cycle constant.
- `SetUp()`: Sets up the test environment.
- `TearDown()`: Cleans up the test environment.
- `processInstruction(uint32_t Instr)`: Processes an instruction and returns a tuple of opcode, funct3, and funct7.
- `setInputs(std::tuple<uint32_t, uint32_t, uint32_t> Instr)`: Sets the inputs for the control unit.
- `setFlags(uint32_t Zero, uint32_t C=0, uint32_t V=0, uint32_t N=0)`: Sets the flags for the control unit.
- `setInputsAndEvaluate(uint32_t Instr, uint32_t Zero)`: Sets the inputs, sets the flags, and evaluates the control unit.
- `assertControlSignals(int RegWrite=-1, int ImmSrc=-1, int ALUSrc=-1, int MemWrite=-1, int ResultSrc=-1, int PCSrc=-1, int ALUControl=-1)`: Asserts the control signals of the control unit.

## Test Cases

The test cases are written using the `TEST_F` macro from Google Test. Each test case sets the inputs and evaluates the control unit, then asserts the expected control signals. The test cases cover R-type, I-type, S-type, B-type, U-type, and J-type instructions. Below are their respective datapaths: 

| | |
:--:|:--:
| ![single-cycle-control-path-r-type](https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/a12b2269-0568-4f00-8495-4f015e088ec4) | ![single-cycle-control-path-i-type](https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/9f863812-9a50-4f98-ba87-2f1d307f4554) |
| ![single-cycle-control-path-s-type](https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/a67ffe3f-5e8e-4845-8288-c3618aa77d40) | ![single-cycle-control-path-b-type](https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/92810bb7-d4e9-4e0a-97cf-122005258d1d) |


## How to Run

To run the testbench, in the terminal run the command: ```make runtest GTEST=1 VBUDDY=0 RUN=module MODULE=control_unit MODULE.INCLUDE_DIRS="-y rtl/control_unit/decoders"```

The main function initializes the Google Test framework, runs all tests, and writes the coverage data to a file.

## Results 

From running the command, we can see the outcome of each test case below:  

![](/images/control_unit_test_results_excerpt.png)

And the code coverage report can be viewed externally from exporting the file:

![](/images/control_unit_line_coverage.png)

With this we can be confident that the control unit is working as intended. 
