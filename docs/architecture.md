# Asynchronous FIFO Architecture

## 1. Objective

The objective of this project is to design an **asynchronous FIFO** using SystemVerilog RTL.  
The FIFO allows safe data transfer between **two different clock domains** without data loss or corruption.

---

## 2. What is an Asynchronous FIFO?

An asynchronous FIFO is used when:
- Data is written using one clock
- Data is read using another clock

Since the clocks are different, special design techniques are required to avoid timing issues and metastability problems.

---

## 3. Overall Architecture

The asynchronous FIFO consists of the following main blocks:

- FIFO memory
- Write pointer logic
- Read pointer logic
- Pointer synchronization logic
- Full and empty detection logic

Each clock domain controls its own logic independently.

---

## 4. FIFO Memory

- FIFO depth is parameterized as `2^ADDR_WIDTH`
- Memory is written using the write clock (`wr_clk`)
- Memory is read using the read clock (`rd_clk`)

This allows read and write operations to happen independently.

---

## 5. Pointer Design

### 5.1 Binary Pointers

- Binary pointers are used to:
  - Address the FIFO memory
  - Track the current read and write positions
- An extra MSB bit is added to detect wrap-around conditions

---

### 5.2 Gray Code Pointers

Binary pointers are converted to **Gray code** using the formula:
gray = (bin >> 1) ^ bin

Gray code is used because:
- Only one bit changes between consecutive values
- This makes it safer to transfer pointers across clock domains

Only Gray-coded pointers are transferred between clock domains.

---

## 6. Clock Domain Crossing (CDC)

Since the FIFO uses two different clocks:
- The write pointer is synchronized into the read clock domain
- The read pointer is synchronized into the write clock domain

To safely transfer pointers:
- **Two-flip-flop synchronizers** are used
- This reduces the probability of metastability

No combinational logic crosses clock domains.

---

## 7. Full and Empty Detection

### Empty Condition

The FIFO is considered **empty** when:
- The read pointer is equal to the synchronized write pointer

This indicates that no data is available to read.

---

### Full Condition

The FIFO is considered **full** when:
- The write pointer has wrapped around and reached the read pointer

This is detected by:
- Inverting the MSB bits of the synchronized read pointer
- Comparing it with the write pointer

---

## 8. Read and Write Operations

### Write Operation

- Data is written when:
  - `wr_en` is asserted
  - FIFO is not full
- Write pointer increments after each successful write

---

### Read Operation

- Data is read when:
  - `rd_en` is asserted
  - FIFO is not empty
- Read data is registered on the read clock

---

## 9. Reset Behavior

- Asynchronous reset is used to initialize the FIFO
- Reset clears:
  - Read and write pointers
  - Synchronizer registers
  - Output data

This ensures the FIFO starts in a known state.

---

## 10. Summary

This asynchronous FIFO design:
- Safely transfers data between different clock domains
- Uses Gray code pointers for CDC safety
- Prevents overflow and underflow using full and empty logic
- Is fully parameterized and synthesizable

This project demonstrates a clear understanding of **basic RTL design and clock domain crossing concepts**.
