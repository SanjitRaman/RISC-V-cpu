# Results of Sample Programs on RISC-V

## Overview

By selecting the appropriate testbench by modifying the include in risc_v_tb.cpp, two different testbenches can be run. 
### `#include "versions/risc_v_single_instructions.h"` 
will run a google test suite that tests each instruction individually at the top level, and generates waveforms for each instruction. This was used to aid in debugging.

### `#include "versions/risc_v_full_program.h"` 
will run a variety of test programs found in the `programs/` directory, by setting the `PROGRAM_NAME` in the make command. Furthermore, the testbench will generate a waveform for the entire program, and if the VBUDDY is connected, it will interact with the VBuddy to display the register values on the TFT display and/or the NeoPixel LEDs as well as the cycle count. Example programs that can be run:
    
#### 1. `PROGRAM_NAME=counter` 
will run a program that increments the value in register `a0` until 255, and then resets to 0, and repeats. The value in `a0` is displayed on the TFT display.

  Results:

https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/2492e76d-793d-4d1b-a8fe-2ea2dc4fc37d


#### 2. `PROGRAM_NAME=sinegen` 
will run a program that given 255 sinewave values stored in memory, it will output the values as a plot on the TFT display in a loop.

  Results:

https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/12beec92-b309-43c3-bc99-5edddbc0e4f7

#### 3. `PROGRAM_NAME=f1_starting_light`
will run a program that emulates f1 starting lights in a Formula 1 Race. The NeoPixel LED's initially are all off, and with a delay, an additional LED turns on until all lights are on. Then, after a delay, all lights turn off. Note, that this delay is currently not random, and is hardcoded by the assembly programmer. In a real CPU, a random noise is converted from an analog signal into a digital value, in a dedicated random number generator on-chip. This could have been mimicked on the VBuddy using the microphone input to generate such a random delay.

  Results:

https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/9e75e71e-9ed2-4cc6-ac81-3d56b58092bf

#### 4. `PROGRAM_NAME=pdf`
will run the reference program for the Autumn Term IAC Lab. Given that the related dataset is loaded into memory through the file `data_mem.mem`, the program indexes through the data, and each time a byte X appears, it increments the value stored in the bin at location (0x100 + X). Once a bin reaches a count of 200, the program stops indexing through the data, and then loops through each bin, writing the count of each bin to the register `a0` to be viewed on the TFT display of the VBuddy.

  Results: Gaussian Distribution

https://github.com/SanjitRaman/Team-10-RISC-V/assets/51057192/2f3f9ec4-ff3f-474b-99aa-684f8a21fd73

  Results: 
