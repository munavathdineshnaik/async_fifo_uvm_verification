# Asynchronous FIFO Verification using UVM
This project implements and verifies an asynchronous FIFO using a UVM-based
verification environment. The FIFO operates across independent read and write
clock domains and uses Gray-code pointers for safe clock-domain crossing.

## Tools
- SystemVerilog
- UVM
- ModelSim / Questa / Xcelium / Verilator

## FIFO DESIGN
- Dual-clock asynchronous FIFO
- Gray-code pointer synchronization
- UVM-based verification environment
- Constrained random stimulus
- Assertions for CDC correctness
- Functional coverage

## Verification
-Built using UVM
-Includes:
   -Driver for read/write operations
   -Monitor to observe FIFO behavior
   -Scoreboard for data checking
   -Assertions to catch illegal operations
   -Functional coverage for test tracking
   
## Test Cases
-Simple write and read test
-Random stress test with asynchronous activity



