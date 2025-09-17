# Synchronous FIFO in Verilog

This project implements a parameterized synchronous FIFO (First-In First-Out) memory in Verilog, along with a comprehensive testbench covering all edge cases.

## 🔧 Features
- Parameterizable `DEPTH` and `WIDTH`
- Synchronous read and write with single clock
- Flags for `full`, `empty`
- Handles wrap-around logic correctly

## 📁 File Structure
- `sync_fifo_32x8.v` – RTL design of the FIFO
- `fifotb.v` – Testbench with tasks for:
  -The testbench is modularized with tasks, including:

tc_write() – Write test

tc_read() – Read data and check order

tc_full() – Test full condition

tc_empty() – Test empty condition

