`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 01:28:18 PM
// Design Name: 
// Module Name: UART_transmit
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


module UART_t(
    input clk,
    input rst,
    //input transmit,
    input transmit2,
    //input [7:0]data,
    input [7:0]data2,
    //input dataSent,
    input dataSent2,
    //input dataFinished,
    input dataFinished2,
    output reg txd,
    //output reg dataReady,
    output reg dataReady2,
    //output reg IdleSignal,
    output reg IdleSignal2
    );
    
parameter idle = 3'b000;
parameter transmitting = 'b010;
//parameter dataFetch = 3'b001;
parameter dataFetch2 = 3'b100;
parameter transmitting2 = 3'b011;
//Baud rate clock rate and wait period
parameter clock_rate = 100000000;
parameter baud_rate = 115200;
parameter wait_period = clock_rate/baud_rate;
parameter wait_period2 = wait_period/2;
reg [13:0]counter;
reg [8:0]full_data;
reg [2:0]state;
reg [2:0]next_state;
reg [3:0]bit_index;

initial begin
next_state = 3'b0;
dataReady2 = 1'b0;
IdleSignal2 = 1'b1;
counter = 0;
end 
//State machine logic
always@(posedge clk)begin
    if(rst) state <= idle;
    else begin
    state <= next_state;
    end
end


always@(posedge clk)begin
    case(state)
    //If idle data is not being transmitted unless transmit button is pressed
    idle: begin
          if(/*transmit == 1'b0 &&*/ transmit2 == 1'b0)begin
            full_data[0] <= 1'b1;
            next_state <= idle;
            txd <= 1'b1;
            counter <= 0;
            IdleSignal2 <= 1'b1;
            end
          /*else if(transmit == 1'b1 && transmit2 == 1'b0)begin
            next_state = dataFetch;
            IdleSignal = 1'b0;
            end*/
          else if(/*transmit == 1'b0 && */transmit2 == 1'b1)begin
            next_state <= dataFetch2;
            IdleSignal2 <= 1'b0;
            txd <= 1'b0;
            end
            else next_state <= idle;
            end
    /*dataFetch: begin
          dataReady = 1'b1;
          if(dataSent == 1'b1)begin
            full_data[7:0] = data[7:0];
            full_data[8] = 1'b1;
            txd = 1'b0;
            dataReady = 1'b0;
            next_state = transmitting;
           end
          else next_state = dataFetch;
         end */  
         
        //This stage communicates with image pipeline to receive data from RAM
        //This state occurs between every byte of data sent
        dataFetch2: begin
            dataReady2 <= 1'b1;
          if(dataSent2 == 1'b1)begin
            full_data[7:0] <= data2[7:0];
            full_data[8] <= 1'b1;
            dataReady2 <= 1'b0;
            txd <= 1'b0;
            next_state <= dataFetch2;
            counter <= 0;
           end
          else if(dataFinished2 == 1'b1)begin
            next_state <= idle;
            end
          else next_state <= dataFetch2;
         end     
    /*transmitting: begin
             if(counter >= wait_period && bit_index < 9)begin
                txd = full_data[bit_index];
                bit_index = bit_index + 1;
                next_state = transmitting;
                counter = 0;
                end
             else if(counter < wait_period && dataFinished == 1'b0) begin
                counter = counter +1; 
                next_state = transmitting;
                end
             else if(bit_index >=9 && dataFinished == 1'b1)begin
                counter = 0;
                bit_index = 0;
                next_state = idle; 
                IdleSignal = 1'b1;      
                txd = 1'b1;
                end
              else if(bit_index >= 9 && dataFinished == 1'b0)begin
                counter = 0;
                bit_index = 0;
                next_state = dataFetch;       
                txd = 1'b1;
                end
                else begin
                counter = 0;
                bit_index = 0;
                next_state = idle;
                txd = 1'b1;
                end
                end*/
        //during this stage data received from RAM is sent through UART
        transmitting2: begin
             if((counter >= wait_period) && (bit_index < 9))begin
                txd = full_data[bit_index];
                bit_index <= bit_index + 1;
                next_state <= transmitting2;
                counter <= 0;
                end
             else if((counter < wait_period) && (dataFinished2 == 1'b0) && bit_index < 9) begin
                counter <= counter + 1; 
                next_state <= transmitting2;
                end
             else if((bit_index >=9) && (dataFinished2 == 1'b1))begin
                counter <= 0;
                bit_index <= 0;
                next_state <= idle; 
                IdleSignal2 <= 1'b1;      
                txd <= 1'b1;
                end
              else if((bit_index >= 9) && (dataFinished2 == 1'b0))begin
                counter <= 0;
                bit_index <= 0;
                next_state <= dataFetch2;       
                txd <= 1'b1;
                end
                else begin
                counter <= 0;
                bit_index <= 0;
                next_state <= idle;
                txd <= 1'b1;
                end
                end
      default: next_state <= idle;
            endcase
      end
 
                
endmodule
