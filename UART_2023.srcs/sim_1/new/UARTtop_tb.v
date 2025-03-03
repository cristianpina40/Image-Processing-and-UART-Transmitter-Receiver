`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 09:29:10 PM
// Design Name: 
// Module Name: UARTtop_tb
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


module UARTtop_tb();

reg clk, rst, transmit;
reg [7:0]data;
wire txd;

UART_top dut(
    .clk(clk),
    .rst(rst),
    .transmit(transmit),
    .data(data),
    .txd(txd)
    );
    
initial begin 
    clk = 0;
    rst = 0;
    end
always begin
    #5
    clk = ~clk;
    end

initial begin
   transmit = 1'b1;
   data = 8'b01010110;
   #1000000 $finish;
  end
endmodule
