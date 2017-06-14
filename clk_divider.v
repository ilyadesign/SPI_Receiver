`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2017 08:33:06 PM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_divider(clk, rst, clk_out);

    parameter max_count = 1020;

    input wire clk, rst;
    output reg clk_out;
    
    reg [63:0] cnt;
    
    initial begin
        cnt <= 0;
        clk_out <= 0;
    end
    
    always @ (posedge(clk) or posedge(rst)) begin
        if (rst) begin
            cnt <= 0;
            clk_out <= 0;
        end
        else begin           
            if (cnt == max_count) begin
                    cnt <= 0;
                    clk_out <= ~ clk_out;
                end
            else cnt <= cnt + 1;
        end
    end
    
endmodule
