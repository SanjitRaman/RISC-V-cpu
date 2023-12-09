#include "verilated.h"
#include "verilated_vcd_c.h"
#include "risc_v.h"
#include "vbuddy.cpp"
#define MAX_SIM_CYC 1e6

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each CLK cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  int system_return = system("make -C .. / assemble PROGRAM_NAME=pdf"); //Bash command
  // init top verilog instance
  risc_v * top = new risc_v;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("risc_v.vcd");
  top->address_to_view = 10;

  // if(vbdOpen() != 1) return -1;
  // vbdHeader("Triangle PDF");
 
  // initialize simulation inputs
  top->CLK = 1;
  top->RST = 1;
  
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    if(simcyc > 0) top->RST = 0;
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval();
    }
    // if (Verilated::gotFinish() || vbdGetkey()=='q') break;
    // if (simcyc > 5e5){
    //   vbdPlot(top->reg_output, 0, 255)
    // }
    
    // vbdCycle(simcyc);
  }
  // vbdClose();
  tfp->close(); 
  exit(0);
}
