include Makefile.macros

VLCOVFLAGS = --annotate logs/annotate --annotate-all --annotate-min 1

# User only needs to edit below
MODULES =  sign_extend
# UNITS = risc_v
# dependencies of unit
# UNITS.risc_v = design/sign_extend/sign_extend.sv # add more dependencies with a space
# User only needs to edit above

TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES))) $(addsuffix Test, $(addprefix bin/, $(UNITS)))
#TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES)))

# vpath for %.sv files
vpath %.sv design

all: directories $(TARGETS)

# Create dependencies using macros
# main targets
$(foreach module, $(MODULES), $(eval $(call make_bintargets,$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_bintargets,$(unit))))
# vpath for %.sv files
# dependencies
$(foreach module, $(MODULES), $(eval $(call make_mktargets,$(module),$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_mktargets,$(unit),.,$(UNITS.$(unit)))))


#
runtest: all $(TARGETS)
	@for test in $(TARGETS); do ./$$test || exit 1; done

coverage: runtest
	verilator_coverage $(VLCOVFLAGS) -write-info logs/merged.info logs/coverage1.dat logs/coverage2.dat logs/coverage3.dat

genhtml: coverage
	genhtml logs/merged.info --output-directory logs/html

gtest:
	@./scripts/makegtest

# make sure build directory is created
.PHONY: directories
#
directories: build

build:
	@mkdir -p build bin


# Misc clean targets
clean:
	@rm -fr build *.bak bin logs

realclean: clean
	@rm -fr googletest db output_files simulation
