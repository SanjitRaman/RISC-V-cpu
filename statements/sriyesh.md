# Individual Statement: Sriyesh

## Overview 
- Single cycle 
    - ALU module
    - Control unit module 
    - Control unit testbench
    - PC testbench 
    - Register file module
    - Sign Extend testbench 
    - Regsiter instructions 
    - Upper intstuctions 
    - Jump instructions 
    - Branch instructions testbench 
- Pipelining 
    - Pipelining registers 
    - Updated top level 
    - Integration testing 
- Cache 
    - Cache module 


## Single Cycle 

### ALU 

I wrote the ALU component for the processor, it's specification can be found [here](/rtl/alu/readme.md). This was done through a switch case on the ALUControl signal, output by the control unit. Due to the number of intructions, the width of the ALUControl signal had to be changed from 3 bits to 4. To help convey this to the rest of the group, I made the table below. 

![](/images/ALU_decoder.png) 


### Control unit 

In the control unit I helped write part of the ALU decoder, to produce the aforementioned ALUControl signal and the main decoder to produce the output signals for the instruction types I was working on. I also helped derive the logic for the signed greater than signal from the NCVZ flags in the top level. The specification for the control unit can be found [here](/rtl/control_unit/readme.md). 

As for the testbench, I wrote the tests for the all the branch instructions, considering a case where a branch was to be taken and one where it was not for each instruction. This was done by setting the flags and instruction and asseting the control signals. More information on the testing of the control unit can be found [here](/testbench/control_unit/readme.md). 

### PC

### Register file

I wrote the register file for this processor, the specification for which can be found [here](/rtl/reg_file/readme.md). 

### Sign extend 

While implementing U and J type instructions, I had to update the sign extend module. My initial approach was to simply sign extend `Instr[31:12]` and pass on the extended 32-bit immediate to their respective modules to be decoded as they would never happen simultaneously in single cycle. This change allowed for only 4 cases to consider, and a smaller ImmSrc width. However, to account for pipelining in future, this had to be changed to 3 bits and the cases where split. The full specification for the sign extend module can be found [here](/rtl/sign_extend/readme.md). 

I wrote the testebench for the sign extend module. This was done through asserting the output of the module with an expected value, calculated with a switch case. The full test methodolgy can be found [here](/testbench/sign_extend/readme.md). 

## Pipelining 

### Pipelining register files 

All the pipeline registers were written by me according to the schematic seen in lectures as a first draft just with input and output registers. Then when adapting our design to incorportate the pipeling stages, we added enable and reset signals where necessary as well as passing on func3 to later stages of the pipeline so that it could be used for our write enable decoder module. The specifications for the registers can be found below: 

[Decode Register](/rtl/reg_file_d/)
[Execute Register](/rtl/reg_file_e/)
[Memory Register](/rtl/reg_file_m/)
[Writeback Register](/rtl/reg_file_w/)

### Updated top level 

Along with the new registers, we had to add new multiplexers to incorporate the changes to logic for the next PC value. This also involved moving the PCSrc logic determined by flags fed by the ALU into the control unit into a new module. This is as the control unit and ALU were in different stages of the pipeline. Alongside this, there was an additional mux implemented for selecting SrcB between immediates and register outputs. Which can be seen in the schematic below: 

![Pipeline Schematic](/images/pipelined_schematic.png)
