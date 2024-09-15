`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:42:59 04/07/2024
// Design Name:   router_top_module
// Module Name:   /home/deepak/Documents/3436-verilog_labs_f/Router_1x3/router_top_module/router_topmodule_tb.v
// Project Name:  router_top_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router_top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_topmodule_tb;

	// Inputs
	reg clk;
	reg rstn;
	reg pkt_vld;
	reg rd_en_0;
	reg rd_en_1;
	reg rd_en_2;
	reg [7:0] d_in;

	// Outputs
	wire err;
	wire busy;
	wire vld_out_0;
	wire vld_out_1;
	wire vld_out_2;
	wire [7:0] d_out_0;
	wire [7:0] d_out_1;
	wire [7:0] d_out_2;

	// Instantiate the Unit Under Test (UUT)
	router_top_module uut (
		.clk(clk), 
		.rstn(rstn), 
		.pkt_vld(pkt_vld), 
		.rd_en_0(rd_en_0), 
		.rd_en_1(rd_en_1), 
		.rd_en_2(rd_en_2), 
		.d_in(d_in), 
		.err(err), 
		.busy(busy), 
		.vld_out_0(vld_out_0), 
		.vld_out_1(vld_out_1), 
		.vld_out_2(vld_out_2), 
		.d_out_0(d_out_0), 
		.d_out_1(d_out_1), 
		.d_out_2(d_out_2)
	);

	initial begin
		// Initialize Inputs

		rstn = 0;
		pkt_vld = 0;
		rd_en_0 = 0;
		rd_en_1 = 0;
		rd_en_2 = 0;
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
	
	task packet_1;
	 reg [7:0] header, payload_data, parity;
	 reg [5:0] payload_len;
	 reg [1:0] addr;
	 integer i;
	   begin
		   @(negedge clk)
		     wait(~busy)
		  @(negedge clk)
			  addr= 2'b10;
			  payload_len = 6'd14;
			  header = {payload_len,addr};
			  parity = 0;
			  d_in = header; 
			  pkt_vld = 1'b1;
			  parity = parity^header;
			  rd_en_2 = 1'b1;
			  
		 @(negedge clk)
		     wait(~busy)
			  for(i=0;i<payload_len;i=i+1)
			     begin 
				   @(negedge clk)
					    wait(~busy)
						payload_data = {$random}%256;
						d_in = payload_data;
						parity = parity^payload_data;
				  end
			 rd_en_2 = 1'b1;
		 @(negedge clk)
		     wait(~busy)
		    pkt_vld = 1'b0;
			 d_in = parity; 
		rd_en_2 = 1'b1;
	  end
  endtask

   initial
	  begin
	    reset;
		 #10;
		 packet_1;
	    
	     
		#2000 $finish; 
	 end
	 
	 initial
      	 
	   $monitor("rstn=%b, lfd_state=%b, \n vld_out=%b, rd_en=%b, d_in=%b, d_out=%b",
		          rstn,uut.lfd_state,vld_out_1,rd_en_1,d_in,d_out_1); 
      
endmodule

   


