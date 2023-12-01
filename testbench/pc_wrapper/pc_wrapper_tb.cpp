#include <pc_wrapper.h>
#include <verilated.h>
#include <gtest/gtest.h>

class PCWrapperTest: public::testing::Test
{
protected:
    pc_wrapper *top;

    void clock_ticks(int N)
    {
        for (int i = 1; i <= N; i++)
        {
            top->clk = 1;
            top->eval();
            top->clk = 0;
            top->eval();
        }
    }
    void SetUp()
    {
        top = new pc_wrapper;
        top->eval();
    }
    void TearDown()
    {
        top->final();
        delete top;
    }

    void setInputsAndEvaluate(uint32_t imm_ext, int PCsrc, int rst = 0)
    {
        top->ImmExt = imm_ext;
        top->PCsrc = PCsrc;
        top->rst = rst;
        clock_ticks(1);
    }

    void assertPCOut(uint32_t PCOut)
    {
        ASSERT_EQ(top->PCOut, PCOut);
    }
};

TEST_F(PCWrapperTest, NEXT_INSTRUCTION)
{
    setInputsAndEvaluate(0xFFABCDEF, 0);
    assertPCOut(0x00000004);
}

TEST_F(PCWrapperTest, BRANCH_INSTRUCTION)
{
    setInputsAndEvaluate(0xFFABCDEF, 1);
    assertPCOut(0xFFABCDEF);
}

TEST_F(PCWrapperTest, RESET_PC_NEXT)
{
    setInputsAndEvaluate(0xFFABCDEF, 0, 1);
    assertPCOut(0x00000000);
}

TEST_F(PCWrapperTest, RESET_PC_BRANCH)
{
    setInputsAndEvaluate(0xFFABCDEF, 1, 0);
    assertPCOut(0x00000000);
}

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage_pc_wrapper.dat");
    return res;
}