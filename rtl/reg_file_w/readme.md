# Writeback Register File Design Specification 

## Overview
The `reg_file_w` module serves as a Write Back Register for a RISC-V processor. It is designed to hold memory data for the write-back stage, and provides outputs to the ALU, PC and register file. 

## Schematic
![](/images/RegFileW.png)

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
| `RegWriteM`     | 1            | Register Write signal from the Memory stage.             |
| `ResultSrcM`    | 2            | Source of the result signal from the Memory stage.       |
| `ALUResultM`    | DATA_WIDTH   | ALU result signal from the Memory stage.                 |
| `RD`            | DATA_WIDTH   | Data read from registers in the Memory stage.            |
| `RdM`           | ADDRESS_WIDTH| Destination register address from the Memory stage.       |
| `PCPlus4M`      | DATA_WIDTH   | Program Counter + 4 from the Memory stage.               |
| `funct3M`       | 3            | Funct3 signal from the Memory stage.                     |

## Outputs
| Signal          | Width        | Description                                              |
|-----------------|--------------|----------------------------------------------------------|
| `RegWriteW`     | 1            | Register Write signal for the Write Back stage.          |
| `ResultSrcW`    | 2            | Source of the result signal for the Write Back stage.    |
| `ALUResultW`    | DATA_WIDTH   | ALU result signal for the Write Back stage.              |
| `ReadDataW`     | DATA_WIDTH   | Data read from registers for the Write Back stage.       |
| `RdW`           | ADDRESS_WIDTH| Destination register address for the Write Back stage.    |
| `PCPlus4W`      | DATA_WIDTH   | Program Counter + 4 for the Write Back stage.            |
| `funct3W`       | 3            | Funct3 signal for the Write Back stage.                  |

## Functionality
On the rising edge of the clock (`posedge CLK`), the module directly passes signals from the memory stage to the write back stage.
