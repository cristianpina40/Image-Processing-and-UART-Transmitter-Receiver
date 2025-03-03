// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Thu Nov 28 20:53:56 2024
// Host        : Cristians-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/cp123/UART_2023/UART_2023.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk50M, clk60M, clk150M, clk10M, reset, locked, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="reset,locked,clk_in1" */
/* synthesis syn_force_seq_prim="clk50M" */
/* synthesis syn_force_seq_prim="clk60M" */
/* synthesis syn_force_seq_prim="clk150M" */
/* synthesis syn_force_seq_prim="clk10M" */;
  output clk50M /* synthesis syn_isclock = 1 */;
  output clk60M /* synthesis syn_isclock = 1 */;
  output clk150M /* synthesis syn_isclock = 1 */;
  output clk10M /* synthesis syn_isclock = 1 */;
  input reset;
  output locked;
  input clk_in1;
endmodule
