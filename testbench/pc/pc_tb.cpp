#include <pc.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class PCTest: public ::testing::Test {
protected:
  pc * top;
  const uint32_t simcyc = 10'000'000;

  void SetUp( ) {
    top = new pc;
    top->eval();
  }

  void TearDown( ) {
    top->final();
    delete top;
  }
};


TEST_F(PCTest, incrTest) {
  top->CLK = 4;
  top->RST = 0;
  top->PCNext = 8;
  top->eval();
  ASSERT_EQ(top->PC, 8);
}

TEST_F(PCTest, resTest) {
  top->CLK = 4;
  top->RST = 1;
  top->PCNext = 8;
  top->eval();
  ASSERT_EQ(top->PC, 0);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_control_unit.dat");
  return res;
}
