# 8-bit ALU — Verilog RTL Design

## Overview

This project implements an **8-bit Arithmetic Logic Unit (ALU)** in Verilog using AMD/Xilinx Vivado 2025.1.

The ALU performs eight operations selected by a 3-bit opcode:

| Opcode | Operation |
|---|---|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |
| `101` | Shift Left by 1 |
| `110` | Shift Right by 1 |
| `111` | NOT A |

The design is **purely combinational** and has no clock.

## Inputs and Outputs

### Inputs
- `A[7:0]` — 8-bit operand A
- `B[7:0]` — 8-bit operand B
- `opcode[2:0]` — operation selector

### Outputs
- `Result[7:0]` — 8-bit ALU result
- `Zero_flag` — asserted when Result is zero
- `Carry_flag` — carry/borrow-related flag
- `Overflow_flag` — signed arithmetic overflow flag

## Architecture

The ALU uses a combinational `always @(*)` block and a `case` statement to select the operation.

A 9-bit temporary register is used for arithmetic:

```verilog
reg [8:0] temp;
```

This preserves the ninth bit required to detect carry during addition and the corresponding subtraction condition.

The outputs are assigned default values at the beginning of the combinational block to avoid unintended latch inference.

## Flag Definitions

### Zero Flag
`Zero_flag = 1` when:

```text
Result = 00000000
```

### Addition Carry
For addition, `Carry_flag` is the ninth bit of the 9-bit sum.

### Subtraction Carry
For subtraction, this implementation defines:

- `Carry_flag = 1` → no borrow
- `Carry_flag = 0` → borrow

### Signed Overflow
For addition and subtraction, `Overflow_flag` detects signed two's-complement overflow.

Logical operations and shifts set `Overflow_flag = 0`.

## Verification

A self-checking Verilog testbench was developed using a reusable `check_result` task.

The testbench verifies:
- Normal addition
- Addition carry
- Addition signed overflow
- AND
- OR
- XOR
- Shift left
- Shift right
- NOT
- Normal subtraction
- Zero-result subtraction
- Subtraction borrow
- Subtraction signed overflow
- Zero + zero
- Maximum-value addition
- Zero shifts
- NOT zero

### Verification Result

**18 / 18 tests passed**

**0 failures**

## Synthesis Results

The design was synthesized in **AMD/Xilinx Vivado 2025.1**.

Post-synthesis utilization:

| Resource | Used |
|---|---:|
| Slice LUTs | 38 |
| F7 Muxes | 8 |
| Bonded IOBs | 30 |

The synthesized design contained **83 cells** and **132 nets**.

The 30 I/O count is consistent with:

```text
A       = 8
B       = 8
Opcode  = 3
Result  = 8
Zero    = 1
Carry   = 1
Overflow= 1
----------------
Total   = 30
```

## Timing

The design currently has **no user-specified timing constraints** because it is a combinational ALU without a clock.

Vivado therefore reported:

- WNS: `inf`
- TNS: `0.000 ns`
- Failing endpoints: `0`

`WNS = inf` should **not** be interpreted as infinite operating speed. It indicates that there is no constrained clock/setup requirement against which Vivado can calculate a finite slack value.

## Tools

- Verilog HDL
- AMD/Xilinx Vivado 2025.1
- XSim simulator
- Target FPGA: Xilinx Zynq-7000 (`xc7z010clg225-1L`)

## Project Structure

Recommended repository structure:

```text
8-bit-ALU/
├── rtl/
│   └── alu.v
├── tb/
│   └── alu_tb.v
├── docs/
│   ├── simulation waveform.png
│   ├── schematic.png
└── README.md
```

## Key RTL Concepts Demonstrated

- Combinational RTL
- `always @(*)`
- `case`-based operation selection
- Verilog concatenation
- Carry detection
- Signed overflow detection
- Two's-complement arithmetic
- Self-checking testbenches
- FPGA synthesis
- RTL-to-hardware mapping
- Resource utilization analysis
- Basic timing analysis
