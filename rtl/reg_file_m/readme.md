# Memory Register File Design Specification

## Overview
The `reg_file_m` module serves as a Memory Register for a RISC-V processor. It is responsible for holding signals in the memory stage and providing outputs into the writen enable decoder and memory. 

## Schematic
![](/images/RegFilem.png)

## Parameters
| Parameter         | Description                           | Default |
|-------------------|---------------------------------------|---------|
| ADDRESS_WIDTH     | Width of the address bus.              | 5       |
| DATA_WIDTH        | Width of the data bus.                 | 32      |
| FUNCT3_WIDTH      | Width of the funct3 signal.            | 3       |

## Inputs
| Signal          | Width        | Description                                              |
|-----------------|--------------|----------------------------------------------------------|
| `CLK`           | 1            | The clock signal.                                        |
| `RegWriteE`     | 1            | Register Write signal from the Execute stage.            |
| `ResultSrcE`    | 2            | Source of the result signal from the Execute stage.      |
| `MemWriteE`     | 1            | Memory Write signal from the Execute stage.               |
| `ALUResultE`    | DATA_WIDTH   | ALU result signal from the Execute stage.                |
| `WriteDataE`    | DATA_WIDTH   | Data to be written to memory from the Execute stage.     |
| `RdE`           | ADDRESS_WIDTH| Destination register address from the Execute stage.      |
| `PCPlus4E`      | DATA_WIDTH   | Program Counter + 4 from the Execute stage.               |
| `funct3E`       | 3            | Funct3 signal from the Execute stage.                     |

## Outputs
| Signal          | Width        | Description                                              |
|-----------------|--------------|----------------------------------------------------------|
| `RegWriteM`     | 1            | Register Write signal for the Memory stage.              |
| `ResultSrcM`    | 2            | Source of the result signal for the Memory stage.        |
| `MemWriteM`     | 1            | Memory Write signal for the Memory stage.                 |
| `ALUResultM`    | DATA_WIDTH   | ALU result signal for the Memory stage.                  |
| `WriteDataM`    | DATA_WIDTH   | Data to be written to memory for the Memory stage.       |
| `RdM`           | ADDRESS_WIDTH| Destination register address for the Memory stage.        |
| `PCPlus4M`      | DATA_WIDTH   | Program Counter + 4 for the Memory stage.                 |
| `funct3M`       | 3            | Funct3 signal for the Memory stage.                       |

## Functionality
The `reg_file_m` module uses a (`posedge CLK`) sensitive `always_ff` block to directly pass signals from the Execute stage to the Memory stage.
