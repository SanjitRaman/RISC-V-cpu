# Program Counter Design Specification

## Overview
The pc module is a Program Counter (PC) for a RISC-V processor. It is designed to hold the address of the current instruction being executed.

## Schematic
![PC Schematic and surrounding logic](/images/pc_schematic.png)

## Parameters
| Parameter   | Description                           | Default |
|-------------|---------------------------------------|---------|
| DATA_WIDTH  | The width of the data bus.            | 32      |

## Inputs
| Signal | Width | Description                     |
|--------|-------|---------------------------------|
| CLK    |     1 | The clock signal.               |
| RST    |     1 | The reset signal.               |
| EN     |     1 | The enable signal. (Active low) |
| PCNext | DATA_WIDTH | The next program counter value.|

## Outputs

| Signal | Width | Description                   |
|--------|-------|-------------------------------|
| PC     |   DATA_WIDTH   | The current program counter value. |

## Functionality
The `pc` module uses a resettable register in an `always_ff` block to hold the current program counter value.

On the rising edge of the clock (`posedge CLK`), the module performs the following operations:
- If the reset signal is high (`RST`), the module sets the program counter to 32'hBFC00000. This points to the beginning of the instruction memory data.
- Otherwise, if the enable signal is low,  the module sets the program counter to the next program counter value (PCNext).
