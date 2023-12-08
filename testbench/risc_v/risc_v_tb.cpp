#include <risc_v.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <iostream>

class RiscVTest: public ::testing::Test {
protected:
    risc_v * top;
    const uint32_t simcyc = 10'000'000;

    void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
        top->CLK = 1;
        top->eval();
        top->CLK = 0;
        top->eval();
    }
    }

    void SetUp( ) {
    top = new risc_v;
    //top->CLK = 1;
    //top->rst = 0;
    top->eval();
    }

    void TearDown( ) {
    top->final();
    delete top;
    }
};


// Test the add instruction
TEST_F(RiscVTest, ADD) {
    // read the instruction memory
    // system("make -C ../ assemble PROGRAM=single_instruction_tests/add");
    //system("make -C ../ hexfile PROGRAM=single_instruction_tests/add");
    clock_ticks(1);
    // read the data memory
    // load into registers
    // check the result
}

int main(int argc, char **argv) {
    std::cout << "Verilated Command Args" << std::endl;
    Verilated::commandArgs(argc, argv);
    std::cout << "Init Google Test" << std::endl;
    testing::InitGoogleTest(&argc, argv);
    std::cout << "Run All Tests" << std::endl;
    auto res = RUN_ALL_TESTS();
    system("pwd");
    std::cout << "Making Logs Directory" << std::endl;
    Verilated::mkdir("logs");

    std::cout << "Write Coverage" << std::endl;
    VerilatedCov::write("logs/coverage_risc_v.dat");
    return res;
}
