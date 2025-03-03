`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 02:59:13 PM
// Design Name: 
// Module Name: topUART
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


module UART_top(
    input clk,
    input rst,
    input transmit,
    input switch1,
    input switch2,
    input switch3,
    input switch4,
    input DIP_button,
    //input [7:0]data,
    input RxD,
    output wire txd,
    output wire [4:0]led
    );
    
integer i;
//wire transmitting;
wire transmitting2;
wire transmittingRst;
wire txd_out;
wire dataReadyWire;
wire [7:0]dataWire; 
wire [7:0]DIP_dataWire;
//wire dataSentWire;
//wire dataFinishWire;
wire IdleWire;
wire dataReadyWire2;
wire [7:0]dataWire2; 
wire [7:0]dataRxDWire;
wire dataSentWire2;
wire dataFinishWire2;
wire IdleWire2;
wire DIP_transmit;
//reg [2:0]DIP_opWire;
wire clk_10M;
wire clk_60M;
wire clk_50M;
wire clk_150M;
wire dataDoneWire;
wire dataWrittenWire;
wire [19:0]AddressWire;
wire [19:0]rdWire;
wire writeWire;
wire [7:0]dataInWire;
wire [7:0]DIPrdWire;
wire [7:0]dataIn2Wire;
wire writeWire2;
wire enableSignal;
wire dataInRAMWire;
wire muxValue;
wire muxedWriteWire;
wire [19:0]muxedAddressWire;
wire [7:0]dataInWire2;
wire [7:0]muxedDataInWire;
//Muxed values for RAM input that depends on user inputted switches. 
//If muxValue is high data is received from DIP Unit, if muxValue is low data is received from i_pipe communicating through UART
assign muxValue = (switch3 || switch4) ? 1'b1 : 1'b0;
assign muxedWriteWire = muxValue ? writeWire2 : writeWire;
assign muxedAddressWire = muxValue ? rdWire : AddressWire;
assign muxedDataInWire = muxValue ? DIP_dataWire : dataWire2;


//IP for clock generator, multiple clocks generated and used
 clk_wiz_0 clkDiv(
    .clk_in1(clk),
    .reset(rst),
    .clk50M(clk_50M),
    .clk60M(clk_60M),
    .clk150M(clk_150M),
    .clk10M(clk_10M)
    );
    
//debouncers for various buttons, variations in transmit high time 
debounce_2 D1(
    .clk(clk),
    .btn(transmit),
    .transmit(transmitting2)
    );

debounce_2 D2(
    .clk(clk),
    .btn(rst),
    .transmit(transmittingRst)
    );

debounce_3 D3(
    .clk(clk),
    .btn(DIP_button),
    .transmit(DIP_transmit)
    );
//IP for block memory where image data is located
blk_mem_gen_0 M1(
      .clka(clk_150M),
      .addra(muxedAddressWire),
      .wea(muxedWriteWire),
      .douta(dataInWire),
      .dina(muxedDataInWire)
      );
//image pipeline, medium between RAM and UART 
i_pipe M2(
      .clk(clk),
      .clk50M(clk_50M),
      .switch1(switch1),
      .switch2(switch2),
      .transmit(dataReadyWire2),
      .data(dataWire2),
      .dataSent(dataSentWire2),
      .dataFinished(dataFinishWire2),
      .Idle(IdleWire2),
      .dataDone(dataDoneWire),
      .dataWritten(dataWrittenWire),
      .dataReceived(dataInWire),
      .dataReceived2(dataIn2Wire),
      .Address(AddressWire),
      .write(writeWire)
      );

   
//Digital image processing unit
DIP_unit DIP(
    .clk(clk),
    .clk10M(clk_10M),
    .rst(rst),
    .DIP_button(DIP_transmit),
    .switch3(switch3),
    .switch4(switch4),
    .rdData(dataInWire),
    .rd(rdWire),
    .write(writeWire2),
    .DIPdata(DIP_dataWire)
    );

//transmits data through UART commuincates with image pipeline
UART_t T1(
    .clk(clk),
    .rst(transmittingRst),
    //.transmit(transmitting),
    .transmit2(transmitting2),
    //.dataReady(dataReadyWire),
    .dataReady2(dataReadyWire2),
    //.data(dataWire),
    .data2(dataWire2),
    //.dataSent(dataSentWire),
    .dataSent2(dataSentWire2),
    //.dataFinished(dataFinishWire),
    .dataFinished2(dataFinishWire2),
   // .IdleSignal(IdleWire),
    .IdleSignal2(IdleWire2),
    .txd(txd)
    );
    
    
//Receives data through UART sends through image pipeline and writes to RAM
UART_R R1(
    .clk(clk),
    .RxD(RxD),
    .dataWritten(dataWrittenWire),
    .RxD_data(dataIn2Wire),
    .dataDone(dataDoneWire)
    );
    
//assign txd = txd_out;
assign led[0] = switch1;
assign led[1] = switch2;
assign led[2] = switch3;
assign led[3] = switch4;
assign led[4] = DIP_transmit;
/*assign led[3] = data[3];
assign led[4] = data[4];
assign led[5] = data[5];
assign led[6] = data[6];   
assign led[7] = data[7];
*/



    

endmodule
