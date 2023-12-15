# Joint Statement on Challenges Faced

## Single Cycle

## Deciding the top level schematic, control paths for each instruction type 
### Authors: Sanjit, Sriyesh, Dhyey, Arav

In order to account for all the instructions and their datapaths, we had to reconsider the top level design. Building from our design in lab 4, we drew a new schematic in ISSIE to finalise our design. With this came the addition of a multiplexer to account for jump instructions and a 4-way multiplexer to computer the result based on the `ResultSrc` signal. This schematic also helped us visualise our respective [control paths](/rtl/control_unit/readme.md#r-type-control-path) when implementing different instruction types. 

![Single Cycle Schematic](/images/single-cycle-schematic.png)

We produced the following set of control paths for each instruction type:

| R-Type | I-Type |
:--:|:--:
| ![single-cycle-control-path-r-type](/images/r-type_control_path.png) | ![single-cycle-control-path-i-type](/images/i-type_control_path.png) |
| S-Type | B-Type |
:--:|:--:
| ![single-cycle-control-path-s-type](/images/s-type_control_path.png) | ![single-cycle-control-path-b-type](/images/b-type_control_path.png) |
| AUIPC | LUI |
:--:|:--:
| ![](/images/AUIPC_control_path.png) | ![](/images/LUI_control_path.png) |
| JALR | JAL |
:--:|:--:
| ![](/images/JALR_control_path.png) | ![](/images/JAL_control_path.png) |

## Load Decoder and WE Decoder added
### Authors: Sanjit, Dhyey, Arav

To support byte addressing when using the store instruction, we had to implement a new module, the write enable decoder. When a store instruction is called, it takes in `func3` as an input and considers the cases for storing a byte, half or word and outputs write enable signals to data memory. The specification for the write enable decoder can be found [here](/rtl/we_decoder/). 

Similarly for load instructions, a load decoder was made for load byte, word, half, signed and uinsigned which sign extend the data as required. The specification for the load decoder can be found [here](/rtl/ld_decoder/).

We chose to have two decoders to keep our design modular and robust as when it comes to implementing cache, it will be a simple matter of re-wiring the top level to pass through cache. 

## Flags added to ALU
### Authors: Sanjit, Sriyesh

In order to include more branch instructions; BLT, BGE, BLTU, BGEU, we needed more information than just the zero flag and branch flag. In order to do this, we had to consider if the ALU output was negative, if there was a unsigned carry, and if there was a signed overflow. By computing this in the ALU, there is no delay in clock cycles and they can be fed straight back into the control unit for when they are needed for the subsequent instruction. Alongside this, we computed an intermediary flag `signed_greater_than` in the control unit to help with the branch logic. More can be read in the [control unit specification](/rtl/control_unit/). The implementation of the flags can be seen in the [ALU specification](/rtl/alu/). 

## Deciding on testing methodology
#### Authors: Sanjit
Due to the use of Verilator in this project, we were limited in our options for testing, meaning that industry standard options such:
- [UVM](https://www.chipverify.com/uvm/uvm-testbench-top) (Universal Verification Methodology)
- [SVUnit](https://github.com/svunit/svunit) does not support Verilator
- [Cocotb](https://docs.cocotb.org/en/stable/index.html) does not support Verilator 4.226 which is installed in lab0. Perhaps in the future, autumn term coursework could use a newer version of Verilator which supports Cocotb.
- SVA (SystemVerilog Assertions) supported, but we could not get it to work with Verilator.

would not be possible. Instead, since Verilator supports C++ testbenches, we decided to use Google Tests, a C++ testing framework.

We got started using a GitHub repository which integrates Google Tests with Verilator, which can be found [here](https://github.com/mortenjc/systemverilog)


We would test each module individually using a set of Google Tests, and then when we were confident that each module was working, we would test the entire top level schematic using another set of Google Tests which ran one instruction at a time and tests the behaviour of the CPU.

## Makefile
#### Authors: Sanjit
The makefile had to be completely re-written from the mortenjc GoogleTests Verilator example to support a recursive folder structure which was quite challenging.

Furthermore, the makefile needed to support the following modes:
- Google Tests (`GTEST=1`)
    - this required conditionally including the `GTEST_FLAGS`
- VBuddy (`VBUDDY=1`)
    - this would run the simulation in VBuddy mode, which would allow us to use the VBuddy peripherals.
- Single Instruction Tests (`SINGLE_INSTRUCTION_TESTS=1`)
    - this would run different testbenches for the top-level by including different header files.

Additionally, for top-level testing, the makefile needed to have features to support assembling code from the programs folder, and loading the assembled code into the CPU memory. This was modified from the [Project Brief makefile](https://github.com/EIE2-IAC-Labs/Project_Brief/blob/main/reference/Makefile).


## Debugging top level schematic
#### Authors: Arav, Sanjit

Having tested modules individually, we know that given the correct set of inputs, each module will produce the desired output.
Then we had to debug the top level to determine whether the modules were connected correctly and the control signals were being set correctly.

This was a new skill to learn, using gtkwave to debug the top-level schematic, starting from the instruction and working our way through the CPU:

![debugging-top-level-addi-instruction](/images/debugging-top-level.png)

We noticed that the muxes were not connected in the correct order.

![debugging-top-level-addi-gtkwave](/images/debugging-top-level-addi-incorrect.png)

Once we fixed this, the addi instruction worked correctly:

![debugging-top-level-addi-gtkwave-working](/images/debugging-top-level-addi-working-correctly.png)

There were several more examples of this, including incorrect control unit signal values for certain instruction-types, which we fixed in the same manner.

We learnt a lot about debugging large systems throughout this process.

## Pipelining 
#### Authors: Arav, Sanjit
Pipelining isn't that much of a step up from single-cycle when it comes to implementation but when it comes to debugging it is a totally different challenge. The loss in synchronisation is difficult to get used to but once we did it was quite enjoyable to debug but until that point, progress was excruciatingly slow. There were many mistakes in the top level due to a lax naming convention so the first challenge was cleaning up the top level so that all signals had appropriate and unique names. 

#### Pipelining Registers
The next set of problems came in the pipelining registers as the sensitivity lists were only updated on CLK edges so there were cases when stalls and flushes were not occurring when they should have been which led to problems in branches and jumps. Initially we believed this to be a flaw in the flags block which we added to compute whether the branch conditions had been met so the error took longer to debug than it should have. There was an error in the hazard block where reg_file_e should have been flushed when a stall was meant to happen as no computation or forwarding should be done in the execute stage during a stall.

#### Top Level Issues
Due to the multitude of signals the top level was difficult to debug but after the cleanup it turned out only one instruction was failing and that was JAL. This was extremely difficult to debug because our implementation worked in single-cycle and we did not think about the fact that it would break in pipelining. We were using the Result MUX to write PC+4 back to the register which was interfering with our forwarding and flush logic. It was a very simple fix where we just had to change the control unit and the Result MUX but it took a long time to diagnose.

## Cache
#### Authors: Arav, Dhyey
Due to the buzz from getting pipelining working, we pushed the boat out a bit too far with cache and tried to implement a 2 way associative cache. It seemed to work for nearly all the test cases but 1 was always failing. Every time the cache was written to it wasn't writing back to the data memory properly which meant that store and load instructions didn't work fully. We spent time debugging this and found some small errors to do with hit logic and timing but we couldn't fix this case. We decided to take a step back and implement a directly mapped cache instead. The directly mapped cache was very simple but when loading we were still having errors. We tried various things like making the read and write addresses seperate, moving continuous assignment logic into sequential blocks but we couldn't find a solution and due to time constraints we decided to stop debugging and move on to the other tasks that were remaining. 
