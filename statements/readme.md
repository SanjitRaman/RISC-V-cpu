# Joint Statement on Challenges Faced

## Single Cycle

## Deciding the top level schematic, control paths for each instruction type 
### Authors: Sanjit, Sriyesh, Dhyey, Arav

In order to account for all the instructions and their datapaths, we had to reconsider the top level design. Building from our design in lab 4, we drew a new schematic in ISSIE to finalise our design. With this came the addition of a multiplexer to account for jump instructions and a 4-way multiplexer to computer the result based on the `ResultSrc` signal. This schematic also helped us visualise our respective [control paths](/rtl/control_unit/) when implementing different instruction types. 

![Single Cycle Schematic](/images/single-cycle-schematic.png)

## Load Decoder and WE Decoder added
### Authors: Sanjit, Dhyey, Arav

To support byte addressing when using the store instruction, we had to implement a new module, the write enable decoder. When a store instruction is called, it takes in `func3` as an input and considers the cases for storing a byte, half or word and outputs write enable signals to data memory. The specification for the write enable decoder can be found [here](/rtl/we_decoder/). 

Similarly for load instructions, a load decoder was made for load byte, word, half, signed and uinsigned which sign extend the data as required. The specification for the load decoder can be found [here](/rtl/ld_decoder/).

We chose to have two decoders to keep our design modular and robust as when it comes to implementing cache, it will be a simple matter of re-wiring the top level to pass through cache. 

## Flags added to ALU
### Authors: Sanjit, Sriyesh

In order to include more branch instructions; BLT, BGE, BLTU, BGEU, we needed more information than just the zero flag and branch flag. In order to do this, we had to consider if the ALU output was negative, if there was a unsigned carry, and if there was a signed overflow. By computing this in the ALU, there is no delay in clock cycles and they can be fed straight back into the control unit for when they are needed for the subsequent instruction. Alongside this, we computed an intermediary flag `signed_greater_than` in the control unit to help with the branch logic. More can be read in the [control unit specification](/rtl/control_unit/). The implementation of the flags can be seen in the [ALU specification](/rtl/alu/). 

- Deciding on testing methodology -- google tests
    - link to google test + verilator example
    - single instruction tests
    - mention UVM and why we didn't use it

- Debugging top level schematic
    - know that module level tests pass
    - using gtkwave to debug the top level schematic to check connections and control signals.

- Makefile
    - was difficult.
