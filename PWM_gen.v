`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2017 10:07:49 AM
// Design Name: 
// Module Name: PWM_gen
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


//module PWM_gen(clk, value_in, pwm_out);
//        //value_in is the level of duty cycle

//    //parameter s = 0;
//    parameter max_cnt = 2050;
    
//    input clk, value_in;
//    output pwm_out; //duty_cycle_out;
    
//    wire clk;                   //clk input
//    wire [10:0] value_in;        //2^12 different level of duty_cycle
//    //reg [15:0] duty_cycle_out;    //duty cycle output
//    reg pwm_out;      //pwm wave output
    
//    reg [32:0] cycle_cnt=0;    //parameter the count the width of the paulse
    
    
//    always @ (posedge(clk)) begin
//        if (cycle_cnt >= 0 && cycle_cnt < value_in) begin
//            pwm_out <= 1;
//            cycle_cnt <= cycle_cnt + 1;
//        end
//        else if (cycle_cnt >= value_in && cycle_cnt < max_cnt - value_in) begin     
//            pwm_out <= 0;
//            cycle_cnt <= cycle_cnt + 1;
//        end
//        else if (cycle_cnt == max_cnt) begin
//            pwm_out <= 0;
//            cycle_cnt <= 0;
//        end
//        else cycle_cnt <= 0;
//    end
//endmodule


//NOT EXACTLY A PWM 
module PWM_gen( 
input clk,
input [10:0] PWM_in, 
output reg PWM_out
);

reg [10:0]new_pwm=0;
reg [10:0] PWM_ramp=0; 
always @(posedge clk) 
begin
    if (PWM_ramp==0)new_pwm<=PWM_in;
      PWM_ramp <= PWM_ramp + 1'b1;
      PWM_out<=(new_pwm>PWM_ramp);
end

endmodule