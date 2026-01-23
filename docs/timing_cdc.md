# Timing and Clock Domain Crossing (CDC)

## 1. Introduction

In this project, the FIFO operates with **two different clocks**:
- Write clock (`wr_clk`)
- Read clock (`rd_clk`)

Since these clocks are independent, special care is required to avoid timing errors and data corruption.

---

## 2. Why CDC is a Problem

When signals move from one clock domain to another:
- Setup and hold times may be violated
- Metastability can occur
- Multi-bit signals can be sampled incorrectly

Because of this, normal flip-flops cannot be used directly for CDC signals.

---

## 3. CDC Solution Used in This Design

To handle CDC safely, the following techniques are used:

### 3.1 Gray Code Pointers
- Read and write pointers are converted to **Gray code**
- Gray code changes only one bit at a time
- This reduces the risk of incorrect sampling across clock domains

Only Gray-coded pointers are transferred between clock domains.

---

### 3.2 Two-Flip-Flop Synchronizers

- Each Gray-coded pointer is passed through **two flip-flops**
- These flip-flops are clocked by the destination clock
- This greatly reduces the chance of metastability

Each clock domain has its own synchronizer.

---

## 4. Timing Safety Rules Followed

- No combinational logic crosses clock domains
- Binary pointers are never synchronized
- Status signals (`full` and `empty`) are generated locally
- Memory access is controlled only by local clocks

---

## 5. Reset and Timing

- Asynchronous reset is used to initialize all registers
- Reset clears pointers and synchronizer registers
- This ensures a known safe state at startup

---

## 6. Summary

This design follows basic CDC and timing rules by:
- Using Gray code for pointer transfer
- Using two-flip-flop synchronizers
- Avoiding unsafe cross-clock logic

These techniques make the FIFO safe and reliable for asynchronous operation.
