#!/bin/bash

set -euo pipefail

FILENAME=$(basename $1 .s)
DIRNAME=$(dirname $1)

od -v -An -t x1 -w4 "$1.bin" | tr -s '\n' | awk '{$1=$1};1' > "$DIRNAME/instr_mem.mem"