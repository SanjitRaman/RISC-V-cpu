# Execute Register File Design Specification

## Overview
The `reg_file_e` module serves as an Execute Register for a RISC-V processor. It is designed to handle register-related operations during the execution stage of the processor, providing outputs for ALU, flags unit and related multiplexers.

## Schematic
![reg_file_e](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/RegFileE.png)


## Parameters
| Parameter         | Description                           | Default |
|-------------------|---------------------------------------|---------|
| ADDRESS_WIDTH     | Width of the address bus.              | 5       |
| DATA_WIDTH        | Width of the data bus.                 | 32      |
| ALU_CTRL_WIDTH    | Width of the ALU control signal.       | 4       |
| FUNCT3_WIDTH      | Width of the funct3 signal.            | 3       |
| OP_WIDTH          | Width of the operation code signal.    | 7       |

## Inputs
| Signal          | Width        | Description                                              |
|-----------------|--------------|----------------------------------------------------------|
| `CLK`           | 1            | The clock signal.                                        |
| `CLR`           | 1            | The clear signal.                                        |
| `RegWriteD`     | 1            | Register Write signal from the Decode stage.             |
| `ResultSrcD`    | 2            | Source of the result signal from the Decode stage.      |
| `MemWriteD`     | 1            | Memory Write signal from the Decode stage.               |
| `JumpD`         | 1            | Jump signal from the Decode stage.                       |
| `BranchD`       | 1            | Branch signal from the Decode stage.                     |
| `ALUControlD`   | 4            | ALU control signal from the Decode stage.                |
| `ALUSrcD`       | 1            | ALU source signal from the Decode stage.                 |
| `RD1`           | DATA_WIDTH   | Data from register 1 from the Decode stage.              |
| `RD2`           | DATA_WIDTH   | Data from register 2 from the Decode stage.              |
| `PCD`           | DATA_WIDTH   | Program Counter value from the Decode stage.             |
| `Rs1D`          | ADDRESS_WIDTH| Source register 1 address from the Decode stage.         |
| `Rs2D`          | ADDRESS_WIDTH| Source register 2 address from the Decode stage.         |
| `RdD`           | ADDRESS_WIDTH| Destination register address from the Decode stage.      |
| `ImmExtD`       | DATA_WIDTH   | Sign-extended immediate value from the Decode stage.     |
| `PCPlus4D`      | DATA_WIDTH   | Program Counter + 4 from the Decode stage.               |
| `funct3D`       | 3            | Funct3 signal from the Decode stage.                     |
| `opD`           | 7            | Operation code signal from the Decode stage.             |

## Outputs
| Signal          | Width        | Description                                              |
|-----------------|--------------|----------------------------------------------------------|
| `RegWriteE`     | 1            | Register Write signal for the Execute stage.             |
| `ResultSrcE`    | 2            | Source of the result signal for the Execute stage.       |
| `MemWriteE`     | 1            | Memory Write signal for the Execute stage.               |
| `JumpE`         | 1            | Jump signal for the Execute stage.                       |
| `BranchE`       | 1            | Branch signal for the Execute stage.                     |
| `ALUControlE`   | 4            | ALU control signal for the Execute stage.                |
| `ALUSrcE`       | 1            | ALU source signal for the Execute stage.                 |
| `RD1E`          | DATA_WIDTH   | Data from register 1 for the Execute stage.              |
| `RD2E`          | DATA_WIDTH   | Data from register 2 for the Execute stage.              |
| `PCE`           | DATA_WIDTH   | Program Counter value for the Execute stage.             |
| `Rs1E`          | ADDRESS_WIDTH| Source register 1 address for the Execute stage.         |
| `Rs2E`          | ADDRESS_WIDTH| Source register 2 address for the Execute stage.         |
| `RdE`           | ADDRESS_WIDTH| Destination register address for the Execute stage.      |
| `ImmExtE`       | DATA_WIDTH   | Sign-extended immediate value for the Execute stage.     |
| `PCPlus4E`      | DATA_WIDTH   | Program Counter + 4 for the Execute stage.               |
| `funct3E`       | 3            | Funct3 signal for the Execute stage.                     |
| `opE`           | 7            | Operation code signal for the Execute stage.             |

## Functionality
On the rising edge of the clock (`posedge CLK`), the module performs the following operations:

- If the clear signal (`CLR`) is asserted, the module flushes its outputs, setting them to zero.
- Otherwise, it passes the relevant signals from the Decode stage to the Execute stage.

