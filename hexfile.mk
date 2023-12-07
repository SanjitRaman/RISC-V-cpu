# hexfile.mk


# got to work for:
# programs/f1_starting_light/f1_starting_light.s
# 

# TARGET:
# programs/single_instruction_tests/add/instr_mem.mem
# WANT: programs/single_instruction_tests/add/add.s
#       $(PROGRAMS_DIR)/$(PROGRAM_NAME)/$(notdir $(PROGRAM_NAME)).s
# PROGRAM: programs/single_instruction_tests/add/instr_mem.mem
# PROGRAM_NAME:  single_instruction_tests/add
# PROGRAMS_DIR:  programs

reference: $(PROGRAMS_DIR)/$(PROGRAM_NAME)/$(notdir $(PROGRAM_NAME)).s
	@riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o "$?.out" "$?"
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o "$?.out.reloc" "$?.out"
	@rm "$?.out"
	@riscv64-unknown-elf-objcopy -O binary -j .text "$?.out.reloc" "$?.bin"
	@rm "$?.out.reloc"
	@./format_mem.sh "$?"
	@rm "$?.bin"

assemble: debug reference
	@echo "pwd: " $(shell pwd)
	@echo "PROGRAM: " $(PROGRAM)
	cp $(PROGRAM) $(MEM_DIR)/instr_mem.mem

ifneq ($(wildcard $(dir $(PROGRAM))/data_mem.mem),)
	cp $(dir $(PROGRAM))/data_mem.mem $(MEM_DIR)/data_mem.mem
endif

# Debugging target to print variables
debug:
	@echo "S_FILES: $(S_FILES)"
	@echo "S_MEM_FILES: $(S_MEM_FILES)"
	@echo "PROGRAM: $(PROGRAM)"
	@echo "PROGRAMS_DIR: " $(PROGRAMS_DIR)
	@echo "PROGRAM_NAME: " $(PROGRAM_NAME)
	@echo "add: " $(notdir $(PROGRAM_NAME))
	@echo ".s target: " $(PROGRAMS_DIR)/$(PROGRAM_NAME)/$(PROGRAM_NAME).s
	@echo $(PROGRAM)
	@echo "dirname program: " $(dir $(PROGRAM))