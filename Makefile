# Makefile

# Set the module or unit to run in this file.
include testbench_select.mk


NAME=""
INCLUDE_DIRS=""
SOURCES=""

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
CXX_FLAGS = -std=c++17

# Set Google Test library paths
GTEST_LIB_DIR = ../../googletest/build/lib
GTEST_INCLUDE_DIR = ../../googletest/googletest/include

# Set Google Test flags
ifeq ($(GTEST), 1)
	GTEST_FLAGS = -LDFLAGS "-L$(GTEST_LIB_DIR) -lgtest -lpthread" \
				  -CFLAGS "$(CXX_FLAGS)" \
				  -CFLAGS "-I$(GTEST_INCLUDE_DIR)"
else
	GTEST_FLAGS = ""
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
PROGRAM = $(PROGRAMS_DIR)/$(PROGRAM_NAME)/instr_mem.mem
DATA_MEMORY  = $(PROGRAMS_DIR)/$(PROGRAM_NAME)/data_mem.mem

# Hexfile generation
include hexfile.mk


# Set makefile targets
TARGET = $(BIN_DIR)/$(NAME)

include_vbuddy:
# Copy VBuddy files to the bin directory
ifeq ($(VBUDDY), 1)
	@echo "Including VBuddy Files..."
	@cp $(VBUDDY_DIR)/vbuddy.cpp $(BUILD_DIR)/
	@cp $(VBUDDY_DIR)/vbuddy.cfg $(BIN_DIR)/
else
	@echo "VBUDDY=0, omitting VBuddy files..."
endif

create_dirs:
	@echo "Creating build and bin directories..."
	$(shell mkdir -p $(BUILD_DIR))
	$(shell mkdir -p $(BIN_DIR))
	$(shell mkdir -p $(LOGS_DIR))

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

ifeq ($(RUN), unit)
build_memory_files: assemble
	@echo "Building memory files..."
else
	@echo "No Memory files to build, not running unit tests."
endif


# Copy instr_mem.mem from PROGRAM and data_mem.mem from DATA_MEMORY to the mem directory
#copy_memory_files:
#	@echo "Copying memory files from PROGRAM and DATA_MEMORY directories..."
#	@if [ -e $(PROGRAM)/instr_mem.mem ] && [ -e $(DATA_MEMORY)/data_mem.mem ]; then \
#		cp $(PROGRAM)/instr_mem.mem $(MEM_DIR)/; \
#		cp $(DATA_MEMORY)/data_mem.mem $(MEM_DIR)/; \
#		echo "Memory files copied successfully."; \
#	else \
#		echo "One or both of the memory files do not exist in the source directories."; \
#	fi


create_symlinks:
	@echo "Creating symlinks..."
	$(foreach file, $(wildcard $(MEM_DIR)/*), \
		ln -s $(realpath $(file)) $(BIN_DIR)/$(notdir $(file));)

# Makefile rules
all: create_dirs build_memory_files include_vbuddy create_symlinks $(TARGET)


runtest: all $(TARGET)
		 @echo "Running testbench..."
		 cd $(BIN_DIR) && ./$(patsubst $(BIN_DIR)/%,%,$(TARGET))
ifeq ($(GTEST), 1)
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

.PHONY: all clean create_symlinks coverage genhtml gtest runtest gtkwave