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

### Register file

I wrote the register file for this processor, the specification for which can be found [here](/rtl/reg_file/readme.md). 

### Sign extend 

While implementing U and J type instructions, I had to update the sign extend module. My initial approach was to simply sign extend `Instr[31:12]` and pass on the extended 32-bit immediate to their respective modules to be decoded as they would never happen simultaneously in single cycle. This change allowed for only 4 cases to consider, and a smaller ImmSrc width. However, to account for pipelining in future, this had to be changed to 3 bits and the cases where split. The full specification for the sign extend module can be found [here](/rtl/sign_extend/readme.md). 

I wrote the testebench for the sign extend module. This was done through asserting the output of the module with an expected value, calculated with a switch case. I think this was a good method for testing as it was exhaustive and makes use of randomly generated immediates to test every case. The full test methodolgy can be found [here](/testbench/sign_extend/readme.md). 

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

## Cache

### Cache module 

I produced the inital prototype for our direct mapped write back cache. I did this based on the lecture notes and included synchronous write and read signals. Initially, writing was done on the `negative CLK` edge, including writeback from a `load` instruction, and reading was done on the `positive CLK` edge. Each set was comprised of a `Dirty Bit`, followed by a `Valid bit`, followed by the `tag` and then finally the `data`. 

When writing this, I noticed that additional stalls were needed to account for the write back and read instruction whenever there was not a hit. This logic persists in the updated [cache](/rtl/cache/) module written as a group and hit is sent as an output. 

We instead decided to try implement 2-way set associative cache. A prototype for this was also made by me. In this module, I used a queue style system to write to the ways. Every time there was a collision of sets and there was data to be written; the current cache would be pushed back so that way0 -> way1 and the data stored in way1 (if any and dirty) will get pushed out and stored in main memory. The new incoming data will be stored in way0. 

Now the sets were `{D0, V0, tag0, data0, D1, V1, tag1, data1}`. Where the number following indicated the way. The set width was also reduced from 3 bits to 2 bits, meaning we had 4 sets as opposed to 8 but supported storing two differently tagged pieces of data in the same set, meaning memory can be accessed less frequently in certain cases. 

By switching the order of the ways to be ascedinging, it is more scalable so that way0 is always the most recently used data and if we were to update to 4-way set associative, it would persist.

By implementing a queue system, it also simplifies the code of externally computing and retaining the order of most recently used cache ways. 

Due to confilcts and complexity issues with the stalls and top unit, we reverted to direct mapped write through cache together to try get a complete working model. 

### Updated top level schematic 

In order to implement the prototype direct mapped cache, I had to make some changes to the top level. 

This involved creating a flip flop for the `MemReadM` value so that it could be used as a control signal for a multiplexer along with `~hit`. The output of the flip flop was called `MemReadOld`. This would signify that the last instruction executed was a memory read, but the data was not found in cache. Therefore, we need to stall the CPU to retreive the data from main memory. This signal was called `NotHitStall`. 

After this is done, another stall signal is required to feed this data back into a multiplexer for the input data of cache. This signal was called `MainMemRetreiveStall` and was just `NotHitStall` passing through a D-type flip flop. 

And after this, one final stall was required to multiplex the potential input write data of the next instruction with the output read data from main memory. This signal was called `WBStall` (Write Back Stall) and was this time `MainMemRetreiveStall` passing through a flip flop. 

The three stall signals `NotHitStall`, `MainMemRetreiveStall`, `WBStall` were `OR`'d together to produce the signal `CacheStall` which was then fed into the Hazard Unit. 


### Updated hazard unit 

The protype updated hazard unit included the `CacheStall` signal as an input to account for the stalls required by writing back from main memory. In the final [hazard unit](/rtl/hazard_unit/), `CacheStall` is an internal signal and logic similar to the multiplexers added in the top level were moved into this unit to support the new logic. 

## Reflection

I think overall I have developed a deep understanding of each of the components and how they work and moreover, this module has greatly improved my testing methodology. I think if given more time I would like to update the cache files and take a full deep dive into the data path of the system and trace through to implement a more efficeint cache system. 