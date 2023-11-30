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
sign_extend * sgn_ext;

  void SetUp( ) {
    sgn_ext = new sign_extend;
    sgn_ext->eval();
  }

  void TearDown( ) {
    sgn_ext->final();
    delete sgn_ext;
  }
};

// extract k bits of number from position p.
uint32_t bitExtracted(uint32_t number, int k, int p) {
  return (((1 << k) - 1) & (number >> p));
}
// create a model based on specification of sign_extend
uint32_t expected_value(uint32_t Instr, uint32_t ImmSrc) {
  uint32_t immediate, imm1, imm2, imm3, imm4;

  switch(ImmSrc) {
    case 0: {
      immediate = bitExtracted(Instr, 12, 20); // 12 bits from bit 20;
      break;
    }
    case 1: {
      imm1 = bitExtracted(Instr, 7, 25);
      imm2 = bitExtracted(Instr, 5, 7);
      immediate = (imm1 << 5) | imm2;
      break;
    }
    case 2: {
      imm1 = bitExtracted(Instr, 1, 31);
      imm2 = bitExtracted(Instr, 1, 7);
      imm3 = bitExtracted(Instr, 6, 25);
      imm4 = bitExtracted(Instr, 4, 8);
      immediate = (imm1<<12) | (imm2<<11) | (imm3<<5) | (imm4<<1); 
    }
    case 3: {
      immediate = bitExtracted(Instr, 20, 12);
    }
    default: {
      immediate = bitExtracted(Instr, 12, 20);
      break;
    }

  }

  return ((immediate & 0xFFF) | -(immediate & 0x800)); // sign extension

}

uint32_t gen_random_instr() {
  return ::dist(::rng);
}

// test sign extension for ImmSrc = 2'b00
TEST_F(SignExtendTest, immSrc00) {
  ASSERT_EQ(sgn_ext->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t Instr = gen_random_instr();
  uint32_t ImmSrc = 0b00;
  sgn_ext->Instr = Instr;
  sgn_ext->ImmSrc = ImmSrc;
  sgn_ext->eval();
  ASSERT_EQ(sgn_ext->immOp, expected_value(Instr, ImmSrc));
}
// test sign extension for ImmSrc = 2'b01
TEST_F(SignExtendTest, immSrc01) {
  ASSERT_EQ(sgn_ext->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t Instr = gen_random_instr();
  uint32_t ImmSrc = 0b01;
  sgn_ext->Instr = Instr;
  sgn_ext->ImmSrc = ImmSrc;
  sgn_ext->eval();
  ASSERT_EQ(sgn_ext->immOp, expected_value(Instr, ImmSrc));
}
// test sign extension for ImmSrc = 2'b10
TEST_F(SignExtendTest, immSrc01) {
  ASSERT_EQ(sgn_ext->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t Instr = gen_random_instr();
  uint32_t ImmSrc = 0b10;
  sgn_ext->Instr = Instr;
  sgn_ext->ImmSrc = ImmSrc;
  sgn_ext->eval();
  ASSERT_EQ(sgn_ext->immOp, expected_value(Instr, ImmSrc));
}
// test sign extension for ImmSrc = 2'b11
TEST_F(SignExtendTest, immSrc01) {
  ASSERT_EQ(sgn_ext->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t Instr = gen_random_instr();
  uint32_t ImmSrc = 0b11;
  sgn_ext->Instr = Instr;
  sgn_ext->ImmSrc = ImmSrc;
  sgn_ext->eval();
  ASSERT_EQ(sgn_ext->immOp, expected_value(Instr, ImmSrc));
}
// test default case
TEST_F(SignExtendTest, immSrc10) {
  ASSERT_EQ(sgn_ext->immOp, 0);
  const uint32_t Clocks10M = 10'000'000;
  uint32_t Instr = gen_random_instr();
  uint32_t ImmSrc = 0b10;
  sgn_ext->Instr = Instr;
  sgn_ext->ImmSrc = ImmSrc;
  sgn_ext->eval();
  ASSERT_EQ(sgn_ext->immOp, expected_value(Instr, ImmSrc));
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
