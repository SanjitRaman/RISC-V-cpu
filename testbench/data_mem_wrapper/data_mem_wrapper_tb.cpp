#include <data_mem_wrapper.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <iostream>
#include <bitset>

class DataMemWrapperTest: public ::testing::Test {
protected:
    data_mem_wrapper * top;
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
    top = new data_mem_wrapper;
    //top->CLK = 1;
    //top->rst = 0;
    top->eval();
    }

    void TearDown( ) {
    top->final();
    delete top;
    }
    // sign extend i to 32 bits from pos (pos is the position of the sign bit)
    int sign_extend(int i, int pos) {
        if (i & (1 << pos)) {
            return (i & ((1 << pos) - 1)) | (~0 << pos);
        } else {
            return (i & ((1 << pos) - 1));
        }
    }
};


// Funct3 and Memwrite characterise the instruction for data_mem
// lb, lw , , lh, lbu, lhu, sw, sh, sb


// lb -- funct3 = 0b000, memwrite = 0
TEST_F(DataMemWrapperTest, LB) { //Test more
    for(int i = 65536; i < 65792; i++) {
        top->ALUResult = i; // set read address
        top->funct3 = 0b000;
        top->MemWrite = 0;
        top->eval(); // evaluate
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, sign_extend(i - 65536, 7));
    }
    // test that reads outside of the range return 0
    for(int i = 65792; i < 70000; i++) { 
        top->ALUResult = i; // set read address
        top->funct3 = 0b000;
        top->MemWrite = 0;
        top->eval(); // evaluate
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, 0);
    }
}

// lh -- funct3 = 0b001, memwrite = 0
TEST_F(DataMemWrapperTest, LH) {
    int a;
    for(int i = 65536; i < 65792; i++) {
        top->ALUResult = i; // set read address
        top->funct3 = 0b001;
        top->MemWrite = 0;
        top->eval(); // evaluate
        a = i - 65536;
        // check read data
        //std::cout << "i: " << i << std::endl;
        // std::cout << "tb_model: " << std::bitset<32>(sign_extend((i << 8) | ((i + 1) % 256))) << std::endl;
        ASSERT_EQ(top->RDOut, ((sign_extend(a, 7) << 8) | a+1)); // i = 00, 00 << 8 becomes 0000, i+1 = 01. 0000 | 01 = 0001
    }
    // test that reads outside of the range return 0
    for(int i = 65792; i < 70000; i++) { 
        top->ALUResult = i; // set read address
        top->funct3 = 0b001;
        top->MemWrite = 0;
        top->eval(); // evaluate
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, 0);
    }
}

// lw -- funct3 = 0b010, memwrite = 0
TEST_F(DataMemWrapperTest, LW) {
    int a;
    for(int i = 65536; i < 65788; i++) { // stopped test at 254 because of overflow
        top->ALUResult = i; // set read address
        top->funct3 = 0b010;
        top->MemWrite = 0;
        top->eval(); // evaluate
        a = i - 65536;
        // check read data
        ASSERT_EQ(top->RDOut, ((a) << 24) | ((a+1) << 16) | ((a+2) << 8) | (a+3));
    }
    // test that reads outside of the range return 0
    // for(int i = 131067; i < 200000; i++) { 
    //     top->ALUResult = i; // set read address
    //     top->funct3 = 0b010;
    //     top->MemWrite = 0;
    //     top->eval(); // evaluate
    //     // check read data
    //     ASSERT_EQ(top->RDOut, 0);
    // }
}

// lbu -- funct3 = 0b100, memwrite = 0
TEST_F(DataMemWrapperTest, LBU) {
    int a;
    for(int i = 65536; i < 65792; i++) {
        top->ALUResult = i; // set read address
        top->funct3 = 0b100;
        top->MemWrite = 0;
        top->eval(); // evaluate
        a = i - 65536;
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, a);
    }
    // test that reads outside of the range return 0
    for(int i = 65792; i < 70000; i++) { 
        top->ALUResult = i; // set read address
        top->funct3 = 0b100;
        top->MemWrite = 0;
        top->eval(); // evaluate
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, 0);
    }
}

// lhu -- funct3 = 0b101, memwrite = 0
TEST_F(DataMemWrapperTest, LHU) {
    int a = 0;
    for(uint32_t i = 65536; i < 65792; i++) {
        top->ALUResult = i; // set read address
        top->funct3 = 0b101;
        top->MemWrite = 0;
        top->eval(); // evaluate
        a = i - 65536;
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, ((a << 8) | ((a + 1) % 256)));
    }
    // test that reads outside of the range return 0
    for(uint32_t i = 65792; i < 70000; i++) { 
        top->ALUResult = i; // set read address
        top->funct3 = 0b101;
        top->MemWrite = 0;
        top->eval(); // evaluate
        // check read data
        //std::cout << "i: " << i << std::endl;
        ASSERT_EQ(top->RDOut, 0);
    }
}

// 256 = 0b1'0000'0000

// sb -- funct3 = 0b000, memwrite = 1
TEST_F(DataMemWrapperTest, SB) {
    for(int i = 0; i < 256; i++) {
        // set write address, enable
        top->ALUResult = i; // set write address
        top->funct3 = 0b000;
        top->MemWrite = 1;
        top->WriteData = 0;
        // write data
        // do a clock
        top->eval();
        clock_ticks(1);
        // check that the data is written
        top->ALUResult = i; // set read address
        top->funct3 = 0b000;
        top->MemWrite = 0;
        top->eval(); // evaluate
        ASSERT_EQ(top->RDOut & 0xFF, 0);
    }
}
// sh -- funct3 = 0b001, memwrite = 1
TEST_F(DataMemWrapperTest, SH) {
    for(int i = 0; i < 256; i++) {
        // set write address, enable
        top->ALUResult = i; // set write address
        top->funct3 = 0b001;
        top->MemWrite = 1;
        top->WriteData = 0;
        // write data
        // do a clock
        top->eval();
        clock_ticks(1);
        // check that the data is written
        top->ALUResult = i; // set read address
        top->funct3 = 0b001;
        top->MemWrite = 0;
        top->eval(); // evaluate
        ASSERT_EQ(top->RDOut & 0xFFFF, 0);
    }
}

// sw -- funct3 = 0b010, memwrite = 1
TEST_F(DataMemWrapperTest, SW) {
    for(int i = 0; i < 256; i++) {
        // set write address, enable
        top->ALUResult = i; // set write address
        top->funct3 = 0b010;
        top->MemWrite = 1;
        top->WriteData = 0;
        // write data
        // do a clock
        top->eval();
        clock_ticks(1);
        // check that the data is written
        top->ALUResult = i; // set read address
        top->funct3 = 0b010;
        top->MemWrite = 0;
        top->eval(); // evaluate
        ASSERT_EQ(top->RDOut, 0);
    }
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_data_mem_wrapper.dat");
  return res;
}