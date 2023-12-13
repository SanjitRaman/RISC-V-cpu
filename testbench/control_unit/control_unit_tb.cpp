#include <control_unit.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <tuple>
#include <iostream>

class ControlUnitTest: public ::testing::Test {
    protected:
        control_unit * top;
        const uint32_t simcyc = 10'000'000;

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

        std::tuple<uint32_t, uint32_t, uint32_t> processInstruction(uint32_t Instr) {
            // return values
            uint32_t op = Instr & 0b1111111;
            uint32_t funct3 = 0;
            uint32_t funct7 = 0;

            if(op == 0b0110011) { // R-type
                funct7 = (Instr >> 25) & 0b1111111;
                funct3 = (Instr >> 12) & 0b111;
            }
            else if(op == 0b11 || op == 0b10011) { // I-type
                funct7 = (Instr >> 25) & 0b1111111;
                funct3 = (Instr >> 12) & 0b111;
            }
            else if (op == 0b0100011) { // S-type
                funct3 = (Instr >> 12) & 0b111;
            }
            else if (op == 0b1100011) { // B-type
                funct3 = (Instr >> 12) & 0b111;
            }
            return std::make_tuple(op, funct3, funct7);
        }



        void setInputs(std::tuple<uint32_t, uint32_t, uint32_t> Instr) {
            top->op = std::get<0>(Instr);
            top->funct3 = std::get<1>(Instr);
            top->funct7_5 = (std::get<2>(Instr) >> 5) & 0b1;
        }
        void setFlags(uint32_t Zero, uint32_t C=0, uint32_t V=0, uint32_t N=0) {
            top->Zero = Zero;
            top->C = C;
            top->V = V;
            top->N = N;
        }

        void setInputsAndEvaluate(uint32_t Instr, uint32_t Zero, uint32_t C=0, uint32_t V=0, uint32_t N=0) {
            setInputs(processInstruction(Instr));
            setFlags(Zero, C, V, N);
            top->eval();
        }

        void assertControlSignals(int RegWrite=-1, int ImmSrc=-1, int ALUSrc=-1, int MemWrite=-1, int ResultSrc=-1, int PCSrc=-1, int ALUControl=-1, int Jump=-1) {
            if (RegWrite   != -1)    ASSERT_EQ(top->RegWrite,   RegWrite  );
            if (ImmSrc     != -1)    ASSERT_EQ(top->ImmSrc,     ImmSrc    );
            if (MemWrite   != -1)    ASSERT_EQ(top->MemWrite,   MemWrite  );
            if (ResultSrc  != -1)    ASSERT_EQ(top->ResultSrc,  ResultSrc );
            if (PCSrc      != -1)    ASSERT_EQ(top->PCSrc,      PCSrc     );
            if (ALUControl != -1)    ASSERT_EQ(top->ALUControl, ALUControl);
            if (Jump       != -1)    ASSERT_EQ(top->Jump,       Jump      );
        }
};


// R-type
// add
TEST_F(ControlUnitTest, ADD) {
    setInputsAndEvaluate(0x006284b3, 0b0); // add x9, x5, x6
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0000, 0);
}
// sub
TEST_F(ControlUnitTest, SUB) {
    setInputsAndEvaluate(0x40218233, 0b0); // sub x4, x3, x2
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0001, 0);
}
// sll
TEST_F(ControlUnitTest, SLL) {
    setInputsAndEvaluate(0x00a29033, 0b0); // sll x0, x5, x10
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0010, 0);
}
// slt
TEST_F(ControlUnitTest, SLT) {
    setInputsAndEvaluate(0x003120b3, 0b0); // slt x1, x2, x3
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0011, 0);
}
// sltu
TEST_F(ControlUnitTest, SLTU) {
    setInputsAndEvaluate(0x011837b3, 0b0); // sltu x15, x16, x17
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0100, 0);
}
// xor
TEST_F(ControlUnitTest, XOR) {
    setInputsAndEvaluate(0x0149c933, 0b0); // xor x18, x19, x20
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0101, 0);
}
// srl
TEST_F(ControlUnitTest, SRL) {
    setInputsAndEvaluate(0x01bbda33, 0b0); // srl x20, x23, x27
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0110, 0);
}
// sra
TEST_F(ControlUnitTest, SRA) {
    setInputsAndEvaluate(0x416e5ab3, 0b0); // sra x21, x28, x22
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b0111, 0);
}
// or
TEST_F(ControlUnitTest, OR) {
    setInputsAndEvaluate(0x01acec33, 0b0); // or x24, x25, x26
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b1000, 0);
}
// and
TEST_F(ControlUnitTest, AND) {
    setInputsAndEvaluate(0x01cdfd33, 0b0); // and x26, x27, x28
    assertControlSignals(1, -1, 0, 0, 0, 0, 0b1001, 0);
}


// I-type -- ImmOp = 0b00
// lb
TEST_F(ControlUnitTest, LB) {
    setInputsAndEvaluate(0x00058503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b0000, 0);
}
// lh
TEST_F(ControlUnitTest, LH) {
    setInputsAndEvaluate(0x03259503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b0000, 0);
}
// lw
TEST_F(ControlUnitTest, LW) {
    setInputsAndEvaluate(0x0005A503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b0000, 0);
}
// lbu
TEST_F(ControlUnitTest, LBU) {
    setInputsAndEvaluate(0x0465c503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b0000, 0);
}
// lhu
TEST_F(ControlUnitTest, LHU) {
    setInputsAndEvaluate(0x0175d503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b0000, 0);
}

