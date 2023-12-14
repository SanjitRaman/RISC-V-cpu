# Design Specification for the `pc` Module

## Overview
The pc module is a Program Counter (PC) for a RISC-V processor. It is designed to hold the address of the current instruction being executed.

## Parameters
- `DATA_WIDTH`: The width of the data bus. Default is 32.

## Inputs
- `CLK`: The clock signal.
- `RST`: The reset signal.
- `PCNext`: The next program counter value.

## Outputs
- `PC`: The current program counter value.

## Functionality
The `pc` module uses a resettable register in an `always_ff` block to hold the current program counter value.

On the rising edge of the clock (`posedge CLK`), the module performs the following operations:
- If the reset signal is high (`RST`), the module sets the program counter to 32'hBFC00000. This points to the beginning of the instruction memory data.
- Otherwise, the module sets the program counter to the next program counter value (PCNext).
