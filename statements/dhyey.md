# Individual Statement: Dhyey

  

## Program Counter

  

The program counter has the same functionality as from lab 4. The only change made was to the offset according to the memory map.

  

(INSERT DIAGRAM OF PC)

  
  

## Hazard Unit

  

The hazard unit detects hazards and computes control signals for pipelining, so the processor can solve data and control hazards through stalling and forwarding. 

A data hazard occurs when an instruction accesses a register that has not been written back by a previous instruction.
A control hazard occurs with branching, as the next instruction to fetch has not been made by the time the fetch is made.

In software, a potential solution could be to insert nop instructions so the dependent instruction does not read from the register file immediately.

### Forwarding



an instruction tries to read a register that has not yet been written back by a previous instruction. A control hazard occurs when the decision of what instruction to fetch next has not been made by the time the fetch takes place.


A top level schematic of the hazard unit was designed in ISSiE.


  

(INSERT ISSIE DIAGRAM)

  

| Signal | Description |
| ----------- | ----------- |
| StallF | Stalls the fetch stage |
| StallD | Stalls the decode stage (StallF is also asserted)|
| FlushD | Clears the decode pipeline register |
| FlushE | Clears the execute pipeline register |
| ForwardAE | The value of SrcAE may be forwarded from the memory or writeback stage to solve a data hazard. |
| ForwardBE | The value of SrcBE may be forwarded from the memory or writeback stage to solve a data hazard. |