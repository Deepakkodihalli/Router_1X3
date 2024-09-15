`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:23:46 03/28/2024
// Design Name:   fifo_router1x3
// Module Name:   /home/deepak/Documents/3436-verilog_labs_f/prjt_router1x3/fifo_router1x3_tb.v
// Project Name:  prjt_router1x3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fifo_router1x3
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_fifo_tb;

	// Inputs
	reg clk;
	reg rstn;
	reg wr_en;
	reg rd_en;
	reg soft_rst;
	reg lfd_state;
	reg [7:0] d_in;

	// Outputs
	wire empty;
	wire full;
	wire [7:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	fifo_router uut (
		.clk(clk), 
		.rstn(rstn), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.soft_rst(soft_rst), 
		.lfd_state(lfd_state), 
		.d_in(d_in), 
		.empty(empty), 
		.full(full), 
		.d_out(d_out)
	);

	initial begin
		// Initialize Inputs
		rstn = 0;
		wr_en = 0;
		rd_en = 0;
		soft_rst = 0;
		lfd_state = 0;
		d_in = 0;

	end
  initial
     begin
	    clk=0;
		 forever #10 clk = ~clk;
	  end
  
  task reset;
    begin
	   @(negedge clk) rstn = 1'b0;
		@(negedge clk) rstn = 1'b1;
	 end
  endtask
  
  task write;
    reg [7:0] payload_data,header,parity;
	 reg [5:0] payload_len;
	 reg [1:0] addr;
	 integer k;
	    begin
		    @(negedge clk)
			     wr_en = 1'b1;
			     addr = 2'b10;
				  payload_len = 6'd14;
				  header = {payload_len,addr};
				  lfd_state = 1'b1;
				  d_in = header;
				  
			 for(k=0;k<payload_len;k=k+1)
				 begin
					@(negedge clk)
						lfd_state = 1'b0;
						 payload_data = {$random}%256;
						 d_in = payload_data;
				 end
			 @(negedge clk)
			  begin
     			 parity = {$random}%256;
			    d_in = parity;
		     end
			  
		end
  endtask
  
  task read;
   begin
    @(negedge clk) rd_en=1'b1;
	end
  endtask
  
  initial
    begin
	   reset;
		write;
		#10;
		read;
	 end
	
	initial
	  begin
	 $monitor("result: reset=%b,wr_en=%b, rd_en=%b, soft_rst=%b,input=%b,lfd=%b,empty=%b,full=%b,d_out=%b",rstn,wr_en,rd_en,soft_rst,d_in,lfd_state,empty,full,d_out);
        	  
        #1000 $finish;  
	  end
endmodule 

