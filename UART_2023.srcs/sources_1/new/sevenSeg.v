`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 07:08:20 PM
// Design Name: 
// Module Name: sevenSeg
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


module SevenSeg(
    input clk,
    input switch1,
    input switch2, // 100 Mhz clock source on Basys 3 FPGA
    input switch3,
    input switch4,
    input switch5,
    input reset, // reset
    output anodeHigh,
    output reg [7:0] anode, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
  
  reg [4:0]state;
  reg [4:0]next_state;
  parameter idle = 4'b0000;
  parameter transmit = 4'b0001; 
  parameter receiving = 4'b0010; 
  parameter grayscale = 4'b0011; 
  parameter negative = 4'b0100; 
  parameter threshold = 4'b0101; 
  parameter brighten = 4'b0110; 
  parameter sorbel = 4'b0111;
  reg [20:0]counter;
  assign anodeHigh = 1'b1;
  
  initial begin
  counter <= 0;
  end
  always@(posedge clk)begin 
    state <= next_state;
   end
  always@(posedge clk)begin 
    if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b0 &&  switch4 == 1'b0 && switch5 == 1'b0)begin 
        next_state <= transmit;
        end 
    else if(switch1 == 1'b1 && switch2 == 1'b0 && switch3 == 1'b0 &&  switch4 == 1'b0 && switch5 == 1'b0)begin 
        next_state <= receiving;
        end 
    else if(switch1 == 1'b0 && switch2 == 1'b1 && switch3 == 1'b0 &&  switch4 == 1'b0 && switch5 == 1'b0)begin 
        next_state <= idle;
        end 
    else if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b1 &&  switch4 == 1'b0 && switch5 == 1'b0)begin 
        next_state <= grayscale;
        end 
    else if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b1 &&  switch4 == 1'b1 && switch5 == 1'b0)begin 
        next_state <= negative;
        end 
    else if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b0 &&  switch4 == 1'b0 && switch5 == 1'b1)begin 
        next_state <= sorbel;
        end 
     else if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b1 &&  switch4 == 1'b0 && switch5 == 1'b1)begin 
        next_state <= brighten;
        end
     else if(switch1 == 1'b0 && switch2 == 1'b0 && switch3 == 1'b0 &&  switch4 == 1'b1 && switch5 == 1'b1)begin 
        next_state <= threshold;
        end 
    else next_state <= idle;
  end
 
 always@(posedge clk)begin
    case(state)
        transmit: begin
            if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0100100;
                 counter <= counter + 1;
             end
             else if(counter > 10000 && counter <= 20000)begin 
                 anode <= 8'b10111111;
                 LED_out <= 7'b0110000;
                 counter <= counter + 1;
             end
             else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b0001001;
                 counter <= counter + 1;
             end
              else if(counter > 30000 && counter <= 40000)begin 
                 anode <= 8'b11101111;
                 LED_out <= 7'b0000001;
                 counter <= counter + 1;
             end
             else begin 
                 anode = 8'b01111111;
                 LED_out = 7'b0100100;
                 counter = 0;
             end
            end
     receiving: begin 
              if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0000001;
                 counter <= counter + 1;
             end
             else if(counter > 10000 && counter <= 20000)begin 
                 anode <= 8'b10111111;
                 LED_out <= 7'b1001111;
                 counter <= counter + 1;
             end
            else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b0001001;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0100100;
                 counter <= 0;
             end
            end
           grayscale: begin 
                 if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0100000;
                 counter <= counter + 1;
             end
             else if(counter > 10000 && counter <= 20000)begin 
                 anode <= 8'b10111111;
                 LED_out <= 7'b1111010;
                 counter <= counter + 1;
             end
               else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b0001000;
                 counter <= counter + 1;
             end
              else if(counter > 30000 && counter <= 40000)begin 
                 anode <= 8'b11101111;
                 LED_out <= 7'b1000100;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b1000100;
                 counter <= 0;
             end
            end
          sorbel: begin 
                 if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0100100;
                 counter <= counter + 1;
             end
               else if(counter > 10000 && counter <= 20000)begin 
                 anode <= 8'b10111111;
                 LED_out <= 7'b0000001;
                 counter <= counter + 1;
             end
              else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b1111010;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0100100;
                 counter <= 0;
             end
            end
            negative: begin 
              if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0001001;
                 counter <= counter + 1;
             end
            else if(counter > 10000 && counter <= 20000)begin
                 anode <= 8'b10111111;
                 LED_out <= 7'b0110000;
                 counter <= counter + 1;
             end
               else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b0100000;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0001001;
                 counter <= 0;
             end
            end
           threshold: begin 
               if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0111001;
                 counter <= counter + 1;
             end
             else if(counter > 10000 && counter <= 20000)begin
                 anode <= 8'b10111111;
                 LED_out <= 7'b1001000;
                 counter <= counter + 1;
             end
             else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b1111010;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b0111001;
                 counter <= 0;
             end
            end
           brighten: begin 
               if(counter <= 10000)begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b1100000;
                 counter <= counter + 1;
             end
             else if(counter > 10000 && counter <= 20000)begin
                 anode <= 8'b10111111;
                 LED_out <= 7'b1111010;
                 counter <= counter + 1;
             end
           else if(counter > 20000 && counter <= 30000)begin 
                 anode <= 8'b11011111;
                 LED_out <= 7'b0111001;
                 counter <= counter + 1;
             end
             else begin 
                 anode <= 8'b01111111;
                 LED_out <= 7'b1100000;
                 counter <= 0;
             end
            end
           idle: begin 
                 if(counter <= 10000)begin 
                 anode = 8'b01111111;
                 LED_out = 7'b1001111;
                 counter = counter + 1;
             end
              else if(counter > 10000 && counter <= 20000)begin
                 anode = 8'b10111111;
                 LED_out = 7'b0000001;
                 counter = counter + 1;
             end
              else if(counter > 20000 && counter <= 30000)begin 
                 anode = 8'b11011111;
                 LED_out = 7'b1110001;
                 counter = counter + 1;
             end
               else if(counter > 30000 && counter <= 40000)begin 
                 anode = 8'b11101111;
                 LED_out = 7'b0110000;
                 counter = counter + 1;
             end
             else begin 
                 anode = 8'b01111111;
                 LED_out = 7'b1001111;
                 counter = 0;
             end
            end
           default: begin
                    counter = 0;
           end
          endcase 
        end
            
           
          
            
 endmodule
