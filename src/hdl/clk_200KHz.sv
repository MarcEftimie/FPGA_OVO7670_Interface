`timescale 1ns / 1ps
`default_nettype none

module clk_200KHz (
    input wire clk_i,
    output logic clk_o
);

    logic [8:0] clk_count;
    initial begin
        clk_count = 0;
        clk_o = 0;
    end

    always_ff @(posedge clk_i) begin
        if (clk_count == 249) begin
            clk_o <= ~clk_o;
            clk_count <= 0;
        end else clk_count <= clk_count + 1;
    end

endmodule

