
`timescale 1ns/1ps
`default_nettype none

module ovo7670_top_tb;

    parameter CLK_PERIOD_NS = 10;
    
    parameter ACTIVE_COLUMNS = 640;
    parameter ACTIVE_ROWS = 480;
    parameter VRAM_ADDR_WIDTH = $clog2(ACTIVE_COLUMNS*ACTIVE_ROWS);
    logic clk_i, reset_i;
    logic pixel_clk_cmos_i;
    logic vsync_cmos_i, href_cmos_i;
    logic [7:0] pixel_data_cmos_i;
    wire reset_cmos_o;
    wire power_mode_cmos_o;
    wire main_clk_cmos_o;
    wire vsync_o;
    wire hsync_o;
    wire [3:0] vga_red_o, vga_blue_o, vga_green_o;

    ovo7670_top #(
        .ACTIVE_COLUMNS(ACTIVE_COLUMNS),
        .ACTIVE_ROWS(ACTIVE_ROWS),
        .VRAM_ADDR_WIDTH(VRAM_ADDR_WIDTH)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;
    always #((CLK_PERIOD_NS/2)-1) pixel_clk_cmos_i = ~pixel_clk_cmos_i;

    initial begin
        $dumpfile("ovo7670_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        pixel_clk_cmos_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        href_cmos_i = 1;
        for (int i=0; i<50000; i++) begin
            pixel_data_cmos_i = $urandom_range(0, 255);
            repeat(1) @(negedge pixel_clk_cmos_i);
        end
        // repeat(5000000) @(negedge clk_i);
        $finish;
    end

endmodule
