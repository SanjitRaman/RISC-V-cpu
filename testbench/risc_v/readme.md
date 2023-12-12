# Test Summary for RISC-V Top Level

## Overview

By selecting the appropriate testbench by modifying the include in risc_v_tb.cpp, two different testbenches can be run. 
### `#include "versions/risc_v_single_instructions.h"` 
will run a google test suite that tests each instruction individually at the top level, and generates waveforms for each instruction. This was used to aid in debugging.

### `#include "versions/risc_v_full_program.h"` 
will run a variety of test programs found in the `programs/` directory, by setting the `PROGRAM_NAME` in the make command. Furthermore, the testbench will generate a waveform for the entire program, and if the VBUDDY is connected, it will interact with the VBuddy to display the register values on the TFT display and/or the NeoPixel LEDs as well as the cycle count. Example programs that can be run:
    
- `PROGRAM_NAME=counter` will run a program that increments the value in register `a0` until 255, and then resets to 0, and repeats. The value in `a0` is displayed on the TFT display.

  Results:

https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/2492e76d-793d-4d1b-a8fe-2ea2dc4fc37d

