# ⚙️ ALU (Arithmetic Logic Unit) Design - Digital Systems

![Language](https://img.shields.io/badge/Language-VHDL-blue)
![Tool](https://img.shields.io/badge/Tool-Quartus%20Prime%20Lite-lightgrey)
![Category](https://img.shields.io/badge/Category-Digital%20Systems-brightgreen)
![Status](https://img.shields.io/badge/Status-Completed-success)
![FPGA](https://img.shields.io/badge/FPGA-Intel%20Altera-purple)

---

## 📄 Overview

This repository contains the development of an **Arithmetic Logic Unit (ALU)**, a fundamental digital logic circuit designed to perform a variety of arithmetic and bitwise operations. 

The system processes two 4-bit inputs (`a` and `b`) and uses a 3-bit opcode to determine the specific operation to execute. The ALU was designed at the logic gate level and structurally models operations using custom components and packages. The output includes a 4-bit result, alongside several flag indicators such as Zero, Overflow, CarryOut, and comparison states (Equal, Greater, Less).

This project was developed for the **Digital Systems Design** course in the **Computer Engineering program at Pontifical Catholic University of Campinas (PUC-Campinas)**.

---

## 🧠 What is Quartus Prime Lite?

**Quartus Prime Lite** is a free FPGA development environment provided by **Intel (formerly Altera)**.  
It is used to design, simulate, and synthesize digital circuits for FPGA devices.

### Quartus Prime allows you to:

- Design digital circuits using **schematic diagrams**
- Write hardware descriptions using **VHDL or Verilog**
- Compile and synthesize hardware logic  
- Simulate circuits using **ModelSim / QuestaSim**
- Generate FPGA configuration files (bitstreams)  
- Analyze timing, logic utilization, and hardware constraints  

---

## 🚀 Key Skills Demonstrated

The ALU project demonstrates:

- **Component Instantiation:** Utilizing structural VHDL to connect custom sub-circuits like Full Adders, 4-bit Adders, 2-bit Multipliers, and 4-bit Comparators.
- **Arithmetic Logic Design:** Implementing a ripple carry adder/subtractor and handling signed operations with overflow detection.
- **Multiplexer Integration:** Designing the core `ALUOperation` routing logic to direct the correct operational output to the final `Result` signal based on the 3-bit opcode.
- **Hardware-Software Abstraction:** Translating environmental requirements into RTL hardware models.

---

## 🛠️ Technologies & Tools

| Category | Detail |
| :--- | :--- |
| **HDL Language** | VHDL |
| **FPGA Toolchain** | Quartus Prime Lite |
| **Simulator** | ModelSim-Altera |
| **Documentation** | Markdown |
| **Logic Type** | Combinational (Gate-Level) |

---

## 💡 Concepts Covered

- **Supported Operations:**
  - `000` NOP (Result = 0000, all flags 0)
  - `001` Bitwise AND
  - `010` Bitwise OR
  - `011` Bitwise NOT (NOT b)
  - `100` Addition (a + b)
  - `101` Subtraction (a - b)
  - `110` Multiplication (2 least significant bits of `a` and `b`)
  - `111` Magnitude Comparison (Equ, Grt, Lst flags)
- **Flag Logic:** Dedicated output signals for Zero (LED on when Result is 0000), CarryOut, and Overflow.
- **VHDL Packages:** Encapsulating sub-components to keep the main top-level entity clean and organized.

---

## 🎓 Course Information

| Detail | Value |
| :--- | :--- |
| **Course** | Digital Systems Design (Projetos de Sistemas Digitais) |
| **Institution** | Pontifical Catholic University of Campinas (PUC-Campinas) |
| **Program** | Computer Engineering |
| **Semester** | 1st Semester 2026 |

---

## 🚀 How to Run the Projects

1. Install **Quartus Prime Lite** from Intel’s official website.  
2. Open the project folder in Quartus.  
3. Compile the project (`Processing > Start Compilation`).  
4. Run simulations using **ModelSim** to verify each opcode's functionality.  
5. If using an FPGA board, map the pins according to the following layout:
   - **Inputs:** `SW10` to `SW7` (Input A), `SW6` to `SW3` (Input B), `SW2` to `SW0` (ALU Opcode).
   - **7-Segment Displays:** `HEX6` (Result), `HEX4` (A), `HEX2` (B), `HEX0` (ALU Opcode).
   - **LEDs:** `LEDR0` (cout), `LEDR1` (zero), `LEDR2` (overflow), `LEDR3` (Equ), `LEDR4` (Grt), `LEDR5` (Lst).

---

## 📬 Contact Me

<div align="center"> 
  <a href="https://www.linkedin.com/in/nunes-andrade" target="_blank"><img src="https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white"></a>
  <a href="https://instagram.com/jp_nunes.andrade" target="_blank"><img src="https://img.shields.io/badge/-Instagram-%23E4405F?style=for-the-badge&logo=instagram&logoColor=white"></a>
  <a href="mailto:jpnunesandrade26@gmail.com"><img src="https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white"></a>
  <a href="https://www.alura.com.br/indica-dev/jpnunesandrade26" target="_blank"><img src="https://img.shields.io/badge/Alura-0077B5?style=for-the-badge&logo=alura&logoColor=white"></a> 
</div>
