`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 04:04:31 PM
// Design Name: 
// Module Name: debounce_3
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


module debounce_3(
    input clk, //input clock
    input btn, //input btn for transmit and reset
    output reg transmit // transmit signals
    );
    
    parameter threshold = 300000;
    parameter threshold2 = 12710000;
    reg button_ff1 = 0; //button for synchronization, initally set to 0
    reg button_ff2 = 0; //button for synchronization initally set to 0
    reg [23:0] count = 0; // 20 bits count for increment and decrement
    
    //first use two ff to synchronize button signal;
    
    always@(posedge clk) begin
        button_ff1 <= btn;
        button_ff2 <= button_ff1;
    end
        
    //when pish button is pressed or release we increment or decrement the counter
    
    always@(posedge clk) begin
        if(button_ff2 == 1'b1)begin
           count <= count +1;
           if(count < threshold)
               transmit <= 1'b0;
           else if(count > threshold && count < threshold2)
              transmit <= 1'b1;
           else if(count >= threshold2)
              transmit <= 1'b0;  
         end
         else begin
            count <= 0;
            transmit <= 1'b0;
          end
        end
endmodule
