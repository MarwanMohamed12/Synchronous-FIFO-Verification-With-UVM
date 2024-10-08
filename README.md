# Synchronous-FIFO-Verification-With-UVM

This project focuses on verifying a Synchronous FIFO design with a parameterized data width and depth using SystemVerilog and UVM. The testbench architecture includes the generation of randomized stimulus, functional coverage, and checking the design against a reference model. Key verification components include:
FIFO Design Parameters:

    FIFO_WIDTH: Data width (default: 16)
    FIFO_DEPTH: Memory depth (default: 8)

FIFO I/O Ports:

    Inputs: data_in, wr_en, rd_en, clk, rst_n
    Outputs: data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack

Testbench Flow:

    Clock & Reset Generation: The top module generates the clock and handles reset.
    Randomized Input Generation: Random input generation for wr_en, rd_en, and data_in signals.
    Monitor and Coverage:
        Monitors the interface, sampling FIFO inputs and outputs.
        Functional coverage using a cross-coverage model for FIFO states and control signals.
    Scoreboard:
        Compares the DUT outputs against a reference model for correctness.
        Tracks and reports error_count and correct_count.

Key Verification Components:

    FIFO_transaction: Models the FIFO inputs and outputs and applies randomized constraints.
    FIFO_coverage: Collects functional coverage of wr_en, rd_en, and FIFO control signals.
    FIFO_scoreboard: Implements a reference model to compare expected vs actual output.

Assertions:

    Assertions are added to validate the FIFO flags (e.g., full, empty) and ensure data integrity.
    Conditional compilation is used to include assertions in the simulation flow.

Verification Metrics:

    100% code, functional, and assertion coverage is the target.
    All verification steps are automated via a do file in QuestaSim.

Deliverables:

    Detailed bug reports and coverage results.
    SystemVerilog source files and testbench setup for simulation.
