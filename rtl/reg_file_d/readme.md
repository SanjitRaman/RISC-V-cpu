# Decode Register File Design Specification

## Overview
The `reg_file_d` module serves as a Decode Register for a RISC-V processor. Its purpose is to hold fetched information and provide outputs for the control unit and decode stage.

## Schematics

![reg_file_d](https://github.com/SanjitRaman/Team-10-RISC-V/blob/vbuddy-pipelining-tests/images/RegFileD.png)


## Parameters
| Parameter   | Description                           | Default |
|-------------|---------------------------------------|---------|
| DATA_WIDTH  | The width of the data bus.            | 32      |

## Inputs
| Signal    | Width        | Description                                              |
|-----------|--------------|----------------------------------------------------------|
| `CLK`     | 1            | The clock signal.                                        |
| `CLR`     | 1            | The clear signal.                                        |
| `EN`      | 1            | The enable signal.                                      |
| `RD`      | `DATA_WIDTH` | Data input for register decoding.                        |
| `PCF`     | `DATA_WIDTH` | Current Program Counter (PC) input for the current stage.|
| `PCPlus4F`| `DATA_WIDTH` | Input for the next Program Counter (PC + 4).            |

## Outputs
| Signal    | Width        | Description                                              |
|-----------|--------------|----------------------------------------------------------|
| `InstrD`  | `DATA_WIDTH` | Decoded instruction output.                              |
| `PCD`     | `DATA_WIDTH` | Decoded Program Counter output.                          |
| `PCPlus4D`| `DATA_WIDTH` | Decoded next Program Counter (PC + 4) output.            |

## Functionality
On the rising edge of the clock (`posedge CLK`), the module performs the following operations:

- If the clear signal (`CLR`) is asserted, the module flushes its outputs, setting them to zero.
- If the enable signal (`EN`) is de-asserted, the module passes the inputs through to the outputs for decoding.

