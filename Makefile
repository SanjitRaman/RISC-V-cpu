# Makefile

include testbench_select.mk

# configure variables to run both top-level testbenches and unit testbenches.
ifeq ($(RUN), module)
	NAME = $(MODULE)
	INCLUDE_DIRS = $(MODULE.INCLUDE_DIRS)
	SOURCES = design/$(NAME)/$(NAME).sv

else
	NAME = $(UNIT)
	INCLUDE_DIRS = $(UNIT.INCLUDE_DIRS)
	SOURCES = design/$(NAME).sv

endif

# Set the Verilator executable
VERILATOR = verilator

# Set Verilator flags
VERILATOR_FLAGS = -Wall --coverage --cc --trace
VERILATOR_COVERAGE_FLAGS = --annotate logs/annotate --annotate-all --annotate-min 1

# Set additional flags for compiling C++ files
CXX_FLAGS = -std=c++17 -DVBD=$(VBUDDY) -DPROGRAM_NAME=$(PROGRAM_NAME) -DSINGLE_INSTRUCTION_TESTS=$(SINGLE_INSTRUCTION_TESTS)

# Set Google Test library paths
GTEST_LIB_DIR = ../../googletest/build/lib
GTEST_INCLUDE_DIR = ../../googletest/googletest/include

# Set Google Test flags
ifeq ($(GTEST), 1)
	GTEST_FLAGS = -LDFLAGS "-L$(GTEST_LIB_DIR) -lgtest -lpthread" \
				  -CFLAGS "$(CXX_FLAGS)" \
				  -CFLAGS "-I$(GTEST_INCLUDE_DIR)"
else
	GTEST_FLAGS = -CFLAGS "$(CXX_FLAGS)"
endif

# Set makefile directories
TOP_DIR = .
BUILD_DIR = build/$(NAME)
BIN_DIR = bin
MEM_DIR = memory
LOGS_DIR = logs
TESTBENCH_DIR = testbench
PROGRAMS_DIR = programs
VBUDDY_DIR = vbuddy

# Set testbench source and testbench executable
TB_SOURCE = $(TESTBENCH_DIR)/$(NAME)/$(NAME)_tb.cpp
TB_EXECUTABLE = $(NAME)_tb

# Set program memory files
PROGRAM_NAME ?= single_instruction_tests/addi
PROGRAM = $(PROGRAMS_DIR)/$(PROGRAM_NAME)/instr_mem.mem
DATA_MEMORY  = $(PROGRAMS_DIR)/$(PROGRAM_NAME)/data_mem.mem


# Set makefile targets
TARGET = $(BIN_DIR)/$(NAME)

include_vbuddy:
# Copy VBuddy files to the bin directory
	@echo "Including VBuddy Files..."
	@cp $(VBUDDY_DIR)/vbuddy.cpp $(BUILD_DIR)/
	@cp $(VBUDDY_DIR)/vbuddy.cfg $(BIN_DIR)/

create_dirs:
	@echo "Creating build and bin directories..."
	$(shell mkdir -p $(BUILD_DIR))
	$(shell mkdir -p $(BIN_DIR))
	$(shell mkdir -p $(LOGS_DIR))

assemble: $(PROGRAMS_DIR)/$(PROGRAM_NAME)/$(notdir $(PROGRAM_NAME)).s
	@riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o "$?.out" "$?"
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o "$?.out.reloc" "$?.out"
	@rm "$?.out"
	@riscv64-unknown-elf-objcopy -O binary -j .text "$?.out.reloc" "$?.bin"
	@rm "$?.out.reloc"
	@./format_mem.sh "$?"
	@rm "$?.bin"
	cp $(PROGRAMS_DIR)/$(PROGRAM_NAME)/instr_mem.mem $(MEM_DIR)/instr_mem.mem
ifneq ($(wildcard $(dir $(PROGRAM))/data_mem.mem),)
	cp $(dir $(PROGRAM))/data_mem.mem $(MEM_DIR)/data_mem.mem
endif


$(TARGET): $(TB_SOURCE)
	@echo "Compiling Verilog sources and C++ testbench..."
	$(VERILATOR) $(VERILATOR_FLAGS) \
		$(SOURCES) \
		$(INCLUDE_DIRS) \
		-Mdir $(BUILD_DIR) \
		--prefix $(NAME) \
		--exe $(realpath $(TB_SOURCE)) \
		-o $(TB_EXECUTABLE) \
		$(GTEST_FLAGS)
		
	make -C $(BUILD_DIR) -j 8 -f $(NAME).mk
	cp $(BUILD_DIR)/$(TB_EXECUTABLE) $(TARGET)


create_symlinks:
	@echo "Creating symlinks..."
	$(foreach file, $(wildcard $(MEM_DIR)/*), \
		ln -s $(realpath $(file)) $(BIN_DIR)/$(notdir $(file));)

# Makefile rules
all: create_dirs include_vbuddy create_symlinks $(TARGET)


runtest: all $(TARGET)
	@echo "Running testbench..."
	@echo $(BIN_DIR)/$(patsubst $(BIN_DIR)/%,%,$(TARGET))
	cd $(BIN_DIR) && ./$(patsubst $(BIN_DIR)/%,%,$(TARGET))
ifeq ($(GTEST), 1)
	@echo "Moving logs to logs directory..."
	mv $(BIN_DIR)/logs/ $(realpath .)
endif

gtkwave: runtest
	@echo "Running GTKWave..."
	mv $(BIN_DIR)/$(NAME).vcd $(LOGS_DIR)/$(NAME).vcd
	gtkwave $(LOGS_DIR)/$(NAME).vcd

coverage: runtest
	@echo "Generating coverage report..."
	verilator_coverage $(VERILATOR_COVERAGE_FLAGS) -write-info logs/merged.info logs/coverage_$(NAME).dat

genhtml: coverage
	@echo "Generating HTML report..."
	genhtml logs/merged.info --output-directory logs/html

gtest:
	@echo "Installing Google Test..."
	@./scripts/makegtest

clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)
	rm -rf $(BIN_DIR)
	rm -rf $(LOGS_DIR)

.PHONY: all clean create_symlinks coverage genhtml gtest runtest gtkwave include_vbuddy build_memory_files assemble create_dirs