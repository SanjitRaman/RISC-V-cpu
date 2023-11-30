#include <alu.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class ALUTest: public ::testing::Test {
protected:
  alu * top;
  const uint32_t simcyc = 10'000'000;

  void SetUp( ) {
    top = new alu;
    top->eval();
  }

  void TearDown( ) {
    top->final();
    delete top;
  }
};


TEST_F(ALUTest, ADDZ0) {
  top->ALUControl = 0b0000;
  top->SrcA = 0x0000003F;
  top->SrcB = 0x0000014A;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000189);
  ASSERT_EQ(top->Zero, 0b0);
}

TEST_F(ALUTest, ADDZ1) {
  top->ALUControl = 0b0000;
  top->SrcA = 0xFFFFFFFF;
  top->SrcB = 0x39E8F390;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x39E8F38F);
  ASSERT_EQ(top->Zero, 0b1);
}

TEST_F(ALUTest, SUBZ0) {
  top->ALUControl = 0b0001;
  top->SrcA = 0x000037D8;
  top->SrcB = 0x0000025B;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x0000357D);
  ASSERT_EQ(top->Zero, 0b0);
}

TEST_F(ALUTest, SUBZ1) {
  top->ALUControl = 0b0001;
  top->SrcA = 0x29AB0E38;
  top->SrcB = 0xFFFFF021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x29AB1E17);
  ASSERT_EQ(top->Zero, 0b1);
}

TEST_F(ALUTest, SLL) {
  top->ALUControl = 0b0011;
  top->SrcA = 0x000037D8;
  top->SrcB = 3;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
}

TEST_F(ALUTest, SLTGPP) {
  top->ALUControl = 0b0011;
  top->SrcA = 0x000037D8;
  top->SrcB = 0x0000025B;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
}

TEST_F(ALUTest, SLTGPN) {
  top->ALUControl = 0b0011;
  top->SrcA = 0x29AB0E38;
  top->SrcB = 0xE010F021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
}

TEST_F(ALUTest, SLTGNN) {
  top->ALUControl = 0b0011;
  top->SrcA = 0xA0AB0E38;
  top->SrcB = 0xF01FF021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, SLTLPP) {
  top->ALUControl = 0b0011;
  top->SrcA = 0x0000025B;
  top->SrcB = 0x00007901;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, SLTLNP) {
  top->ALUControl = 0b0011;
  top->SrcA = 0xF01FF021;
  top->SrcB = 0x00AB0E38;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, SLTLNN) {
  top->ALUControl = 0b0011;
  top->SrcA = 0xF01FF021;
  top->SrcB = 0xA0AB0E38;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, SLTU0) {
  top->ALUControl = 0b0100;
  top->SrcA = 0x735a1099;
  top->SrcB = 0x30d2f191;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
}

TEST_F(ALUTest, SLTU1) {
  top->ALUControl = 0b0100;
  top->SrcA = 0x30d2f191;
  top->SrcB = 0x735a1099;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, XOR) {
  top->ALUControl = 0b0101;
  top->SrcA = 0x6047D6D3;
  top->SrcB = 0xD471D368;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xB43605BB);
}

TEST_F(ALUTest, SRL) {
  top->ALUControl = 0b0110;
  top->SrcA = 0xA020025B;
  top->SrcB = 8;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00A02002);
}

TEST_F(ALUTest, SRA0) {
  top->ALUControl = 0b0111;
  top->SrcA = 0x030D37D8;
  top->SrcB = 5;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x001869BE);
}

TEST_F(ALUTest, SRA1) {
  top->ALUControl = 0b0111;
  top->SrcA = 0x830D37D8;
  top->SrcB = 5;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xFC1869BE);
}

TEST_F(ALUTest, OR) {
  top->ALUControl = 0b1000;
  top->SrcA = 0x030D37D8;
  top->SrcB = 0xA020025B;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xA32D37DB);
}

TEST_F(ALUTest, AND) {
  top->ALUControl = 0b1001;
  top->SrcA = 0x29AB0E38;
  top->SrcB = 0xE010F021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x20000020);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage_control_unit.dat");
  return res;
}
