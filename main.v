//Created by Higuoxing@outlook.com
//Have fun :)

`timescale 1ns / 1ps

module main(
    input wire CLK,
    input wire RST,
    input wire SDATA,
    output wire SCLK,
    output wire nCS,
    output wire [15:0] LED,
    input wire START,
    output wire DONE,
    output wire AUD_SD,
    output wire AUD_PWM);
    
    wire [15:0] VALUE;
    wire divided_clk;
    
    clk_divider(CLK, RST, divided_clk);
    assign AUD_SD = 1;
    assign LED = VALUE;
    PWM_gen pg_test(CLK, VALUE[12:2], AUD_PWM);
    SPI_rsvr SPI_R(CLK, RST, SDATA, SCLK,nCS, VALUE, START, DONE);

endmodule
