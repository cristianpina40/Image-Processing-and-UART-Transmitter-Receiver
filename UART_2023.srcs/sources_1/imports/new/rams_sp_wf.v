`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 04:53:44 PM
// Design Name: 
// Module Name: imageRAM_2
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
module rams_tdp_rf_rf (clka,clkb,ena,enb,wea,web,addra,addrb,dia,dib,doa,dob);

input clka,clkb,ena,enb,wea,web;
input [19:0] addra,addrb;
input [7:0] dia,dib;
output [7:0] doa,dob;
reg [7:0] ram [0:179999];
reg [7:0] doa,dob;
initial begin
  $readmemh("C:\\Users\\cp123\\Downloads\\output.hex", ram); // Load data from "my_ram_data.hex" file
      // $readmemh("C:\\Users\\cp123\\Downloads\\output_part1.hex", imageTwo_one);
       //$readmemh("C:\\Users\\cp123\\Downloads\\output_part2.hex", imageTwo_two); // Load data from "my_ram_data.hex" file
    end    
always @(posedge clka)
begin
if (ena)
begin
if (wea)
ram[addra] <= dia;
doa <= ram[addra];
end
end

always @(posedge clkb)
begin
if (enb)
begin
if (web)
ram[addrb] <= dib;
dob <= ram[addrb];
end
end

endmodule
 



