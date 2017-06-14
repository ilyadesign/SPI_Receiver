//Created by Higuoxing@outlook.com
//Have fun :)

`timescale 1ns / 1ps
module SPI_rsvr(
    //General Usage
    input wire CLK,
    input wire RST,
    
    //Pmod Interface
    input wire SDATA,
    output reg SCLK,
    output reg nCS,
    
    //User Interface Signals
    output reg [15:0] DATA,
    input wire START,
    output reg DONE
    );

//--current_state    : exectly current state of SPI_Receiver
//--next_state       : exectly next state
//--temp             : temp data from MIC
//--clk_counter      : clk counter
//--shiftCounter     : count to 15 and set to 0
//--enShiftCounter   : to enable data shift in
//--enParalelLoad    : to enable data to load on data register

    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [15:0] temp;
    reg clk_div;
    reg [31:0] clk_counter;
    reg [3:0] shiftCounter;
    reg enShiftCounter;
    reg enParalelLoad;
    
    initial begin
        current_state <= 1;
        clk_counter <= 0;
        DATA <= 0;
    end
    
    //clk divider
    parameter max_clk_cnt = 5;
    
    always @ (posedge(CLK) or posedge(RST)) begin
        if (RST) begin
            clk_counter <= 0;
            clk_div <= 0;
            SCLK <= 0;
            //DATA <= 0;
        end
        else if (clk_counter == max_clk_cnt) begin
            clk_counter <= 0;
            SCLK <= ~ SCLK;
            clk_div <= ~ clk_div;
        end
        else clk_counter <= clk_counter + 1;
    end
    
    //data counter
    always @ (posedge(clk_div)) begin
        if (enShiftCounter == 1) begin
            temp <= {temp[14:0], SDATA};           //sdata shift in and temp shift left
            shiftCounter <= shiftCounter + 1;     //shift counter plus 1
        end
        else if (enParalelLoad) begin
            shiftCounter <= 0;
            DATA <= temp;                   //pass [11:0] effective bits to DATA
        end
    end
    
    //SYNC_PROC
    always @ (posedge(clk_div) or posedge(RST)) begin
        if (RST) begin
            current_state <= 1;    //current <= `Idle
        end
        else current_state <= next_state;
    end
    
    //state decoder
    always @ (*) begin
        if (current_state == 1) begin
            enShiftCounter <= 0;
            DONE <= 1;
            nCS <= 1;
            enParalelLoad <= 0;
        end
        else if (current_state == 2) begin
            enShiftCounter <= 1;
            DONE <= 0;
            nCS <= 0;               //when nCS is low, data could be transfered
            enParalelLoad <= 0;
        end
        else begin //SyncData
            enShiftCounter <= 0;
            DONE <= 0;
            nCS <= 1;
            enParalelLoad <= 1;
        end
    end
    
    //1: IDLE
    //2: DATA SHIFT IN
    //3: LOAD DATA
    //FSM Schematics
    //   
    //
    //
    //      IDLE ------>  DATA_SHIFT_IN ---------> LOAD_DATA
    //                          ^                     |
    //                          |_____________________|
    //
	
    always @ (*) begin  //posedge(clk_div)
        case (current_state)
            1: begin
                if (START) begin
                    next_state <= 2;
                end
                else next_state <= current_state;
            end
            2: begin
                if (shiftCounter == 15) begin
                    next_state <= 3;
                end
                else next_state <= current_state;
            end
            3: begin
                if (START == 0) begin
                    next_state <= 1;
                end
                else next_state <= 2;
            end
            default :
                next_state <= current_state;
        endcase
    end
endmodule

