#include <risc_v.h>
#include <verilated.h>
#include "verilated_vcd_c.h"
#include <gtest/gtest.h>
#include <string>
#include <vector>

enum class RiscVRegisters : uint32_t {
    zero = 0,
    ra = 1,
    sp = 2,
    gp = 3,
    tp = 4,
    t0 = 5,
    t1 = 6,
    t2 = 7,
    s0 = 8,
    s1 = 9,
    a0 = 10,
    a1 = 11,
    a2 = 12,
    a3 = 13,
    a4 = 14,
    a5 = 15,
    a6 = 16,
    a7 = 17,
    s2 = 18,
    s3 = 19,
    s4 = 20,
    s5 = 21,
    s6 = 22,
    s7 = 23,
    s8 = 24,
    s9 = 25,
    s10 = 26,
    s11 = 27,
    t3 = 28,
    t4 = 29,
    t5 = 30,
    t6 = 31
};

class RiscVTest: public ::testing::Test {
protected:
    risc_v * top;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    const uint32_t simcyc = 10'000'000;
    uint32_t curr_cyc = 0;

    void assert_reg(RiscVRegisters reg, uint32_t value) {
        top->address_to_view = static_cast<uint32_t>(reg);
        top->eval();
        EXPECT_EQ(top->reg_output, value);
    }

    void clock_tick(void)
    {
        // Make sure the tickcount is greater than zero before
        // we do this
        curr_cyc++;

        // Allow any combinatorial logic to settle before we tick
        // the clock.  This becomes necessary in the case where
        // we may have modified or adjusted the inputs prior to
        // coming into here, since we need all combinatorial logic
        // to be settled before we call for a clock tick.
        //
        top->CLK = 0;
        top->eval();

        //
        // Here's the new item:
        //
        //	Dump values to our trace file
        //
        if (tfp)
            tfp->dump(10 * curr_cyc - 2);

        // Repeat for the positive edge of the clock
        top->CLK = 1;
        top->eval();
        if (tfp)
            tfp->dump(10 * curr_cyc);

        // Now the negative edge
        top->CLK = 0;
        top->eval();
        if (tfp)
        {
            // This portion, though, is a touch different.
            // After dumping our values as they exist on the
            // negative clock edge ...
            tfp->dump(10 * curr_cyc + 5);
            //
            // We'll also need to make sure we flush any I/O to
            // the trace file, so that we can use the assert()
            // function between now and the next tick if we want to.
            tfp->flush();
        }
    }

    void n_clock_ticks(int N = 1) {
        for (int i = 1; i <= N; i++) {
            clock_tick();
        }
    }

    // Sends a synchronous reset pulse.
    void reset(void)
    {
        top->RST = 1;
        this->clock_tick();
        top->RST = 0;
    }

    void SetUp( ) {
    top = new risc_v;
    Verilated::traceEverOn(true);
    }

    void TearDown( ) {
        top->final();
        if(tfp) {
            tfp->close();
            tfp = NULL;
        }
        delete top;
    }

    void set_tfp(std::string filename) {
        top->trace (tfp, 99);
        tfp->open (filename.c_str());
    }
};

TEST_F(RiscVTest, LW) {
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/i-type/lw");
    set_tfp("risc_v_lw.vcd");
    reset();

    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a0, 0xFFFFFFFF);

    n_clock_ticks(3);
}


TEST_F(RiscVTest, ADDI) {
    // read the instruction memory
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/i-type/addi");
    set_tfp("risc_v_addi.vcd");
    reset();

    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a1, 5);
    n_clock_ticks(1);
}

TEST_F(RiscVTest, BEQ) {
// read the instruction memory
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/b-type/beq");
    set_tfp("risc_v_beq.vcd");
    reset();

    // check lw worked
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a1, 1);

    // check the second lw
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a2, 2);
    
    //check the beq not taken
    n_clock_ticks(1);
    ASSERT_EQ(top->pc_viewer, 0xBFC0000C);
    
    // check next lw
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a1, 1);
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a2, 1);

    // check the beq taken.
    n_clock_ticks(1); // do the beq
    ASSERT_EQ(top->pc_viewer, 0xBFC0000C);
    n_clock_ticks(1);
}

// Test the add instruction
// We know that addi, lw works.
TEST_F(RiscVTest, ADD) {
// read the instruction memory
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/r-type/add");
    set_tfp("risc_v_add.vcd");
    reset();

    // check lw worked
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a2, 1);

    // check the second lw
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a3, 2);
    
    //check the add worked.
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a1, 3);

    // Test overflow:
    // lw big numbers from data memory.
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a2, 0xFFFFFFFF);

    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a3, 0x00000001);

    // check the add worked.
    n_clock_ticks(1);
    assert_reg(RiscVRegisters::a1, 0x00000000);
    n_clock_ticks(5);
}

TEST_F(RiscVTest, SUB) {
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/r-type/sub");
    set_tfp("risc_v_sub.vcd");
    reset();
    
    // load first two numbers
    // and check the sub worked.
    n_clock_ticks(3);
    assert_reg(RiscVRegisters::a1, 1);
    

    // Test overflow:
    // check the sub worked.
    n_clock_ticks(3);
    assert_reg(RiscVRegisters::a1, -5);
    n_clock_ticks(5);
}

TEST_F(RiscVTest, SLL) {
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/r-type/sll");
    set_tfp("risc_v_sll.vcd");
    reset();
    
    // load first two operands
    // and check the operation worked.
    n_clock_ticks(3);
    assert_reg(RiscVRegisters::a1, 0x118);
    
    n_clock_ticks(3);
    assert_reg(RiscVRegisters::a1, 0x118);
    n_clock_ticks(5);
}


TEST_F(RiscVTest, AND) {
    system("make -C ../ assemble PROGRAM_NAME=single_instruction_tests/r-type/and");
    set_tfp("risc_v_and.vcd");
    reset();


}

int main(int argc, char **argv) {
    std::cout << "Verilated Command Args" << std::endl;
    Verilated::commandArgs(argc, argv);
    std::cout << "Init Google Test" << std::endl;
    testing::InitGoogleTest(&argc, argv);
    std::cout << "Run All Tests" << std::endl;
    auto res = RUN_ALL_TESTS();
    std::cout << "Making Logs Directory" << std::endl;
    Verilated::mkdir("logs");

    std::cout << "Write Coverage" << std::endl;
    //VerilatedCov::write("logs/coverage_risc_v.dat");
    return res;
}