// addi
TEST_F(ControlUnitTest, ADDI) {
    setInputsAndEvaluate(0x00530213, 0b0);
    assertControlSignals(1,0b00, 1, 0, 0, 0, 0b0000, 0);
}
// slli
TEST_F(ControlUnitTest, SLLI) {
    setInputsAndEvaluate(0x01009013, 0b0); // slli x0, x1, 0x10
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0010, 0);
}
// slti
TEST_F(ControlUnitTest, SLTI) {
    setInputsAndEvaluate(0x00312013, 0b0); // slti x0, x1, 0xFFF
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0011, 0);
}
// sltiu
TEST_F(ControlUnitTest, SLTIU) {
    setInputsAndEvaluate(0x0001b113, 0b0); // sltiu x2, x3, 0x000
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0100, 0);
}
// xori
TEST_F(ControlUnitTest, XORI) {
    setInputsAndEvaluate(0x1232c213, 0b0); // xori x4, x5, 0x123
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0101, 0);
}
// srli
TEST_F(ControlUnitTest, SRLI) {
    setInputsAndEvaluate(0x01f3d313, 0b0); // srli x6, x7, 0x1f
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0110, 0);
}
// srai
TEST_F(ControlUnitTest, SRAI) {
    setInputsAndEvaluate(0x4074d413, 0b0); // srai x8, x9, 0x07
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b0111, 0);
}
// ori
TEST_F(ControlUnitTest, ORI) {
    setInputsAndEvaluate(0x1235e513, 0b0); // ori x10, x11, 0x123
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b1000, 0);
}
// andi
TEST_F(ControlUnitTest, ANDI) {
    setInputsAndEvaluate(0x00f6f613, 0b0); // andi x12, x13, 0xf
    assertControlSignals(1, 0, 1, 0, 0, 0, 0b1001, 0);
}

// S-type
// sb
TEST_F(ControlUnitTest, SB) {
    setInputsAndEvaluate(0x00b80023, 0b0);
    assertControlSignals(0, 0b001, 1, 1, -1, 0, 0b0000, 0);
}
// sh
TEST_F(ControlUnitTest, SH) {
    setInputsAndEvaluate(0x02c81123, 0b0);
    assertControlSignals(0, 0b001, 1, 1, -1, 0, 0b0000, 0);
}
// sw
TEST_F(ControlUnitTest, SW) {
    setInputsAndEvaluate(0x00d5a2a3, 0b0);
    assertControlSignals(0, 0b001, 1, 1, -1, 0, 0b0000, 0);
}

// beq
TEST_F(ControlUnitTest, BEQ0) {
    setInputsAndEvaluate(0x00108463, 0b0); // beq r1 r1 8
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
TEST_F(ControlUnitTest, BEQ1) {
    setInputsAndEvaluate(0x00108463, 0b1); // beq r1 r1 8
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}
// bne
TEST_F(ControlUnitTest, BNEZeroFlag0) {
    setInputsAndEvaluate(0x00109463, 0b0); // bne r1 r1 8
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}
TEST_F(ControlUnitTest, BNEZeroFlag1) {
    setInputsAndEvaluate(0x00109463, 0b1); // bne r1 r1 8
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
// blt
TEST_F(ControlUnitTest, BLTNoBranch) { // Z = 0, C = 0, V = 1, N = 1 // NVZ = 110
    setInputsAndEvaluate(0x0010C463, 0b0, 0b0, 0b1, 0b1); 
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
TEST_F(ControlUnitTest, BLTBranch) {
    setInputsAndEvaluate(0x0010C463, 0b0, 0b0, 0b0, 0b1);
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}
// bge
TEST_F(ControlUnitTest, BGENoBranch) {
    setInputsAndEvaluate(0x0010D463, 0b0, 0b0, 0b0, 0b1);
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
TEST_F(ControlUnitTest, BGEBranch) {
    setInputsAndEvaluate(0x0010D463, 0b0, 0b0, 0b1, 0b1);
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}
// bltu
TEST_F(ControlUnitTest, BLTU0) {
    setInputsAndEvaluate(0x0010E463, 0b0, 0b0); 
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
TEST_F(ControlUnitTest, BLTU1) {
    setInputsAndEvaluate(0x0010E463, 0b0, 0b1);
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}
// bgeu
TEST_F(ControlUnitTest, BGEU0) {
    setInputsAndEvaluate(0x0010F463, 0b0, 0b1); 
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001, 0);
}
TEST_F(ControlUnitTest, BGEU1) {
    setInputsAndEvaluate(0x0010F463, 0b0, 0b0);
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001, 0);
}

// U-type
// auipc
// RegWrite=-1, ImmSrc=-1, ALUSrc=-1 MemWrite=-1, ResultSrc=-1, PCSrc=-1, ALUControl=-1, Jump=-1
TEST_F(ControlUnitTest, AUIPC) {
    setInputsAndEvaluate(0x00000517, 0b0); // auipc x10, 0x0
    assertControlSignals(1, 0b11, -1, 0, 0b10, 0, -1);
}
// lui
TEST_F(ControlUnitTest, LUI) {
    setInputsAndEvaluate(0xff0105b7, 0b0); // lui x0, 0x0
    assertControlSignals(1, 0b011, 1, 0, 0b00, 0, 0b1011);
}

// J-type
// jalr
TEST_F(ControlUnitTest, JALR) {
    setInputsAndEvaluate(0x032605e7, 0b0); // jalr a1, a2, 50
    assertControlSignals(1, 0b000, 1, 0, 0b10, 1, -1, 1);
}
// jal
TEST_F(ControlUnitTest, JAL) {
    setInputsAndEvaluate(0x018005ef, 0b0); // jal  a1, 28
    assertControlSignals(1, 0b100, 1, 0, 0b11, 1, -1, 0);
}
// regwrite = 1, PCSrc = 1, immSrc = 0b100, resultSrc = 0



int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage_control_unit.dat");
    return res;
}
