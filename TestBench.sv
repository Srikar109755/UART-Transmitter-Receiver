`timescale 1ns / 1ps

module TestBench;

    logic clk, rst;
    logic baud_tick;
    logic data_ready_tx;
    logic [7:0] data_in_tx;
    logic tx_serial, rx_serial;
    logic data_valid_rx;
    logic [7:0] data_out_rx;
    logic [7:0] test_data [4:0];

    parameter CLK_FREQ = 10_000;
    parameter BAUD_RATE = 1000;
    localparam BITS_PER_FRAME = 1 + 8 + 1 + 1;


    // Baud Generator
    Baud_Gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baudgen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );


    // UART TX
    UART_TX #(
        .DATA_WIDTH(8)
    ) dut_tx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .data_ready(data_ready_tx),
        .data_in(data_in_tx),
        .tx_serial(tx_serial)
    );


    // UART RX
    UART_RX #(
        .DATA_WIDTH(8)
    ) dut_rx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx_serial(rx_serial),
        .data_valid(data_valid_rx),
        .data_out(data_out_rx)
    );

    assign rx_serial = tx_serial;

    // Clock generation (10kHz)
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end


    // Simulation startup
    initial begin
        $display("Testbench started at time %t", $time);

        rst = 1;
        data_ready_tx = 0;

        #500 rst = 0;

        test_data[0] = 8'h43; // 'C'
        test_data[1] = 8'h72; // 'r'
        test_data[2] = 8'hA5;
        test_data[3] = 8'hE7;
        test_data[4] = 8'hF4;

        for (int i = 0; i < 5; i++) begin
            @(posedge baud_tick);
            data_in_tx = test_data[i];
            data_ready_tx = 1;
            @(posedge baud_tick);                                       // hold ready high for one tick
            data_ready_tx = 0;

            // Wait for RX to receive the data
            wait(data_valid_rx == 1);
            $display("Time: %t | Received: %h | Expected: %h", $time, data_out_rx, test_data[i]);

            assert(data_out_rx == test_data[i])
                else $fatal("Mismatch! Got %h Expected %h at %t", data_out_rx, test_data[i], $time);

            // Wait full frame time before sending next
            repeat(BITS_PER_FRAME + 2) @(posedge baud_tick);
        end

        $display("All tests passed.");
        #1000 $finish;
    end

endmodule
