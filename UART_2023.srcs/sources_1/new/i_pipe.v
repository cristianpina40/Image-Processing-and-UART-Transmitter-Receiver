`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 11:10:40 AM
// Design Name: 
// Module Name: i_pipe
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


module i_pipe(
input clk,
input transmit,
input clk50M,
input Idle,
input switch1,
input switch2,
input dataDone,
input [7:0]dataReceived,
input [7:0]dataReceived2,
output reg [7:0]data,
output reg dataSent,
output reg [19:0]Address,
output reg dataFinished,
output reg dataWritten,
output reg write
    );

parameter idle_state = 3'b010;
parameter transmitting = 3'b000;
parameter receiving = 3'b001; 
//reg [7:0]imageTwo_one[0:89999];
//reg [7:0]imageTwo_two[0:89999];
//reg [18:0]i, z;
reg counter;
reg kWrite;
reg [3:0]s_counter;
reg [7:0]tempHold;
reg [19:0]i,k;
reg [2:0] state, next_state;

//Next State and state logic that depends on User input through switches
always@(posedge clk)begin
    if(switch1 == 1'b0 && switch2 == 1'b0)begin 
        next_state <= transmitting;
    end  
    else if(switch1 == 1'b1 && switch2 == 1'b0)begin 
        next_state <= receiving;
       end 
    else if(switch1 == 1'b0 && switch2 == 1'b1)begin 
        next_state <= idle_state;
       end
    else next_state <= idle_state;
   end 
  
always@(posedge clk)begin
    state <= next_state;
   end

      
    
        
//Initialize all variables
initial begin
       i = 0;
       k = 20'h0;
       //z = 19'h0;
       dataSent = 1'b0;
       dataFinished = 1'b0;
       dataWritten = 1'b0;
       counter = 1'b0;
       kWrite = 1'b0;
       s_counter = 4'b0;
       write = 1'b0;
       Address = 0;
      // Load data from "my_ram_data.hex" file
      // $readmemh("C:\\Users\\cp123\\Downloads\\output_part1.hex", imageTwo_one);
       //$readmemh("C:\\Users\\cp123\\Downloads\\output_part2.hex", imageTwo_two); // Load data from "my_ram_data.hex" file
    end    
    
             
//50Mhz clock relative to the 150Mhz clock from the RAM to ensure all data gets written
always@(posedge clk50M)begin
    case(state)
    //transmits data in RAM through UART by reading data from RAM and communicating with the UART state machine
    transmitting: begin 
    if(transmit == 1'b1 && Idle == 1'b0 && i <= 180000 && counter == 0)begin
     i <= i + 1;
     counter <= 1'b1;
     dataSent <= 1'b1;
    end 
    else if(i > 180000 && transmit == 1'b0)begin
      dataFinished <= 1'b1;
      dataSent <= 1'b0;
      data <= data;
      counter <= 0;
    end
     else if(transmit == 1'b1 && Idle == 1'b0 && i <= 180000 && counter == 1)begin
       dataSent <= 1'b1;
       counter <= 1'b1;
       end
      else if(transmit == 1'b0 && Idle == 1'b0 && i <= 180000 && (counter == 1 || counter == 0))begin
      Address <= i;
      data <= dataReceived;
      dataSent <= 1'b0;
      dataFinished <= 1'b0;
      counter <= 1'b0;
     end 
     else begin
     Address <= i;
     data <= dataReceived;
     dataSent <= 1'b0;
     dataFinished <= 1'b0;
     counter <= 1'b0;
    end
   end
   //Receives data and writes to RAM through by reading data from UART and communicating with the UART state machine
   receiving: begin 
   if(dataDone == 1'b1 && k < 180000 && kWrite == 1'b0)begin
        Address = k;
        data = dataReceived2;
        dataWritten = 1'b1;
        k = k + 1;
        write = 1'b1;
        kWrite = 1'b1;
       end 
    else if(dataDone == 1'b1 && k <= 180000 && kWrite == 1'b1)begin
        k = k;
        dataWritten = 1'b1;
        write = 1'b1;
       end
    else if(dataDone == 1'b0 && k <= 180000 && kWrite == 1'b1)begin 
        k = k; 
        dataWritten = 1'b0;
        write = 1'b0;
        kWrite = 1'b0; 
       end  
      else if(dataDone == 1'b0 && k <= 180000 && kWrite == 1'b0)begin 
        k = k; 
        dataWritten = 1'b0;
        write = 1'b0;
        kWrite = 1'b0; 
       end  
    else begin 
        k = 0; 
        dataWritten = 1'b0; 
        write = 1'b0;
        kWrite = 1'b0; 
       end 
    end
    //Sets variables to zero 
    idle_state: begin
        k = 0;
        i = 0;
        dataFinished = 1'b1;
        end
    default: begin
        k = 0;
        i = 0;
      end
  endcase 
end

endmodule
