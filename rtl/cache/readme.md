# Directly Mapped Write Through Cache Design Specification

## Overview

The `cache` module is a cache memory designed for a RISC-V processor. By using directly mapped write through cache, we simulate efficiency in store instructions while limiting the complexity of the design. 

## Parameters
| Parameter           | Description                           | Default |
|---------------------|---------------------------------------|---------|
| ADDRESS_WIDTH       | Width of the memory address bus.       | 17      |
| DATA_WIDTH          | Width of the data bus.                 | 32      |
| BLOCK_WIDTH         | Width of each cache block.             | 45      |
| SET_ADDRESS_WIDTH   | Width of the set address.              | 3       |
| TAG_WIDTH           | Width of the tag for cache indexing.   | 12      |

## Inputs
| Signal              | Width | Description                                              |
|---------------------|-------|----------------------------------------------------------|
| `CLK`               | 1     | The clock signal.                                        |
| `WE0`, `WE1`, `WE2`, `WE3` | 1 each | Write Enables for different byte lanes.            |
| `MemRead`           | 1     | Memory Read signal.                                     |
| `A`                 | ADDRESS_WIDTH | Memory address for read/write operations.        |
| `WD`                | DATA_WIDTH | Data to be written into the cache.                |
| `FoundData`         | DATA_WIDTH | Data found in cache during read operation.        |

## Outputs
| Signal              | Width | Description                                              |
|---------------------|-------|----------------------------------------------------------|
| `hit_o`             | 1     | Hit signal indicating a cache hit during read.           |
| `RD`                | DATA_WIDTH | Data read from the cache.                           |

## Internal Signals and Logic
| Signal                      | Width | Description                                              |
|-----------------------------|-------|----------------------------------------------------------|
| `cache_array`               | BLOCK_WIDTH x (2^SET_ADDRESS_WIDTH) | Array to store cache blocks.              |
| `hit`                       | 1     | Signal indicating a cache hit.                           |
| `A_tag`                     | TAG_WIDTH | Tag derived from the memory address.                |
| `A_set`                     | SET_ADDRESS_WIDTH | Set address derived from the memory address. |
| `valid`                     | 1     | Valid bit indicating whether data in the cache is valid.  |
| `cache_existing_data`       | DATA_WIDTH | Data present in the cache block when a hit occurs.   |

## Functionality
The `cache` module uses direct mapping to store and load data from cache while also storing data in main memory so there are no inconsistencies. In practice, this is done as the process of writing/reading from main memory is a lot slower than to/from cache. 

The module checks for cache hits based on the memory address and updates the cache accordingly featuring an asynchornous read and a `posedge` clocked write. If there is no hit, then this is picked up by the [hazard unit](/rtl/hazard_unit/) and the module computes if a stall is needed. 