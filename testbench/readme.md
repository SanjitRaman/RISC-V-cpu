# Testbenches

This folder contains unit tests for each module, as well as the top-level testbench. 

The unit tests are lightweight tests that do not simulate the whole RISC-V CPU so can be used to quickly identify errors in the DUT. The unit tests are written in SystemVerilog and use the GoogleTest framework. 

The unit tests are run in a CI-pipeline, defined in the `.github/workflows/c-cpp.yml` file. The CI-pipeline runs on a locally-hosted runner which is a remote linux-server running Ubuntu 22:04 LTS. The unit tests run on every push and pull request to `master` branch.

## Running the unit tests locally

If you would like to run the unit tests locally, you can do so by running the following command in the root directory of the project:

```make runtest GTEST=1 VBUDDY=0 RUN=module MODULE=<module_name> MODULE.INCLUDE_DIRS="-y <path_to_dir1> -y <path_to_dir2> ..."```

Where `<module_name>` refers to the name of the module, and `<path_to_dir1>` is the first dependent folder, `<path_to_dir2>` is the second dependent folder, and so on.

Note: Be sure to run `make clean` after running each test to clean up the generated files.

## Unit Test Results

### 1. Register File:
``` make runtest RUN=module GTEST=1 MODULE=reg_file MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/reg_file/readme.md).
![Alt text](/images/reg_file_test_results.png)

#### Line Coverage:
The register file unit tests hit all of the lines, except for the debug view lines, which do not affect the functionality of the module.
![Alt text](/images/reg_file_line_coverage.png)

### 2. ALU:
``` make runtest RUN=module GTEST=1 MODULE=alu MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/alu/readme.md).
![Alt text](/images/gtest-results-alu-testbench.png)

#### Line Coverage:
The ALU unit tests hit all of the lines.
![Alt text](/images/code-coverage-alu.png)

### 3. Sign Extend:

```make runtest RUN=module GTEST=1 MODULE=sign_extend MODULE.INCLUDE_DIRS=""```

Details about the tests can be found [here](/testbench/sign_extend/readme.md).

![Alt text](/images/sign_extend_test_results.png)

#### Line Coverage:

The sign extend unit tests hit all of the lines.

![Alt text](/images/sign_extend_line_coverage.png)

### 4. Data Memory Wrapper:

```make runtest RUN=module GTEST=1 MODULE=data_mem_wrapper MODULE.INCLUDE_DIRS="-y rtl/data_mem -y rtl/we_decoder -y rtl/ld_decoder"```

Details about the tests can be found [here](/testbench/data_mem_wrapper/readme.md).

![Alt text](/images/data_mem_wrapper_test_results.png)

#### Line Coverage:

Unfortunately due to a known bug, the line coverage for GoogleTests that use data memory (such as the unit test for data_mem_wrapper) available. The issue is a segmentation fault while running.
`VerilatedCov::write("logs/coverage_data_mem_wrapper.dat");`

We hope to fix this issue in the future. Pull requests are welcome!

### 5. Control Unit:

```make runtest GTEST=1 VBUDDY=0 RUN=module MODULE=control_unit MODULE.INCLUDE_DIRS="-y rtl/control_unit/decoders"```

![Alt text](/images/control_unit_test_results_excerpt.png)

#### Line Coverage:

![Alt text](/images/control_unit_line_coverage.png)