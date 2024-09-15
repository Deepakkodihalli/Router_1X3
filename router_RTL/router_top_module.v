`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:22 04/06/2024 
// Design Name: 
// Module Name:    router_top_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module router_top_module(
    input clk,rstn,pkt_vld,
	 input  rd_en_0,rd_en_1,rd_en_2,
	 input [7:0] d_in,
	 output err, busy,
	 output vld_out_0,vld_out_1,vld_out_2,
	 output [7:0] d_out_0, d_out_1, d_out_2
    );

 wire [2:0] fifo_empty;
 wire [2:0] wr_en;
 wire [2:0] sft_rst; 
 wire [2:0] full;
 wire [7:0] dout;
 wire [2:0] rd_en; 
 
 
 
 router_fsm fsm(.clk(clk), .rstn(rstn), .pkt_vld(pkt_vld), .busy(busy), 
	             .parity_done(parity_done), .sft_rst_0(sft_rst[0]),
				    .sft_rst_1(sft_rst[1]), .sft_rst_2(sft_rst[2]),
					 .d_in(d_in[1:0]), .fifo_full(fifo_full), .low_pkt_vld(low_pkt_vld),
					 .fifo_empty_0(fifo_empty[0]),.fifo_empty_1(fifo_empty[1]),
					 .fifo_empty_2(fifo_empty[2]), .detect_addr(detect_addr),
					 .ld_state(ld_state), .laf_state(laf_state), .full_state(full_state),
					 .wr_en_reg(wr_en_reg), .rst_int_reg(rst_int_reg), .lfd_state(lfd_state));
	                
 router_synchronizer sync(.detect_addr(detect_addr), .d_in(d_in[1:0]), .wr_en_reg(wr_en_reg), 
                          .clk(clk), .rstn(rstn), .vld_out_0(vld_out_0), .vld_out_1(vld_out_1),
								  .vld_out_2(vld_out_2), .rd_en_0(rd_en[0]),.rd_en_1(rd_en[1]),
								  .rd_en_2(rd_en[2]), .wr_en(wr_en), .fifo_full(fifo_full), 
								  .empty_0(fifo_empty[0]),.empty_1(fifo_empty[1]),.empty_2(fifo_empty[2]), 
								  .sft_rst_0(sft_rst[0]),.sft_rst_1(sft_rst[1]),.sft_rst_2(sft_rst[2]),
								   .full_0(full[0]), .full_1(full[1]),.full_2(full[2]));
								  
 router_register regs(.clk(clk), .rstn(rstn), .pkt_vld(pkt_vld), .d_in(d_in), .fifo_full(fifo_full),
                      .rst_int_reg(rst_int_reg), .detect_addr(detect_addr), .ld_state(ld_state), 
							 .laf_state(laf_state), .full_state(full_state), .lfd_state(lfd_state),
                      .parity_done(parity_done), .low_pkt_vld(low_pkt_vld), .err(err), .d_out(dout));

 							 
								  
	fifo_router fifo_0(.clk(clk), .rstn(rstn), .wr_en(wr_en[0]), .soft_rst(sft_rst[0]), .rd_en(rd_en[0]), 
                    .d_in(dout), .lfd_state(lfd_state), .empty(fifo_empty[0]), .d_out(d_out_0), .full(full[0]));
	 
	
	fifo_router fifo_1(.clk(clk), .rstn(rstn), .wr_en(wr_en[1]), .soft_rst(sft_rst[1]), .rd_en(rd_en[1]), 
                    .d_in(dout), .lfd_state(lfd_state), .empty(fifo_empty[1]), .d_out(d_out_1), .full(full[1]));
	 

   fifo_router fifo_2(.clk(clk), .rstn(rstn), .wr_en(wr_en[2]), .soft_rst(sft_rst[2]), .rd_en(rd_en[2]), 
                    .d_in(dout), .lfd_state(lfd_state), .empty(fifo_empty[2]), .d_out(d_out_2), .full(full[2]));
	 
 
 
 assign rd_en[0]= rd_en_0;
 assign rd_en[1]= rd_en_1;
 assign rd_en[2]= rd_en_2;
 


endmodule
