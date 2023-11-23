#include <control_unit.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class ControlUnitTest: public ::testing::Test {
protected:
  control_unit * top;
  const uint32_t simcyc = 10'000'000;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      top->clk = 1;
      top->eval();
      top->clk = 0;
      top->eval();
    }
  }

  void SetUp( ) {
    top = new control_unit;
    top->clk = 1;
    top->rst = 0;
    top->instr = 0x00158593;
    top->eval();
  }

  void TearDown( ) {
    top->final();
    delete top;
  }
};

//
TEST_F(ControlUnitTest, value) {
  clock_ticks(simcyc);
  ASSERT_EQ(top->PCsrc, 0);
  ASSERT_EQ(top->ALUctrl, 0b000);
  ASSERT_EQ(top->ALUsrc, 0);
  ASSERT_EQ(top->ImmSrc, 0b00);
  ASSERT_EQ(top->RegWrite, 1);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage3.dat");
  return res;
}
