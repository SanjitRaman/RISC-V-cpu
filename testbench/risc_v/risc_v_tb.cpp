#include <reg_file.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

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

TEST_F(RiscVTest, LW) {
    // read the instruction memory
    // read the data memory
    // load into registers
    // check the result
}


// Test the add instruction
TEST_F(RiscVTest, ADD) {
    // read the instruction memory
    system("make hexfile PROGRAM=single_instruction_tests/add");
    // read the data memory
    // load into registers
    // check the result
}


// test property async read
TEST_F(RegFileTest, ASYNCREAD) {
    // for each register write its index.
    for(int i = 0; i < 32; i++) {
        // set write enable
        top->WE3 = 1;
        // set write address
        top->A3 = i;
        // set write data
        top->WD3 = i;
        clock_ticks(1);   
    }
    
    // for each register read its index.
    for(int i = 0; i < 32; i++) {
        // set read addresses
        top->A1 = i;
        top->A2 = (i+1) % 32;
        top->eval(); // evaluate
        // check read data
        ASSERT_EQ(top->RD1, i);
        ASSERT_EQ(top->RD2, (i+1) % 32);
    }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_reg_file.dat");
  return res;
}
