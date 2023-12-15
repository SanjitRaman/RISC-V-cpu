# Design Specification for the `hazard_unit` Module

## Overview
The `hazard_unit` module is a part of a RISC-V processor designed to handle data and control hazards. It utilizes forwarding and stalling mechanisms to ensure the correct execution of instructions.

## Schematic

![Hazard Unit Design](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/HazardUnit.png)

## Parameters

| Parameter       | Default | Description                                      |
|-----------------|---------|--------------------------------------------------|
| `ADDRESS_WIDTH` | 5       | The width of the address bus.                    |
| `FORWARD_WIDTH` | 2       | The width of the forward bus.                    |


## Inputs
| Signal        | Width | Description                                                                                     |
|---------------|-------|-------------------------------------------------------------------------------------------------|
| `Rs1D`, `Rs2D`|   `ADDRESS_WIDTH`   | Source register addresses from the decode stage.                                                |
| `RdE`, `Rs1E`, `Rs2E` |  `ADDRESS_WIDTH`     | Destination and source register addresses from the execute stage.                              |
| `PCSrcE`      |  1    | Control signal from the execute stage indicating whether the PC is being updated from the branch target. |
| `ResultSrcE0` |   1    | Control signal from the execute stage indicating the source of the result.                     |
| `RdM`         |   `ADDRESS_WIDTH`   | Destination register address from the memory stage.                                             |
| `RegWriteM`   |   1   | Control signal from the memory stage indicating whether a register write is to be performed.   |
| `RdW`         |   `ADDRESS_WIDTH`    | Destination register address from the writeback stage.                                         |
| `RegWriteW`   |  1     | Control signal from the writeback stage indicating whether a register write is to be performed.|

## Outputs
| Signal       | Width | Description                                                                                     |
|--------------|-------|-------------------------------------------------------------------------------------------------|
| `StallF`     |   1   | Control signal indicating whether the fetch stage should be stalled.                            |
| `StallD`     |   1   | Control signal indicating whether the decode stage should be stalled.                           |
| `FlushD`     |   1   | Control signal indicating whether the decode stage should be flushed.                           |
| `FlushE`     |   1   | Control signal indicating whether the execute stage should be flushed.                          |
| `ForwardAE`  |   `FORWARD_WIDTH`   | Control signal indicating the source of the data to be forwarded to the ALU input A.            |
| `ForwardBE`  |   `FORWARD_WIDTH`   | Control signal indicating the source of the data to be forwarded to the ALU input B.            |

## Functionality
The `hazard_unit` module uses an `lwstall` sub-module to detect load-use hazards and a `forward` sub-module to handle data forwarding.

- The `lwstall` sub-module checks ... and sets ...
- The `forward` sub-module checks ... and sets ...

#### TODO Check this:
The `hazard_unit` module then uses these signals to control the pipeline:

- If the `lwstall` signal is high, it stalls the fetch and decode stages (`StallF` and `StallD` are set high) and flushes the execute stage (`FlushE` is set high).
- If the `PCSrcE` signal is high, indicating a taken branch, it flushes the decode and execute stages (`FlushD` and `FlushE` are set high).
