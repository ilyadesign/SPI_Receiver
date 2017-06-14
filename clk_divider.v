//Created by Higuoxing@outlook.com
//Have fun :)

`timescale 1ns / 1ps

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
