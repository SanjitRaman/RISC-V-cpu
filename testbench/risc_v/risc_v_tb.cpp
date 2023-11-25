#include "verilated.h"
#include "verilated_vcd_c.h"
#include "risc_v.h"
#define MAX_SIM_CYC 1000

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each CLK cycle has two ticks for two edges
  
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  risc_v * top = new risc_v;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("risc_v.vcd");
 
  // initialize simulation inputs
  top->CLK = 1;
  top->RST = 0;
  
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval ();
    }
    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
