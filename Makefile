# Makefile
NAME = risc_v
INCLUDE_DIRS =  -y design/alu                   \
				-y design/control_unit          \
				-y design/control_unit/decoders \
				-y design/data_mem              \
				-y design/instr_mem             \
				-y design/pc                    \
				-y design/reg_file              \
				-y design/sign_extend           \


# Set the Verilator executable
VERILATOR = verilator

# Set Verilator flags
VERILATOR_FLAGS = -Wall --coverage --cc --trace
VERILATOR_COVERAGE_FLAGS = --annotate logs/annotate --annotate-all --annotate-min 1



# Set source files and include directories
SOURCES = design/$(NAME).sv

# Set testbench source and testbench executable
TB_SOURCE = testbench/$(NAME)/$(NAME)_tb.cpp
TB_EXECUTABLE = $(NAME)_tb

# Set additional flags for compiling C++ files
CXX_FLAGS = -std=c++11

# Set Google Test library paths
GTEST_LIB_DIR = ../../googletest/build/lib
GTEST_INCLUDE_DIR = ../../googletest/googletest/include

# Set Google Test flags
GTEST_FLAGS = ""
#GTEST_FLAGS = -LDFLAGS "-L$(GTEST_LIB_DIR) -lgtest -lpthread" \
			  -CFLAGS "$(CXX_FLAGS)" \
			  -CFLAGS "-I$(GTEST_INCLUDE_DIR)"

# Set makefile directories
BUILD_DIR = build/$(NAME)
BIN_DIR = bin
MEM_DIR = memory
LOGS_DIR = logs

# Set makefile targets
TARGET = $(BIN_DIR)/$(NAME)

create_dirs:
	@echo "Creating build and bin directories..."
	$(shell mkdir -p $(BUILD_DIR))
	$(shell mkdir -p $(BIN_DIR))
	$(shell mkdir -p $(LOGS_DIR))

# Makefile rules
all: create_dirs create_symlinks $(TARGET)

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


runtest: all $(TARGET)
	@echo "Running testbench..."
	cd $(BIN_DIR) && ./$(patsubst $(BIN_DIR)/%,%,$(TARGET))

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

.PHONY: all clean create_symlinks coverage genhtml gtest runtest gtkwave