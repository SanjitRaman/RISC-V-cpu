#include <control_unit.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class ControlUnitTest: public ::testing::Test {
protected:
  control_unit * top;
  const uint32_t simcyc = 10'000'000;

  /*
  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      top->clk = 1;
      top->eval();
      top->clk = 0;
      top->eval();
    }
  }

  */

  void SetUp( ) {
    top = new control_unit;
    //top->clk = 1;
    //top->rst = 0;
    top->eval();
  }

  void TearDown( ) {
    top->final();
    delete top;
  }
};

//
TEST_F(ControlUnitTest, ADDI) {
  //clock_ticks(simcyc);
  //top->Instr = 0x00158513; //addi a1 a1 1
  top->op = 0b0010011;
  top->funct3 = 0b000;
  top->funct7_5 = 0b0;
  top->Zero = 0b0;
  top->eval();
  ASSERT_EQ(top->PCSrc, 0);
  ASSERT_EQ(top->ALUControl, 0b000);
  ASSERT_EQ(top->ALUSrc, 1);
  ASSERT_EQ(top->ImmSrc, 0b00);
  ASSERT_EQ(top->RegWrite, 1);
  ASSERT_EQ(top->ResultSrc, 0);
  ASSERT_EQ(top->MemWrite, 0);
}

TEST_F(ControlUnitTest, BNE0) {
  //clock_ticks(simcyc);
  top->op = 0b1100011;
  top->funct3 = 0b001;
  top->funct7_5 = 0b0;
  top->Zero = 0b0;
  top->eval();
  ASSERT_EQ(top->RegWrite, 0);
  ASSERT_EQ(top->ImmSrc, 0b10);
  ASSERT_EQ(top->ALUSrc, 0);
  ASSERT_EQ(top->MemWrite, 0);
  ASSERT_EQ(top->ResultSrc, 0);
  ASSERT_EQ(top->PCSrc, 1);
  ASSERT_EQ(top->ALUControl, 0b001);
}

TEST_F(ControlUnitTest, BNE1) {
  //clock_ticks(simcyc);
  top->op = 0b1100011;
  top->funct3 = 0b001;
  top->funct7_5 = 0b0;
  top->Zero = 0b1;
  top->eval();
  ASSERT_EQ(top->RegWrite, 0);
  ASSERT_EQ(top->ImmSrc, 0b10);
  ASSERT_EQ(top->ALUSrc, 0);
  ASSERT_EQ(top->MemWrite, 0);
  ASSERT_EQ(top->ResultSrc, 0);
  ASSERT_EQ(top->PCSrc, 0);
  ASSERT_EQ(top->ALUControl, 0b001);
}

TEST_F(ControlUnitTest, LW) {
  //clock_ticks(simcyc);
  top->op = 0b0000011;
  top->funct3 = 0b010;
  top->funct7_5 = 0b0;
  top->Zero = 0b0;
  top->eval();
  ASSERT_EQ(top->PCSrc, 0);
  ASSERT_EQ(top->ALUControl, 0b000);
  ASSERT_EQ(top->ALUSrc, 1);
  ASSERT_EQ(top->ImmSrc, 0b00);
  ASSERT_EQ(top->RegWrite, 1);
  ASSERT_EQ(top->ResultSrc, 1);
  ASSERT_EQ(top->MemWrite, 0);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_control_unit.dat");
  return res;
}
