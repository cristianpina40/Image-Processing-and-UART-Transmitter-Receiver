`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 10:10:25 PM
// Design Name: 
// Module Name: DIP_unit
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


module DIP_unit(
    input clk,
    input clk10M,
    input rst, 
    input DIP_button,
    input switch3,
    input switch4,
    input switch5,
    input [7:0]rdData,
    output reg [7:0]DIPdata,
    output reg [17:0]rd,
    output reg write
 );
 
 reg signed[15:0]R;
 reg signed[15:0]G;
 reg signed[15:0]B;
 reg signed[7:0]R1;
 reg signed[7:0]G1;
 reg signed[7:0]B1;
 reg signed[7:0]R2;
 reg signed[7:0]G2;
 reg signed[7:0]B2;
 reg signed[7:0]R3;
 reg signed[7:0]G3;
 reg signed[7:0]B3;
 reg signed[7:0]R4;
 reg signed[7:0]G4;
 reg signed[7:0]B4;
 reg signed[7:0]R5;
 reg signed[7:0]G5;
 reg signed[7:0]B5;
 reg signed[7:0]R6;
 reg signed[7:0]G6;
 reg signed[7:0]B6;
 reg signed[7:0]R7;
 reg signed[7:0]G7;
 reg signed[7:0]B7;
 reg signed[7:0]R8;
 reg signed[7:0]G8;
 reg signed[7:0]B8;
 reg [7:0]init;
 reg signed [19:0]j;
 reg signed [19:0]z;
 reg [15:0]tempHold;
 reg signed[1:0]tempHold1;
 reg signed[1:0]tempHold2;
 reg [7:0]tempHold3;
 reg signed[7:0]tempHold4;
 reg signed[7:0]tempHold5;

 reg [5:0]s_counter;
 parameter idle = 3'b000; 
 parameter grayScale = 3'b001;
 parameter negative = 3'b010;
 parameter sobels = 3'b011;
 parameter brighten = 3'b100;
 parameter threshold = 3'b101;
 reg [2:0]state, next_state;
 reg stop;
 
 //Initialize all variables
 initial begin
    R <= 0;
    G <= 0; 
    B  <= 0;
    init <= 0;
    tempHold <= 0;
    j <= 0;
    stop <= 0;
   end
 //State and Next State Logic that depends on user input through switches
 always@(posedge clk)begin
    if(rst) state <= idle;
    else state <= next_state;
    end
    

always@(posedge clk)begin
    if(switch3 == 1'b0 && switch4 == 1'b0 && switch5 == 1'b0)begin
        next_state <= idle;
    end
    else if(switch3 == 1'b1 && switch4 == 1'b0 && switch5 == 1'b0)begin
        next_state <= grayScale;
    end
    else if(switch3 == 1'b1 && switch4 == 1'b1 && switch5 <= 1'b0)begin
        next_state <= negative;
       end
    else if(switch3 == 1'b0 && switch4 == 1'b0 && switch5 == 1'b1)begin
        next_state <= sobels;
        end
    else if(switch3 == 1'b1 && switch4 == 1'b0 && switch5 == 1'b1)begin 
        next_state <= brighten;
        end
    else if(switch3 == 1'b0 && switch4 == 1'b1 && switch5 == 1'b1)begin 
        next_state <= threshold;
        end
    else next_state <= idle;
   end
    
//Slow clocked DIP algorithms to ensure all data has enough time to be completed given a set of combinational delays
always@(posedge clk10M)begin
    z <= j;
    case(state)
        idle: begin
              s_counter <= 0;
              j <= 0;
              init <= 0;
              stop <= 1'b0;
              end
        grayScale:begin 
                //Takes the data individually from the RAM one byte at a time
                if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 0 && stop == 1'b0)begin  
                 write = 1'b0;
                 rd = j; 
                 R = rdData;
                 init = init + 1;
                 j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 1 && stop == 1'b0)begin    
                rd = j; 
                G = rdData;
                init = init + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 2 && stop == 1'b0)begin    
                rd = j; 
                B = rdData;
                init = init + 1;
                j = j + 1;
                end
                //GrayScales the image 
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 3 && stop == 1'b0)begin    
                tempHold = (R*8'd77 + G*8'd150 + B*8'd29);
                s_counter =s_counter + 1;
                j = j - 3;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 1 && init == 3 && stop == 1'b0)begin    
                write = 1'b1;
                rd = j;
                DIPdata = tempHold[15:8];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 2 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = tempHold[15:8];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 3 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = tempHold[15:8];
                s_counter = 0;
                init = 0;
                j = j + 1;
                end
                //Exits once data is completed
                else if(j >= 180000)begin
                stop <= 1'b1;
                write = 1'b0;
                end
                else begin 
                s_counter <= 0;
                init <= 0;
                j <= 0;
                stop <= 1'b0;
                end
                end
            negative:begin 
                //Takes the data individually from the RAM one byte at a time
                if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 0 && stop == 1'b0)begin  
                 write = 1'b0;
                 rd = j; 
                 R = rdData;
                 init = init + 1;
                 j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 1 && stop == 1'b0)begin    
                rd = j; 
                G = rdData;
                init = init + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 2 && stop == 1'b0)begin    
                rd = j; 
                B = rdData;
                init = init + 1;
                j = j + 1;
                end
                //GrayScales the image 
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 3 && stop == 1'b0)begin    
                R = 8'd255 - R;
                G = 8'd255 - G;
                B = 8'd255 - B;
                s_counter = s_counter + 1;
                j = j - 3;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 1 && init == 3 && stop == 1'b0)begin    
                write = 1'b1;
                rd = j;
                DIPdata = R;
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 2 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = G;
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 3 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = B;
                s_counter = 0;
                init = 0;
                j = j + 1;
                end
                //Exits once data is completed
                else if(j >= 180000 && (DIP_button == 1'b1 || DIP_button == 1'b0))begin
                stop <= 1'b1;
                write <= 1'b0;
                end
                else begin 
                s_counter <= 0;
                init <= 0;
                j <= 0;
                stop <= 1'b0;
                end
                end
             threshold:begin 
                //Takes the data individually from the RAM one byte at a time
                if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 0 && stop == 1'b0)begin  
                 write = 1'b0;
                 rd = j; 
                 R = rdData;
                 init = init + 1;
                 j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 1 && stop == 1'b0)begin    
                rd = j; 
                G = rdData;
                init = init + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 2 && stop == 1'b0)begin    
                rd = j; 
                B = rdData;
                init = init + 1;
                j = j + 1;
                end
                //GrayScales the image 
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 3 && stop == 1'b0)begin    
                if(R[7:0] > 127) R[7:0] = 255;
                else R[7:0] = 0;
                if(B[7:0] > 127) B[7:0] = 255;
                else B[7:0] = 0;
                if(G[7:0] > 127) G[7:0] = 255;
                else G[7:0] = 0;
                s_counter = s_counter + 1;
                j = j - 3;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 1 && init == 3 && stop == 1'b0)begin    
                write = 1'b1;
                rd = j;
                DIPdata = R[7:0];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 2 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = G[7:0];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 3 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = B[7:0];
                s_counter = 0;
                init = 0;
                j = j + 1;
                end
                //Exits once data is completed
                else if(j >= 180000 && (DIP_button == 1'b1 || DIP_button == 1'b0))begin
                stop <= 1'b1;
                write <= 1'b0;
                end
                else begin 
                s_counter <= 0;
                init <= 0;
                j <= 0;
                stop <= 1'b0;
                end
                end
              brighten:begin 
                //Takes the data individually from the RAM one byte at a time
                if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 0 && stop == 1'b0)begin  
                 write = 1'b0;
                 rd = j; 
                 R[7:0] = rdData;
                 init = init + 1;
                 j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 1 && stop == 1'b0)begin    
                rd = j; 
                G[7:0] = rdData;
                init = init + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 2 && stop == 1'b0)begin    
                rd = j; 
                B[7:0] = rdData;
                init = init + 1;
                j = j + 1;
                end
                //Brightens the image 
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 3 && stop == 1'b0)begin    
                R1 = 8'd255 - R[7:0];
                G1 = 8'd255 - G[7:0];
                B1 = 8'd255 - B[7:0];
                s_counter = s_counter + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 1 && init == 3 && stop == 1'b0)begin    
                R2 = 8'd10*R1;
                G2 = 8'd10*G1;
                B2 = 8'd10*B1;
                s_counter = s_counter + 1;
                end
               else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 2 && init == 3 && stop == 1'b0)begin    
                R3 = R2/8'd255;
                G3 = G2/8'd255;
                B3 = B2/8'd255;
                s_counter = s_counter + 1;             
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 3 && init == 3 && stop == 1'b0)begin    
                R = R3 + R;
                G = G3 + G;
                B = B3 + B;
                s_counter = s_counter + 1;
                end
               else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 4 && init == 3 && stop == 1'b0)begin    
                if(R > 8'd255) R = 8'd255;
                if(B > 8'd255) B = 8'd255;
                if(G > 8'd255) G = 8'd255;
                s_counter = s_counter + 1;
                j = j - 3;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 5 && init == 3 && stop == 1'b0)begin    
                write = 1'b1;
                rd = j;
                DIPdata = R[7:0];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 6 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = G[7:0];
                s_counter = s_counter + 1;
                j = j + 1;
                end
                else if(DIP_button == 1'b1 && j <= 180000 && s_counter == 7 && init == 3 && stop == 1'b0)begin 
                write = 1'b1;
                rd = j;
                DIPdata = B[7:0];
                s_counter = 0;
                init = 0;
                j = j + 1;
                end
                //Exits once data is completed
                else if(j >= 180000 && (DIP_button == 1'b1 || DIP_button == 1'b0))begin
                stop <= 1'b1;
                write <= 1'b0;
                end
                else begin 
                s_counter <= 0;
                init <= 0;
                j <= 0;
                stop <= 1'b0;
                end
                end
             sobels: begin
                 if(DIP_button == 1'b1 && j <= 180000 && s_counter == 0 && init == 0 && stop == 1'b0 )begin 
                 init = init + 1; 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 1 && stop == 1'b0)begin  
                 write = 1'b0;
                 rd = z; 
                 R = rdData;
                 init = init + 1;
                 j = j + 3;//First neighbor on the right for Red 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 2 && stop == 1'b0)begin 
                 rd = z; 
                 R1 = rdData;
                 init = init + 1;
                 j = j + 894; //Neighbor on the bottom left 
                 end
                 else if( j <= 180000 && s_counter == 0 && init == 3 && stop == 1'b0)begin 
                 rd = z; 
                 R2 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 4 && stop == 1'b0)begin  
                 rd = z; 
                 R3 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom right
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 5 && stop == 1'b0)begin  
                 rd = z; 
                 R4 = rdData;
                 init = init + 1;
                 j = j - 906; //Neighbor behind
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 6 && stop == 1'b0)begin  
                 
                 if(z >= 0)begin
                 rd = z; 
                 R5 = rdData;
                 init = init + 1;
                 end
                 else begin
                 R5 = 0;
                 init = init + 1;
                 end 
                 j = j - 894 ; //top right 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 7 && stop == 1'b0)begin 
                 
                 if(z >= 0)begin
                 rd = z; 
                 R6 = rdData;
                 init = init + 1;
                 end   
                 else begin 
                 R6 = 0; 
                 init = init + 1;
                 end
                  j = j - 3 ; //top
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 8 && stop == 1'b0)begin  
                 if (z >=0)begin 
                 rd = z; 
                 R7 = rdData;
                 init = init + 1; 
                 end 
                 else begin 
                 R7 = 0;
                 init = init + 1;
                 end
                  j = j - 3 ; //top left
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 9 && stop == 1'b0)begin 
                 if(z >= 0)begin
                 rd = z; 
                 R8 = rdData;
                 init = init + 1;
                 end
                 else begin
                 R8 = 0;
                 init = init + 1;
                 end
                 j = j + 904; //Move to G channel
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 10 && stop == 1'b0)begin  
                 rd = z; 
                 G = rdData;
                 init = init + 1;
                 j = j + 3;//First neighbor on the right for green
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 11 && stop == 1'b0)begin  
                 rd = z; 
                 G1 = rdData;
                 init = init + 1;
                 j = j + 894; //Neighbor on the bottom left
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 12 && stop == 1'b0)begin
                 rd = z; 
                 G2 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 13 && stop == 1'b0)begin  
                 rd = z; 
                 G3 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom right
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 14 && stop == 1'b0)begin
                 rd = z; 
                 G4 = rdData;
                 init = init + 1;
                 j = j - 906; //Neighbor behind 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 15 && stop == 1'b0)begin  
                 j = j - 894 ; //top right
                 if(z >= 0)begin
                 rd = z; 
                 G5 = rdData;
                 init = init + 1;
                
                 end    
                 else begin 
                 G5 = 0; 
                 init = init + 1; 
                
                 end
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 16 && stop == 1'b0)begin  
                 
                 if(z >= 0)begin
                 rd = z; 
                 G6 = rdData;
                 init = init + 1;
                 end
                 else begin 
                 G6 = 0;    
                 init = init - 1;
                 end
                 j = j - 3 ; //top 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 17 && stop == 1'b0)begin  
                 if(z >= 0)begin
                 rd = z; 
                 G7 = rdData;
                 init = init + 1;
                 end
                 else begin 
                 G7 = 0; 
                 init = init + 1; 
                 end
                 j = j - 3 ; //top left
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 18 && stop == 1'b0)begin  
                
                 if(z >= 0)begin
                 rd = z; 
                 G8 = rdData;
                 init = init + 1;
                 end
                 else begin 
                 G8 = 0;
                 init = init + 1; 
                 end 
                 j = j + 904 ; //Move to B channel
                 end
                 if(j <= 180000 && s_counter == 0 && init == 19 && stop == 1'b0)begin  
                 rd = z; 
                 B = rdData;
                 init = init + 1;
                 j = j + 3;//First neighbor on the right for Red 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 20 && stop == 1'b0)begin
                 rd = z; 
                 B1 = rdData;
                 init = init + 1;
                 j = j + 894; //Neighbor on the bottom left
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 21 && stop == 1'b0)begin  
                 
                 rd = z; 
                 B2 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 22 && stop == 1'b0)begin 
                
                 rd = z; 
                 B3 = rdData;
                 init = init + 1;
                 j = j + 3; //Neighbor on the bottom right
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 23 && stop == 1'b0)begin  
                 rd = z; 
                 B4 = rdData;
                 init = init + 1;
                 j = j - 906; //Neighbor behind
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 24 && stop == 1'b0)begin  
                 
                 if(z >= 0)begin 
                 rd = z; 
                 B5 = rdData;
                 init = init + 1;
                
                 end 
                 else begin 
                 B5 = 0; 
                 init = init + 1; 
                 end
                  j = j - 894 ; //top right
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 25 && stop == 1'b0)begin  
                 
                 if(z >= 0) begin 
                 rd = z; 
                 B6 = rdData;
                 init = init + 1;
                 end 
                 else begin 
                 B6 = 0; 
                 init = init + 1;
                 end
                 j = j - 3 ; //top 
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 26 && stop == 1'b0)begin 
                 j <= j - 3 ; //top left  
                 if(z >= 0) begin
                 rd = z; 
                 B7 = rdData;
                 init = init + 1;
                 end
                 else begin 
                 B7 = 0;
                 init = init + 1;
                 end
                 j = j - 3 ; //top left  
                 end
                 else if(j <= 180000 && s_counter == 0 && init == 27 && stop == 1'b0)begin  
                 if(z >= 0)begin 
                 rd = z; 
                 B8 = rdData;
                 init = 0;
                 s_counter = s_counter + 1;
                 end
                 else begin 
                 B8 = 0;   
                 init = 0;
                 s_counter = s_counter + 1;
                 end
                 j = j + 901 ; //first location
                 end
                 else if(j <= 180000 && s_counter == 1 && init == 0 && stop == 1'b0)begin 
                 R8 = ~R8 + 1'b1;
                 R5 = (~R5+1'b1)<<1;
                 R1 = R1<<1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 2 && init == 0 && stop == 1'b0)begin  
                 tempHold1 =  (R8 + R6) + (R5 +R1) + (R2 + R4); //Gx
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 3 && init == 0 && stop == 1'b0)begin  
                 R8 = ~R8+1'b1;
                 R7 = (~R7 + 1'b1) << 1;
                 R6 = ~R6+1'b1;
                 R3 = R3 << 1;
                 if(tempHold1 < 0) tempHold1 = ~tempHold1 + 1'b1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 4 && init == 0 && stop == 1'b0)begin 
                 tempHold2 = (R8 + R7) + (R6 + R2) + (R3 + R4); //Gy
                 if(tempHold2 < 0) tempHold2 = ~tempHold2 + 1'b1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 5 && init == 0 && stop == 1'b0)begin 
                 tempHold3 = tempHold1 + tempHold2;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 6 && init == 0 && stop == 1'b0)begin
                 rd = j;
                 write = 1'b1;
                 DIPdata = tempHold3[7:0];  
                 s_counter = s_counter + 1;   
                 end
                 else if(j <= 180000 && s_counter == 7 && init == 0 && stop == 1'b0)begin 
                 write = 1'b0;
                 G8 = ~G8 + 1'b1;
                 G5 = (~G5+1'b1) << 1;
                 G1 = G1 << 1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 8 && init == 0 && stop == 1'b0)begin 
                 tempHold1 = (G8 + G6) + (G5 + G1) + (G2 + G4); //Gx
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 9 && init == 0 && stop == 1'b0)begin  
                 G8 = -G8;
                 G7 = -(G7 << 1);
                 G6 = -G6;
                 G3 = G3 << 1;
                 if(tempHold1 < 0) tempHold1 = ~tempHold1 + 1'b1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 10 && init == 0 && stop == 1'b0)begin
                 tempHold2 = (G8 + G7) + (G6 + G2) + (G3 + G4); //Gy
                 if(tempHold2 < 0) tempHold2 = ~tempHold2 + 1'b1;
                 s_counter = s_counter + 1;
                 end 
                 else if(j <= 180000 && s_counter == 11 && init == 0 && stop == 1'b0)begin
                 tempHold3 = tempHold1 + tempHold2;
                 j = j + 1;
                 s_counter = s_counter + 1;
                 end 
                 else if(j <= 180000 && s_counter == 12 && init == 0 && stop == 1'b0)begin  
                 rd = j;
                 write = 1'b1;
                 DIPdata = tempHold3[7:0];
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 13 && init == 0 && stop == 1'b0)begin 
                 write = 1'b0;
                 B8 = ~B8 + 1'b1;
                 B5 = (~B5+1'b1) << 1;
                 B1 = B1 << 1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 14 && init == 0 && stop == 1'b0)begin  
                 tempHold1 =  (B8 + B6) + (B5 +B1) + (B2 + B4); //Gx
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 15 && init == 0 && stop == 1'b0)begin  
                 B8 = ~B8 + 1'b1;
                 B7 = (~B7+1'b1) << 1;
                 B6 = ~B6 + 1'b1;
                 B3 = B3 << 1;
                 if(tempHold1 < 0) tempHold1 = ~tempHold1+1'b1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 16 && init == 0 && stop == 1'b0)begin  
                 tempHold2 = (B8 + B7) + (B6 + B2) + (B3 + B4); //Gy
                 if(tempHold2 < 0) tempHold2 = ~tempHold2 + 1'b1;
                 s_counter = s_counter + 1;
                 end
                 else if(j <= 180000 && s_counter == 17 && init == 0 && stop == 1'b0)begin 
                 tempHold3 = tempHold1 + tempHold2;
                 s_counter = s_counter + 1;
                 j = j + 1;
                 end
                 else if(j <= 180000 && s_counter == 18 && init == 0 && stop == 1'b0)begin  
                 rd = j;
                 write = 1'b1;
                 DIPdata = tempHold3[7:0];
                 s_counter = 0;
                 init = init + 1;
                 j = j + 1;
                 end
                 else if(j >= 180000)begin
                 stop = 1'b1;
                 write = 1'b0;
                 end
                 else begin 
                 j <= 0;
                 s_counter <= 0;
                 init <= 0;
                 stop <= 1'b0;
                 end
                end
                 
              default: begin 
              s_counter <= 0;
              init <= 0;
              j <= 0; 
              end
          endcase
   end
    
    
    
    
endmodule
