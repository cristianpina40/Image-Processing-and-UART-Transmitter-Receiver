`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 09:44:00 PM
// Design Name: 
// Module Name: UART_R
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


module UART_R(
    input clk,
    input RxD,
    input dataWritten,
    output reg [7:0]RxD_data,
    output reg dataDone
      );
    
parameter idle = 3'b001;
parameter receiving = 3'b010;
parameter start_receive = 3'b100;
parameter clock_rate = 100000000;
parameter baud_rate = 115200;
parameter wait_period = clock_rate/baud_rate;
parameter wait_period2 = wait_period/2;
reg [13:0]counter;
reg [7:0]full_data;
reg [2:0]next_state;
reg [3:0]bit_index;
reg RxD_in;
reg int_reg;
reg done;
reg counter_done;
reg [2:0]state;


//Next state logic and FlipFlop for RxD data in to ensure stability
always@(posedge clk)begin
    state <= next_state;
    RxD_in <= RxD;
   end
   
//Once a byte of data is received, communicates with image pipeline to send and write data to RAM
   always@(posedge clk)begin
    if(done == 1'b1 && dataWritten == 1'b0) begin
    RxD_data <= full_data;
    dataDone <= 1'b1;
    end    
   else if(dataWritten == 1'b1 && done == 1'b0)begin 
    RxD_data <= RxD_data;
    dataDone <= 1'b0;
    end
   else if(dataWritten == 1'b1 && done == 1'b1)begin 
    RxD_data <= RxD_data;
    dataDone <= 1'b1;
    end
   else begin
     RxD_data <= RxD_data;
     dataDone <= 1'b0;
     end
   end

    
//Next state logic depending on RxD, counters, and data completion
always@(posedge clk)begin
    case(state)
        idle:begin
            if(RxD_in == 1'b1) next_state = idle;
            else if(RxD_in == 1'b0) next_state = start_receive;
            else next_state = idle;
            end 
        start_receive:begin
            if(counter_done == 1'b0 && RxD_in == 1'b0) next_state = start_receive;
            else if(counter_done == 1'b1 && RxD_in == 1'b0) next_state = receiving;
            else next_state = idle;
            end
        receiving:begin
            if(done != 1'b1) next_state = receiving;
            else if (done == 1'b1 && RxD_in == 1'b1) next_state = idle;
            else next_state = idle;
            end
           default next_state = idle;
        endcase
        end
 
            

//In state logic
always@(posedge clk)begin
    case(state)
    //No action in idle, all variables are set to 0
    idle: begin
            counter = 0;
            counter_done = 0;
            bit_index = 0;
            done = 0;
            end
    //waits half of a wait period to ensure data is sampled at about the midpoint of a cycle
    start_receive: begin
            if(counter < wait_period2)begin
             counter = counter +1;
             end
            else if(counter >= wait_period2)begin
               counter = 0;
               bit_index = 0;
               counter_done = 1'b1;
            end 
            else counter = counter;
           end  
     //samples data at midpoint of cycle by using a counter  
    receiving: begin
          if(counter >= wait_period && bit_index < 9)begin
            full_data[bit_index] = RxD_in; 
            bit_index = bit_index + 1;
            counter = 0;
            end
           else if(counter < wait_period && bit_index < 9) begin
            counter = counter +1; 
            counter_done = 1'b0;
           end
           else if(bit_index >= 9 && RxD_in == 1'b1)begin
            counter = 0;
            bit_index = 0;
            done = 1'b1;      
            end
           else begin
            counter = counter +1;
            bit_index = bit_index+1;
           end
          end
          default: begin
            counter = 0;
            counter_done = 0;
            bit_index = 0;
            done = 0;
            end
      endcase
      end
 
//assign RxD_data_byte = RxD_data;   

endmodule
