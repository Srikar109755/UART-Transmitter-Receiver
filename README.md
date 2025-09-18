# UART Communication System in SystemVerilog

A fully functional **UART Transmitter and Receiver** built in **SystemVerilog**, including:
- Baud Rate Generator
- Transmitter with Parity
- Receiver with Parity Checking
- Self-checking Testbench

> Simulated using Xilinx Vivado XSim (2024.2)

---

## Features

- ✅ Configurable **Baud Rate** & Clock Frequency  
- ✅ 8-bit data with **Even Parity** and 1 stop bit  
- ✅ Modular design: `Baud_Gen`, `UART_TX`, `UART_RX`  
- ✅ Verilog/SystemVerilog RTL & Testbench  
- ✅ Self-verifying simulation with `assert()` and `$display`  
- ✅ Clock: 10 kHz (test), Baud Rate: 1 kHz (can be changed)

---

## System Architecture

### UART Architecture Block Diagram

![UART Block Diagram](https://github.com/Srikar109755/UART-Transmitter-Receiver/blob/main/Images/Block_Diagram.png)

**Modules:**
- `Baud_Gen.sv` – Generates timing ticks at given baud rate  
- `UART_TX.sv` – Serializes data with start, parity, and stop bits  
- `UART_RX.sv` – Deserializes and checks data/parity  
- `TestBench.sv` – Stimulates and verifies the design

---

## Waveform

### UART TX & RX Simulation Waveform

![Waveform](https://github.com/Srikar109755/UART-Transmitter-Receiver/blob/main/Outputs/Waveform.png)

Signals:
- `tx_serial`, `rx_serial` shows serial line data  
- `baud_tick` controls transmission rate  
- `data_valid`, `data_out_rx` confirms correctness

---

## How to Run the Simulation

### Vivado (Recommended)

1. Open Vivado > Create Project > Add Files  
2. Add all `.sv` files to sources (except `TestBench.sv`)  
3. Add `TestBench.sv` to Simulation Sources  
4. Set `TestBench` as simulation top  
5. Run simulation (set time to 100000 ns)  
6. View console + waveform

### Terminal (Optional - if scripted)

```sh
vivado -mode tcl
# then in TCL console
launch_simulation
