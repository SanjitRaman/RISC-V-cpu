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