# Individual Statement: Dhyey

  

## Program Counter

  

The program counter has the same functionality as from lab 4. The only change made was to the offset according to the memory map so when PC is reset, it is reset to the value of the offset rather than 0. In the pipelined implementation, the program counter register was stalled when StallF was asserted to handle hazards.

![Program Counter Schematic](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/PCRegister.png)


### PC Wrapper

The functionality of program counter didn't need to be vastly changed throughout the project, so we decided that the PC Wrapper testbench was a sufficient unit test to check that PC is updated correctly by the relevant multiplexers. The multiplexer selects between PC + 4 (Next instruction) and PCTarget (Branch to this instruction), and this functionality is tested using PC Wrapper.


## Hazard Unit

I was responsible for developing the hazard unit and its testbench.

### Relevant commits

[Created top level hazard unit and dependencies](https://github.com/SanjitRaman/Team-10-RISC-V/commit/d220dd8ec95f9fa5c3f4ea1d7625c2596e89c057)

[Created hazard unit testbench](https://github.com/SanjitRaman/Team-10-RISC-V/commit/6f2984581dcf496e55b423bbf7fa2278c819dad4)


The hazard unit detects hazards and computes control signals for pipelining, so the processor can solve data and control hazards through stalling and forwarding. 

A data hazard occurs when an instruction accesses a register that has not been written back by a previous instruction.
A control hazard occurs with branching, as the next instruction to fetch has not been made by the time the fetch is made.

In software, a potential solution could be to insert nop instructions so the dependent instruction does not read from the register file immediately.

### Forwarding

In hardware, some data hazards can be solved by forwarding a result in a later pipeline stage to the dependent instruction in the execute stage. A multiplexer would be required to select SrcA and SrcB from either a later pipeline stage, or from the register file. 

If the source register in the Execute stage matches the destination register of an instruction in the Memory / Writeback stage, then the result should be forwarded.

Since both ALU operands will either be the result forwarded from the memory / writeback stage, or the result fetched from the register file, the multiplexer will have 3 inputs and a 2 bit select line.

| ForwardE | Description |
| -------------- | ---------------- |
| 10 | The operand will be forwarded from the memory stage. |
| 01 | The operand will be forwarded from the writeback stage. |
| 00 | The operand will be the register file output. |


A schematic of the hazard unit and forwarding multiplexers was designed in ISSiE, and is available in the [design specification](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/rtl/hazard_unit/readme.md). 

### Stalls

The load word instruction has a 2 cycle latency, so the register value cannot be used until 2 clock cycles later (where the data can be forwarded from the writeback stage). In order to solve this data hazard, the pipeline can be **stalled** when a load word is in the execute stage, and the load word destination register matches the source register operands in the Decode stage (i.e. a later instruction's source register is the load word destination register).

### Outputs

| Signal | Description |
| ----------- | ----------- |
| StallF | Stalls the fetch stage |
| StallD | Stalls the decode stage (StallF is also asserted)|
| FlushD | Clears the decode pipeline register |
| FlushE | Clears the execute pipeline register |
| ForwardAE | The value of SrcAE may be forwarded from the memory or writeback stage to solve a data hazard. |
| ForwardBE | The value of SrcBE may be forwarded from the memory or writeback stage to solve a data hazard. |

The hazard unit was well designed, so all of its unit tests passed but the team faced issues when developing the pipelined implementation, as discussed in the joint statement.

## Data Mem Wrapper 

I was responsible for creating a Data Mem Wrapper testbench ([Test Methodology Document for Data Memory Wrapper Testbench](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/testbench/data_mem_wrapper/readme.md)) to debug load and store instructions for both the single cycle and pipelined implementation. The data mem wrapper was later amended  to test the directly mapped write-through cache. [Data Mem Wrapper](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/rtl/data_mem_wrapper/readme.md) allows for the data memory and cache to be tested before it is integrated into the RISC-V processor, resulting in easier debugging.

### Final Wrapper Schematic

![Final Wrapper](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/DataMemWrapperCacheSchematic.png)


### Relevant Commits
[Store/Load instruction Testbench](https://github.com/SanjitRaman/Team-10-RISC-V/commit/7560907f9a24d305b654416bff91a21cc6fd8566)

[Cache Testbench](https://github.com/SanjitRaman/Team-10-RISC-V/commit/60f67f90e8442673966cab315851d6b4f4a4f32d)

### Using Google Test for testing cache

The following image shows the tests passing for directly mapped write-through cache.

![GoogleTestCache](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/DataMemWrapperCacheTests.png)



### Main issues faced when debugging the data memory and cache

 - Many issues stemmed from reading/writing from the data memory using Big Endian Byte Addressing. For little endian byte addressing, the least significant byte is stored at the **lowest address**.
 - For Store Byte, Store Half and Store Word, the write enable signals (WE3, WE2, WE1, WE0) were not asserted correctly.
 - The memory addresses did not initially correspond to the memory map.
 - We encountered issues updating cache after a cache miss, when the current instruction in the memory stage is a read instruction. For write instructions, we implemented a **write around** approach, so if there is a cache miss, **only main memory is updated**.
 - Reading from cache is **asynchronous** and writing to cache is **synchronous**, we encountered issues with asserting the hit signal correctly.













