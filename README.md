# 6-bit Processor with Assembler

A custom 6-bit processor implemented in VHDL featuring an FSM-based control unit, instruction set extension for hardware multiplication, and a Python assembler with automatic label resolution.

## Overview

This project presents the design and implementation of a custom 6-bit processor in VHDL, developed to explore fundamental concepts of digital design and computer architecture.

The processor includes a datapath composed of registers, an ALU, program counter, instruction register, memory, multiplexers, and an FSM-based control unit. In addition to the processor implementation, a custom Python assembler was developed to automatically translate assembly programs into executable machine code.

## Highlights

- Designed and implemented a custom 6-bit processor in VHDL
- Developed an FSM-based control unit from an ASM chart
- Implemented a complete datapath including registers, ALU, PC, IR, and memory
- Added hardware support for multiplication through ISA extension
- Developed a Python assembler with automatic label resolution
- Verified processor functionality through HDL simulation

---

## Processor Architecture

The processor consists of:

- Four general-purpose registers (R0–R3)
- Arithmetic Logic Unit (ALU)
- Program Counter (PC)
- Instruction Register (IR)
- Memory
- Multiplexers
- FSM-based Control Unit

The control unit is implemented as a Finite State Machine (FSM) responsible for instruction fetch, decode, execute, and branch operations.

### Datapath

The ALU receives its operands through multiplexers and performs arithmetic operations under the control of the FSM. Processor registers are updated synchronously with the clock signal.

---

## Instruction Set Architecture

### Original Instruction Set

| Opcode | Instruction | Description |
|----------|------------|-------------|
| 00 | LOAD | Load an immediate value into a register |
| 01 | ADD | Add two register values |
| 10 | SUB | Subtract two register values |
| 11 | JNZ | Jump if a register value is not zero |

### Registers

| Register |
|----------|
| R0 |
| R1 |
| R2 |
| R3 |

---

## Development Stages

### Stage 1: Basic Processor

The processor was first implemented and verified using a simple addition program:

```assembly
LOAD R0, 7
LOAD R1, 4
ADD R0, R1
```

Result:

```text
R0 = 0B (hex) = 11 (decimal)
```

---

### Stage 2: Software Multiplication

Before adding multiplication hardware, multiplication was implemented in software using repeated addition.

Example:

```text
8 × 6 = 48
```

Result:

```text
R3 = 30 (hex) = 48 (decimal)
```

This demonstrates how functionality can be added through software without modifying processor hardware.

---

### Stage 3: Hardware Multiplication Extension

The processor was extended with a dedicated multiplication instruction.

### ISA Modifications

- Opcode width increased from 2 bits to 3 bits
- New multiplication opcode: `100`
- Existing instructions preserved through opcode expansion
- Instruction width increased from 6 bits to 7 bits

### ALU Modifications

- ALU control signal expanded from 1 bit to 2 bits
- Added multiplication operation
- Increased ALU result width to support multiplication results

### Control Unit Modifications

- Added a dedicated FSM state for multiplication
- Updated instruction decoding logic
- Integrated multiplication execution into the control flow

### Verification

Example:

```text
6 × 8 = 48
```

Result:

```text
R0 = 30 (hex) = 48 (decimal)
```

---

## Python Assembler

A custom assembler was developed in Python to convert assembly programs into machine code for the processor.

### Features

- Assembly-to-binary translation
- Register encoding
- Immediate value encoding
- Automatic label resolution
- Jump target address calculation
- Machine code generation
- End-of-program marker generation
- Case-insensitive instruction parsing

### Example

Assembly source:

```assembly
LOOP: ADD R0, R1
JNZ R0, LOOP
```

The assembler automatically calculates the address of `LOOP` and replaces the symbolic label with the correct jump target during machine code generation.

---

## Verification Summary

| Stage | Test | Result |
|---------|------|---------|
| Basic CPU | 7 + 4 | 11 |
| Software Multiplication | 8 × 6 | 48 |
| Hardware Multiplication | 6 × 8 | 48 |

These results confirm the correct functionality of both the processor architecture and the multiplication extensions.

---

## Technologies

- VHDL
- Python
- Digital Logic Design
- Computer Architecture
- Finite State Machines (FSM)
- Instruction Set Architecture (ISA)
- Hardware/Software Co-Design

---

## Skills Demonstrated

- VHDL / RTL Design
- Processor Datapath Design
- FSM-Based Control Design
- ALU Design
- Register and Memory Design
- Instruction Set Architecture (ISA)
- ISA Extension
- Hardware Multiplication
- Assembly Programming
- Assembler Design
- Label Resolution
- Computer Architecture
- Functional Verification

---

## Repository Structure

```text
6bit-processor-with-assembler/
│
├── src/
│
├── assembler/
│   └── assembler.py
│
├── assembly/
│
├── simulation/
│
└── report/
    └── report.pdf
```
