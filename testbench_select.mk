# Set the module or unit to run in this file.
RUN = unit
GTEST = 0
VBUDDY=1

MODULE = reg_file
MODULE.INCLUDE_DIRS = -y design/control_unit/decoders

UNIT = risc_v
UNIT.INCLUDE_DIRS = -y design/ \
				-y design/alu                   \
				-y design/control_unit          \
				-y design/control_unit/decoders \
				-y design/data_mem              \
				-y design/instr_mem             \
				-y design/pc                    \
				-y design/reg_file              \
				-y design/sign_extend           \
				-y design/ld_decoder			\
				-y design/we_decoder


NAME=""
INCLUDE_DIRS=""
SOURCES=""