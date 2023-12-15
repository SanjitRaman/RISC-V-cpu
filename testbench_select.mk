# Set the module or unit to run in this file.
RUN = unit
GTEST = 0
VBUDDY=1
SINGLE_INSTRUCTION_TESTS = 0

MODULE = reg_file
MODULE.INCLUDE_DIRS = -y $(RTL_DIR)/control_unit/decoders

UNIT = risc_v
UNIT.INCLUDE_DIRS = -y $(RTL_DIR)/ \
				-y $(RTL_DIR)/alu                   \
				-y $(RTL_DIR)/control_unit          \
				-y $(RTL_DIR)/control_unit/decoders \
				-y $(RTL_DIR)/data_mem              \
				-y $(RTL_DIR)/instr_mem             \
				-y $(RTL_DIR)/pc                    \
				-y $(RTL_DIR)/reg_file              \
				-y $(RTL_DIR)/sign_extend           \
				-y $(RTL_DIR)/ld_decoder			\
				-y $(RTL_DIR)/we_decoder            \
				-y $(RTL_DIR)/reg_file_d            \
				-y $(RTL_DIR)/reg_file_e            \
				-y $(RTL_DIR)/reg_file_m            \
				-y $(RTL_DIR)/reg_file_w            \
				-y $(RTL_DIR)/hazard_unit           \
				-y $(RTL_DIR)/hazard_unit/subunits  \
				-y $(RTL_DIR)/flags


NAME=""
INCLUDE_DIRS=""
SOURCES=""