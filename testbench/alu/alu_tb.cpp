#include <alu.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <iostream>

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


TEST_F(ALUTest, ADDFlags0) {
  top->ALUControl = 0b0000;
  top->SrcA = 0x0000003F;
  top->SrcB = 0x0000014A;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000189);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, ADDFlags1) {
  top->ALUControl = 0b0000;
  top->SrcA = 0xFFFFFFFF;
  top->SrcB = 0xFFFFFFFF;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xFFFFFFFE);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b1);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b1);
}

TEST_F(ALUTest, SUBFlags0) {
  top->ALUControl = 0b0001;
  top->SrcA = 0x000037D8;
  top->SrcB = 0x0000025B;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x0000357D);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SUBFlags1) {
  top->ALUControl = 0b0001;
  top->SrcA = 0xFFFFF021;
  top->SrcB = 0xFFFFF021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
  ASSERT_EQ(top->Zero, 0b1);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b1);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SLL) {
  top->ALUControl = 0b0010;
  top->SrcA = 0x000037D8;
  top->SrcB = 3;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x0001BEC0);
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
  //ASSERT_EQ(top->signs, 0b01);
}

TEST_F(ALUTest, SLTGNN) {
  top->ALUControl = 0b0011;
  top->SrcA = 0xFFFFFFFF;
  top->SrcB = 0xF01FF021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
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
  top->SrcA = 0xA0AB0E38; 
  top->SrcB = 0xF01FF021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
}

TEST_F(ALUTest, SLTU0) {
  top->ALUControl = 0b0100;
  top->SrcA = 0x735a1099;
  top->SrcB = 0x30d2f191;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000000);
  ASSERT_EQ(top->Zero, 0b1);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SLTU1) {
  top->ALUControl = 0b0100;
  top->SrcA = 0x30d2f191;
  top->SrcB = 0x735a1099;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00000001);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, XOR) {
  top->ALUControl = 0b0101;
  top->SrcA = 0x6047D6D3;
  top->SrcB = 0xD471D368;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xB43605BB);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b1);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SRL) {
  top->ALUControl = 0b0110;
  top->SrcA = 0xA020025B;
  top->SrcB = 8;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x00A02002);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SRA0) {
  top->ALUControl = 0b0111;
  top->SrcA = 0x030D37D8;
  top->SrcB = 5;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x001869BE);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, SRA1) {
  top->ALUControl = 0b0111;
  top->SrcA = 0xF0000000;
  top->SrcB = 4;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xFF000000);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b1);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, OR) {
  top->ALUControl = 0b1000;
  top->SrcA = 0x030D37D8;
  top->SrcB = 0xA020025B;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xA32D37DB);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b1);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, AND) {
  top->ALUControl = 0b1001;
  top->SrcA = 0x29AB0E38;
  top->SrcB = 0xE010F021;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0x20000020);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b0);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}

TEST_F(ALUTest, LUI) {
  top->ALUControl = 0b1011;
  top->SrcB = 0xFFFFF000;
  top->eval();
  ASSERT_EQ(top->ALUResult, 0xFFFFF000);
  ASSERT_EQ(top->Zero, 0b0);
  ASSERT_EQ(top->N, 0b1);
  ASSERT_EQ(top->V, 0b0);
  ASSERT_EQ(top->C, 0b0);
}
