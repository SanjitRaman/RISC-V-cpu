#include <control_unit.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <tuple>

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
            // TODO: Implement the logic to process the instruction



            // Placeholder return values
            uint32_t op = Instr & 0b1111111;
            uint32_t funct3 = 0;
            uint32_t funct7 = 0;

            if(op == 0b011011) { // R-type
                funct7 = (Instr >> 25) & 0b1111111;
                funct3 = (Instr >> 12) & 0b111;
            }
            else if(op == 0b11 || op == 0b10011) { // I-type
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
            top->funct7_5 = std::get<2>(Instr);
        }
        void setFlags(uint32_t Zero, uint32_t C=0, uint32_t V=0, uint32_t N=0) {
            top->Zero = Zero;
        }

        void setInputsAndEvaluate(uint32_t Instr, uint32_t Zero) {
            setInputs(processInstruction(Instr));
            setFlags(Zero);
            top->eval();
        }

        void assertControlSignals(int RegWrite=-1, int ImmSrc=-1, int ALUSrc=-1, int MemWrite=-1, int ResultSrc=-1, int PCSrc=-1, int ALUControl=-1) {
            if (RegWrite   != -1)    ASSERT_EQ(top->RegWrite,   RegWrite  );
            if (ImmSrc     != -1)    ASSERT_EQ(top->ImmSrc,     ImmSrc    );
            if (MemWrite   != -1)    ASSERT_EQ(top->MemWrite,   MemWrite  );
            if (ResultSrc  != -1)    ASSERT_EQ(top->ResultSrc,  ResultSrc );
            if (PCSrc      != -1)    ASSERT_EQ(top->PCSrc,      PCSrc     );
            if (ALUControl != -1)    ASSERT_EQ(top->ALUControl, ALUControl);
        }
};


// R-type
// add
// sub
// sll
// slt
// sltu
// xor
// srl
// sra
// or
// and

// I-type
// lb
// lh
// lw
TEST_F(ControlUnitTest, LW) {
    setInputsAndEvaluate(0x0005A503, 0b0);
    assertControlSignals(1, 0b00, 1, 0, 1, 0, 0b000);
}
// lbu
// lhu
// addi
TEST_F(ControlUnitTest, ADDI) {
    setInputsAndEvaluate(0x00530213, 0b0);
    assertControlSignals(1,-1, 0, 0, 0, 0, 0b000);
}
// slli
// slti
// sltiu
// xori
// srli
// srai
// ori
// andi

// S-type
// sb
// sh
// sw

// beq
// bne
TEST_F(ControlUnitTest, BNE0) {
    setInputsAndEvaluate(0x00063663, 0b0);
    assertControlSignals(0, 0b10, 0, 0, -1, 1, 0b001);
}

TEST_F(ControlUnitTest, BNE1) {
    setInputsAndEvaluate(0x00063663, 0b1);
    assertControlSignals(0, 0b10, 0, 0, -1, 0, 0b001);
}
// blt
// bge
// bltu
// bgeu

// U-type
// auipc
// lui

// J-type
// jalr
// jal


int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage_control_unit.dat");
    return res;
}
