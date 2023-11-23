//===----------------------------------------------------------------------===//
///
/// \file
/// \brief unit test for sign_extend.sv
//===----------------------------------------------------------------------===//

#include <sign_extend.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <random>

std::random_device r;
std::mt19937 rng{r()};
std::uniform_int_distribution<> dist(INT32_MIN, INT32_MAX);

class SignExtendTest: public ::testing::TestWithParam<uint32_t> {
protected:
sign_extend * cntr;

  void SetUp( ) {
    cntr = new sign_extend;
    cntr->eval();
  }

  void TearDown( ) {
    cntr->final();
    delete cntr;
  }
};

// extract k bits of number from position p.
uint32_t bitExtracted(uint32_t number, int k, int p) {
  return (((1 << k) - 1) & (number >> p));
}
// create a model based on specification of sign_extend
uint32_t expected_value(uint32_t instr, uint32_t immSrc) {
  uint32_t immediate, imm1, imm2;

  switch(immSrc) {
    case 0: {
      immediate = bitExtracted(instr, 12, 20); // 12 bits from bit 20;
      break;
    }
    case 1: {
      imm1 = bitExtracted(instr, 7, 25);
      imm2 = bitExtracted(instr, 5, 7);
      immediate = (imm1 << 5) | imm2;
      break;

    }
    default: {
      immediate = bitExtracted(instr, 12, 20);
      break;
    }

  }

  return ((immediate & 0xFFF) | -(immediate & 0x800)); // sign extension

}

uint32_t gen_random_instr() {
  return ::dist(::rng);
}

// test sign extension for immSrc = 2'b00
TEST_F(SignExtendTest, immSrc00) {
  ASSERT_EQ(cntr->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t instr = gen_random_instr();
  uint32_t immSrc = 0b00;
  cntr->instr = instr;
  cntr->immSrc = immSrc;
  cntr->eval();
  ASSERT_EQ(cntr->immOp, expected_value(instr, immSrc));
}
// test sign extension for immSrc = 2'b01
TEST_F(SignExtendTest, immSrc01) {
  ASSERT_EQ(cntr->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t instr = gen_random_instr();
  uint32_t immSrc = 0b01;
  cntr->instr = instr;
  cntr->immSrc = immSrc;
  cntr->eval();
  ASSERT_EQ(cntr->immOp, expected_value(instr, immSrc));
}
// test default case
TEST_F(SignExtendTest, immSrc10) {
  ASSERT_EQ(cntr->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t instr = gen_random_instr();
  uint32_t immSrc = 0b10;
  cntr->instr = instr;
  cntr->immSrc = immSrc;
  cntr->eval();
  ASSERT_EQ(cntr->immOp, expected_value(instr, immSrc));
}

int main(int argc, char **argv) {
  rng;
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_sign_extend.dat");
  return res;
}
