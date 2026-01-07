# Data Memory Testbench

This directory contains the Verilog testbench for the data memory module used in the  
**RISC-V General Purpose Processor** project.

The testbench validates correct load and store operations as defined by the RV32I
instruction set.

---

## Purpose

The objective of this testbench is to verify:
- Correct byte, halfword, and word memory accesses
- Signed and unsigned load operations
- Proper address alignment and byte selection
- Functional correctness of synchronous writes and asynchronous reads

---

## Files

- `tb_datamem.v`  
  Verilog testbench for the data memory module. It exercises load and store
  instructions such as `LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, and `SW`.

---

## Features Tested

- Synchronous write operations
- Asynchronous read operations
- Byte and halfword selection using address offsets
- Sign extension and zero extension behavior
- Correct data output for aligned memory accesses

---

## Simulation Results

### Timing Waveform

The waveform below demonstrates correct memory behavior for different load and store
operations, including byte, halfword, and word accesses.



---

### Simulation Transcript

The simulation transcript confirms successful execution of the testbench with expected
data values observed during memory read and write operations.



---


iverilog -o tb tb_datamem.v datamem.v
vvp tb
