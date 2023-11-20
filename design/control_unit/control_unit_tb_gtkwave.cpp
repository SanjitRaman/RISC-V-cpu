#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcontrol_unit.h"
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges
  
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vcontrol_unit * top = new Vcontrol_unit;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("control_unit.vcd");
 
  // initialize simulation inputs
  top->clk = 1;
  top->rst = 0;
  top->instr = 0x00158593;
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    assert (top->PCsrc == 0);
    assert (top->ALUctrl == 0b000);
    assert (top->ALUsrc == 1);
    assert (top->ImmSrc == 0b00);
    assert (top->RegWrite == 1);
    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
