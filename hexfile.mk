# hexfile.mk

# Compile all test programs
hexfile: $(S_HEX_FILES)
	@echo "** Making .hex file for instruction memory"

$(TESTPROGRAMS)/%.hex: $(TESTPROGRAMS)/%.s
	@riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o "$?.out" "$?"
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o "$?.out.reloc" "$?.out"
	@rm "$?.out"
	@riscv64-unknown-elf-objcopy -O binary -j .text "$?.out.reloc" "$?.bin"
	@rm "$?.out.reloc"
	@./format_hex.sh "$?"
	@rm "$?.bin"

# Debugging target to print variables
debug:
	@echo "S_FILES: $(S_FILES)"
	@echo "S_HEX_FILES: $(S_HEX_FILES)"