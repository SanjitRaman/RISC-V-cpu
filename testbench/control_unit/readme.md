# Test Methodology for ALU

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

The test cases are written using the `TEST_F` macro from Google Test. Each test case sets the inputs and evaluates the control unit, then asserts the expected control signals. The test cases cover R-type, I-type, S-type, B-type, U-type, and J-type instructions.

## Main Function

The main function initializes the Google Test framework, runs all tests, and writes the coverage data to a file.

## How to Run

To run the testbench, compile it with a C++ compiler that supports the C++11 standard or later, and link it with the Google Test library. Then, run the resulting executable. The test results will be printed to the console, and the coverage data will be written to `logs/coverage_control_unit.dat`.