#include <string>
#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "risc_v.h"
#include "vbuddy.cpp"

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#if VBD == 1
#define VBUDDY true
#else
#define VBUDDY false
#endif

#ifndef PROGRAM_NAME
#define PROGRAM_NAME counter
#endif


#define MAX_SIM_CYC 1'000'000
#define DATASET "Gaussian"

int main(int argc, char **argv, char **env) {
    std::string program_name = std::string(TOSTRING(PROGRAM_NAME));
    int simcyc;     // simulation clock count
    int tick;       // each CLK cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    std::string command = std::string("make -C ../ assemble PROGRAM_NAME=");
    command.append(program_name);
    command.append(std::string(" VBUDDY="));
    command.append(std::string(VBUDDY ? "1" : "0"));
    const char* commandArray = command.c_str(); // Convert command string to char array
    int system_return = system(commandArray); //Bash command
    // init top verilog instance
    risc_v * top = new risc_v;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("risc_v.vcd");
    top->address_to_view = 10;

    if(VBUDDY) {
        if(vbdOpen() != 1) return -1;
        std::string header;
        if(program_name == "pdf") {
            header = program_name + std::string(": ") + std::string(DATASET);
        }
        else {
            header = program_name;
        }
        const char* headerArray = header.c_str();
        vbdHeader(headerArray);
    }


    // initialize simulation inputs
    top->CLK = 1;
    top->RST = 1;

    bool started = false;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
        if(simcyc > 0) top->RST = 0;
        // dump variables into VCD file and toggle clock
        for (tick=0; tick<2; tick++) {
            tfp->dump (2*simcyc+tick);
            top->CLK = !top->CLK;
            top->eval();
        }
        if (Verilated::gotFinish() || vbdGetkey()=='q') break;
        
        if(VBUDDY) {
            if(program_name == "f1_starting_light") {
                vbdBar(int(top->reg_output));
                vbdCycle(simcyc);
            }
            else if (program_name == "pdf") {
                if(!started && top->pc_viewer == 0xBFC00058)    {
                    started = true;
                }
                else if (started) {
                    if(simcyc % 4 == 0) {
                        vbdPlot(top->reg_output, 0, 255);
                        vbdCycle(simcyc);
                    }
                }
            }
            else if (program_name == "sinegen") {
                if(simcyc % 4 == 0) {
                    vbdPlot(top->reg_output, 0, 255);
                    vbdCycle(simcyc);
                }
            }
            else {
                vbdPlot(top->reg_output, 0, 255);
                vbdCycle(simcyc);
            }
            
        }
    
    }

    if(VBUDDY) vbdClose();
    tfp->close(); 
    exit(0);
}
