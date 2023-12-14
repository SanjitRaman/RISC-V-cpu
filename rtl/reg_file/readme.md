# Register File Design Specification

## Overview
This document describes the design and functionality of a register file implemented in SystemVerilog. The register file is parameterized by address width and data width.

## Parameters
- `ADDRESS_WIDTH`: The width of the address for the register file. Default is 5 bits.
- `DATA_WIDTH`: The width of the data stored in the register file. Default is 32 bits.

## Inputs
- `CLK`: The clock signal.
- `A1`, `A2`, `A3`: The read and write addresses for the register file.
- `address_to_view`: The address of the register to view.
- `WE3`: The write enable signal. When `WE3` is high, data is written to the register at address `A3`.
- `WD3`: The write data. When `WE3` is high, `WD3` is written to the register at address `A3`.

## Outputs
- `RD1`, `RD2`: The read data. `RD1` is the data from the register at address `A1`, and `RD2` is the data from the register at address `A2`.
- `reg_output`: The data from the register at `address_to_view`.
- `a0`: The data from the register at address `5'hA`.

## Register Array
The register file is implemented as a 1D array of logic vectors, registers, with a width of `DATA_WIDTH` and a depth of 2**`ADDRESS_WIDTH`.

## Operations
### Write Operation
The **write operation is synchronous**, meaning that the data is written to the register on the positive edge of the clock.

On the positive edge of the clock, if `WE3` is high and `A3` is not zero, the data `WD3` is written to the register at address `A3`.

### Read Operation
The **read operation is asynchronous**, meaning that the data is available on the output pins as soon as the address is set.

The data from the registers at addresses `A1` and `A2` is continuously driven onto `RD1` and `RD2`, respectively. The data from the register at `address_to_view` is continuously driven onto `reg_output`. The data from the register at address `5'hA` is continuously driven onto `a0`.

## Limitations
This register file implementation does not handle simultaneous read and write operations to the same address. If a read and a write to the same address occur in the same clock cycle, the old data will be read out, not the new data. This is because the write operation takes effect on the positive edge of the clock, but the read operation is combinational.