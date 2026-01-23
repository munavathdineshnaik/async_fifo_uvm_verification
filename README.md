# Asynchronous FIFO Verification using UVM
This project focuses on the RTL design of a parameterized asynchronous FIFO with robust CDC handling. 
A comprehensive SystemVerilog/UVM-based verification environment is included to validate the RTL design.

## Tools
- SystemVerilog
- UVM
- ModelSim / Questa / Xcelium / Verilator

## FIFO RTL DESIGN
- Dual-clock asynchronous FIFO
- Gray-code pointer synchronization
- UVM-based verification environment
- Constrained random stimulus
- Assertions for CDC correctness
- Functional coverage
- Full/empty logic based on pointer comparison
- Reset-safe design across clock domains

## Verification
- Built using UVM
- Includes: 
   - Driver for read/write operations
   - Monitor to observe FIFO behavior
   - Scoreboard for data checking
   - Assertions to catch illegal operations
   - Functional coverage for test tracking
- Directed and constrained-random testing
- SystemVerilog Assertions for safety checks
- Functional coverage for FIFO states
- Reset and CDC corner-case validation

## Test Cases
- Simple write and read test
- Random stress test with asynchronous activity



