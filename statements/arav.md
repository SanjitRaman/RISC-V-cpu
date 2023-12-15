# Individual Statement: Arav
## Contributions
1. **Single Cycle:**
   - Implementing data_mem, we_decoder and ld_decoder: Worked with Sanjit
    - we_decoder - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/30580f67b0f426a6d60ad5d37643752995436fc8)
   		- Uses funct3 to choose which data mem write enables to set high which enables individual changing of bytes, halves and words.
       ![](/images/we_decoder_schematic.png)  
   	- ld_decoder - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/4012217fc36a53068556f6b54cbb3c0e2712ae9e)
   	  - Uses funct3 to choose how to display and sign extend the bytes
   	  ![](/images/ld_decoder_schematic.png)  
   - Implementing risc_v top_level: Worked with Sanjit - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/0a82bcc4988f2e8f48330b726470f37e9c3749ba)
     ![](/images/single_cycle-schematic.png) 
   - Testing and Debugging: Worked with Sanjit with input from Sri and Dhyey on their specific blocks
   	- Wrote PC testbench: Verification done by Sri using testbench - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/729030a22c16d17d55056e1d6e444a3a56609637)
   	- Wrote Control Unit testbench: Worked with Sanjit and Sri - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/effa93acdc25a545cf146b3369eccb2bd4304473)
   	- Wrote ALU testbench: Worked with Sri - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/a22e41885a22777edf9342813070eaf678358067)
        	- ALU Debugging - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/6d3f41905d0783726a24fecd44d7bb624322946e)
   	- Wrote risc_v_tb and debugged risc_v toplevel: Worked with Sanjit - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/6aa9bf33563dc8a23db23740f8e3b7725d6e2843)
   	- Wrote F1 light code - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/253b0befefa0293b3ab837c1599b318cc26dc482)
   	- Wrote b-type, j-type and u-type single instruction tests - Debugged these with Sanjit and Dhyey - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/991bcd032fbab5b5c8cdf697092155b1145bfd39)
   	  ![](/images/pdfDebug.png) 
 
2. **Pipelinined:**
   - Tested and debugged pipeline top level: Top level made by Sri with help from me - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/958d043b2ce32c2cf5880e0456c0ce58bbd49636)#
     ![](/images/pipelined_schematic.png) 
   - Errors
   	- BNE flush didn't work - Issue due to CLR in registers not being asynchronous so flush was not clearing registers - [Commit Link](https://github.com/SanjitRaman/Team-10-RISC-V/commit/c7d31306cd6da32eb7b4c5b3ca99df231a00150c)
   	- LW didn't work - Issue due to top-level not being connected correctly
   	- JAL didn't work - Issue due to sign_extend being wrong for jumps and ResultSrcE causing a Forward

3. **Cached:**
   - Helped to write directly mapped cache
   - Debugged and Tested cache - Program almost worked but cache was sometimes outputting incorrect values - problem was to do with hit timing being wrong but didn't have enough time to fix
    ![](/images/DebuggingCache.png)  
   
## Testing Methodology
- Each person wrote a google test testbench for either an entire module or part of a module that they hadn't worked on previously. This meant that when doing top level testing I could treat the 		various blocks kind of like black boxes and so was quicker to debug.
- My top level testing methodology was to first run counter, sinegen, F1light and finally pdf and I then know which instruction type is failing and can then open up the relevant waveforms.
- Worked backwards through the top level schematic to catch errors so if a register was not writing correctly then I would check Result, then all the inputs to the final MUX and keep going back until I find the error
	
### Special Design Decisions
- Added we_decoder and ld_decoder to simulate using interchangeable DRAM rather than changing the RAM logic as that is unrealistic
- Added mux before PC target to choose between immediate and register value so that JALR could be implemented.
- Result MUX has 4 outputs so that AUIPC can be implemented
- Upper imediate processing done in sign extend block and then just buffered through ALU which simplifies ALU logic.

### F1 Light Program
	setup:
    		addi a2, a2, 0x14    # Delay to use
    		addi a3, a3, 0xff
    		addi a4, a4, 0x4b

	clock:
    		addi a1, a1, 0x1
    		bne a1, a2, clock
    		sub a1, a1, a2
    		beq a0, a3, oddcase

	main:
    		slli a0, a0, 0x1
    		addi a0, a0, 0x1
    		beq a0, a3, rng
    		jal ra, clock 

	rng:
    		slli a4, a4, 0x1
    		andi a4, a4, 0x3ff
    		srli a5, a4, 0x2
    		srli a6, a4, 0x9
    		andi a5, a5, 0x1
    		andi a6, a6, 0x1
    		xor a5, a5, a6
    		add a4, a4, a5
    		andi a2, a2, 0x0
    		add  a2, a2, a4
    		jal ra, clock 
	
 	oddcase:
    		andi a0, a0, 0x0
This code implements the finite state machine that controls the NEOPIXEL bar on the VBuddy so that it it gradually increases and then turns off after a random delay. The clock loop determines the time between each state and the main is responsible for changing the states using left shifts and addis. The rng loop implements a 10 bit linear feedback shift register and we had planned to input a random seed based on the time when compiling so that the delay would be a random number each time but we did not get time to implement that in the makefile.

### Future Improvements
- 4 way cache to exploit spatial locality better
- I personally would add random number generation hardware because I am interested in cryptography
- Jump return address stack

## Reflection
I think that we did well as a team and everyone did their jobs to a high standard. For completeness, we implemented the entire RISC-V 32-bit base instruction set which wasn't entirely necessary but it meant that we understood what we were doing better and learnt a lot more. The drawback of this was that everything took a lot longer which meant that we were short on time at the end of the project. We tested our designs very rigorously including using the UVM methodology and code coverage analysers. We even wrote a testbench that tested whether each intruction was executing correctly. Given more time we would have modified this to work for the pipelined processor as well. If this was a real project then we would have had to make compromises about where we spent our time and efforts and would probably have to cut down on the testing and split up the work better but as this project is about learning we made the decision that rather than splitting the work we would work together more on individual parts so that everyone knew what was going on. I have a much better understanding of computer architecture now and not only understand what each component does and how they are linked together but also the choices between complexity and functionality that have to be made to build a general purpose processor compared with an ASIC that would have been highly optimised for 1 task.
![](/images/control_unit_line_coverage.png) 




