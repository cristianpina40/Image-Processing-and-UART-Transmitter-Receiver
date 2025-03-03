`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 08:47:08 PM
// Design Name: 
// Module Name: debouncer_d
// Project Name: 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 02:51:35 PM
// Design Name: 
// Module Name: debouncer
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


module debounce_d(
    input clk, //input clock
    input btn, //input btn for transmit and reset
    input switch1,
    output reg transmit, // transmit signals
    output reg transmit2
    );
    
    parameter threshold = 300000;
    parameter threshold2 = 305000;
    reg button_ff1 = 0; //button for synchronization, initally set to 0
    reg button_ff2 = 0; //button for synchronization initally set to 0
    reg [19:0] count = 0; // 20 bits count for increment and decrement
    
    //first use two ff to synchronize button signa;
    
    always@(posedge clk) begin
        button_ff1 <= btn;
        button_ff2 <= button_ff1;
    end
        
    //when pish button is pressed or release we increment or decrement the counter
    
    always@(posedge clk) begin
        if(button_ff2 == 1'b1)begin
           count <= count +1;
           if(count < threshold)begin
               transmit <= 1'b0;
              transmit2 <= 1'b0;
              end
           else if(count > threshold && count < threshold2 && switch1 == 1'b0)begin
              transmit <= 1'b1;
              transmit2 <= 1'b0;
              end
           else if(count > threshold && count < threshold2 && switch1 == 1'b1)begin
              transmit <= 1'b0;
              transmit2 <= 1'b1;
              end
           else if(count >= threshold2)begin
              transmit <= 1'b0;
              transmit2 <= 1'b0;
             end
         end
         else begin
            count <= 0;
            transmit <= 1'b0;
            transmit <= 1'b0;
          end
        end
endmodule
