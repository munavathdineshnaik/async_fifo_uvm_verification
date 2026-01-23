# Asynchronous FIFO – RTL Design with UVM-Based Verification

This project focuses on the RTL design of a parameterized asynchronous FIFO with robust CDC handling.
A comprehensive SystemVerilog/UVM-based verification environment is included to validate the RTL design.

## Tools
- SystemVerilog (RTL + Assertions)
- UVM (Verification)
- ModelSim / Questa / Xcelium / Verilator

## RTL FIFO Design
- Dual-clock asynchronous FIFO
- Gray-code pointer synchronization for CDC safety
- Reset-safe design across clock domains
- Full/empty detection using MSB comparison
- Synthesizable SystemVerilog RTL

## Verification 
- UVM-based verification environment
- Constrained-random read/write stimulus
- Driver, monitor, and scoreboard architecture
- SystemVerilog Assertions to catch illegal operations
- Functional coverage to track FIFO states
- Reset and CDC corner-case validation

## Test Cases
- Simple directed write/read test
- Random stress testing with asynchronous activity
