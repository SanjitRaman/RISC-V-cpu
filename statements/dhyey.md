# Individual Statement: Dhyey

  

## Program Counter

  

The program counter has the same functionality as from lab 4. The only change made was to the offset according to the memory map so when PC is reset, it is reset to the value of the offset rather than 0.
  

(INSERT DIAGRAM OF PC)

  
  

## Hazard Unit

  

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



A schematic of the hazard unit and forwarding multiplexers was designed in ISSiE.

## Stalls

The load word instruction has a 2 cycle latency, so the register value cannot be used until 2 clock cycles later (where the data can be forwarded from the writeback stage). In order to solve this data hazard, the pipeline can be **stalled** when a load word is in the execute stage, and the load word destination register matches the source register operands in the Decode stage (i.e. a later instruction's source register is the load word destination register).


lwStall = ResultSrcE0 & (Rs1D == RdE

(INSERT ISSIE DIAGRAM)


## Outputs

| Signal | Description |
| ----------- | ----------- |
| StallF | Stalls the fetch stage |
| StallD | Stalls the decode stage (StallF is also asserted)|
| FlushD | Clears the decode pipeline register |
| FlushE | Clears the execute pipeline register |
| ForwardAE | The value of SrcAE may be forwarded from the memory or writeback stage to solve a data hazard. |
| ForwardBE | The value of SrcBE may be forwarded from the memory or writeback stage to solve a data hazard. |
