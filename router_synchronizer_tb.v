`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:20:54 04/15/2024
// Design Name:   router_synchronizer
// Module Name:   /home/ise/verilog_labs/3436-verilog_labs_f/Router_1x3/Router_synchronizer/router_synchronizer_tb.v
// Project Name:  Router1x3_synchronizer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router_synchronizer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_synchronizer_tb;

	// Inputs
	reg detect_addr;
	reg wr_en_reg;
	reg clk;
	reg rstn;
	reg rd_en_0;
	reg rd_en_1;
	reg rd_en_2;
	reg empty_0;
	reg empty_1;
	reg empty_2;
	reg full_0;
	reg full_1;
	reg full_2;
	reg [1:0] d_in;

	// Outputs
	wire fifo_full;
	wire [2:0] wr_en;
	wire sft_rst_0;
	wire sft_rst_1;
	wire sft_rst_2;
	wire vld_out_0;
	wire vld_out_1;
	wire vld_out_2;

	// Instantiate the Unit Under Test (UUT)
	router_synchronizer uut (
		.detect_addr(detect_addr), 
		.wr_en_reg(wr_en_reg), 
		.clk(clk), 
		.rstn(rstn), 
		.rd_en_0(rd_en_0), 
		.rd_en_1(rd_en_1), 
		.rd_en_2(rd_en_2), 
		.empty_0(empty_0), 
		.empty_1(empty_1), 
		.empty_2(empty_2), 
		.full_0(full_0), 
		.full_1(full_1), 
		.full_2(full_2), 
		.d_in(d_in), 
		.fifo_full(fifo_full), 
		.wr_en(wr_en), 
		.sft_rst_0(sft_rst_0), 
		.sft_rst_1(sft_rst_1), 
		.sft_rst_2(sft_rst_2), 
		.vld_out_0(vld_out_0), 
		.vld_out_1(vld_out_1), 
		.vld_out_2(vld_out_2)
	);

	initial begin
		// Initialize Inputs
		detect_addr = 0;
		wr_en_reg = 0;
		rstn = 0;
		rd_en_0 = 0;
		rd_en_1 = 0;
		rd_en_2 = 0;
		empty_0 = 0;
		empty_1 = 0;
		empty_2 = 0;
		full_0 = 0;
		full_1 = 0;
		full_2 = 0;
		d_in = 0;

	end
	 
	initial
	  begin
	    clk = 0;
		 forever #10 clk = ~clk;
		
	  end
	  
	task reset;
	  begin
	    @(negedge clk) rstn = 1'b0;
		 @(negedge clk) rstn = 1'b1;
	  end
	endtask

	initial
	  begin
	    reset;
		  #5;
		 @(negedge clk) d_in = 2'b01;
			             detect_addr = 1'b1;
		
		@(negedge clk)  wr_en_reg = 1'b1;
		
		@(negedge clk) {full_0,full_1,full_2} = 3'b010;
		
		@(negedge clk) {empty_0,empty_1,empty_2} = 3'b101;
		
		@(negedge clk) {rd_en_0,rd_en_1,rd_en_2} = 3'b000;
		repeat(30);
		@(negedge clk) {empty_0,empty_1,empty_2} = 3'b101;
		
		#1000 $finish;
		
	 end
	 
	 
	 initial
	   $monitor("result:\n rst=%b, det_addr=%b, d_in=%b, wr_en_reg=%b, wr_en=%b, fifo_full=%d, \n\n sft_rst_0=%b, sft_rst_1=%b, sft_rst_2=%b,\n \n vld_out_0=%b, vld_out_1=%b, vld_out_2=%b",
                        rstn,detect_addr,d_in,wr_en_reg,wr_en,fifo_full,sft_rst_0,sft_rst_1,sft_rst_2,vld_out_0,vld_out_1,vld_out_2);		



      
endmodule

