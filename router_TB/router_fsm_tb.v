`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:44:18 04/08/2024
// Design Name:   router_fsm
// Module Name:   /home/deepak/Documents/3436-verilog_labs_f/Router_1x3/router_fsm/router_fsm_tb.v
// Project Name:  router_fsm
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_fsm_tb;

	// Inputs
	reg clk;
	reg rstn;
	reg pkt_vld;
	reg parity_done;
	reg fifo_full;
	reg low_pkt_vld;
	reg [1:0] d_in;
	reg sft_rst_0;
	reg sft_rst_1;
	reg sft_rst_2;
	reg fifo_empty_0;
	reg fifo_empty_1;
	reg fifo_empty_2;

	// Outputs
	wire busy;
	wire detect_addr;
	wire ld_state;
	wire laf_state;
	wire full_state;
	wire wr_en_reg;
	wire rst_int_reg;
	wire lfd_state;

	// Instantiate the Unit Under Test (UUT)
	router_fsm uut (
		.clk(clk), 
		.rstn(rstn), 
		.pkt_vld(pkt_vld), 
		.parity_done(parity_done), 
		.fifo_full(fifo_full), 
		.low_pkt_vld(low_pkt_vld), 
		.d_in(d_in), 
		.sft_rst_0(sft_rst_0), 
		.sft_rst_1(sft_rst_1), 
		.sft_rst_2(sft_rst_2), 
		.fifo_empty_0(fifo_empty_0), 
		.fifo_empty_1(fifo_empty_1), 
		.fifo_empty_2(fifo_empty_2), 
		.busy(busy), 
		.detect_addr(detect_addr), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.wr_en_reg(wr_en_reg), 
		.rst_int_reg(rst_int_reg), 
		.lfd_state(lfd_state)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstn = 0;
		pkt_vld = 0;
		parity_done = 0;
		fifo_full = 0;
		low_pkt_vld = 0;
		d_in = 0;
		sft_rst_0 = 0;
		sft_rst_1 = 0;
		sft_rst_2 = 0;
		fifo_empty_0 = 0;
		fifo_empty_1 = 0;
		fifo_empty_2 = 0;

	end
	
	initial
	   begin
		  clk = 0;
		  forever #5 clk = ~clk;
		end
		
  task reset;
     begin 
	    @(negedge clk) rstn = 1'b0;
		 @(negedge clk) rstn = 1'b1;
	  end
  endtask
  
  task t1;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b1;
     @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b0;
           pkt_vld = 1'b0;
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b0;
  end
 endtask
 
 task t2;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b0;
     @(negedge clk)
	       fifo_empty_1 = 1'b1;
			 d_in         = 2'b01;
	  @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b0;
           pkt_vld = 1'b0;
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b0;
  end
 endtask
 
 
 task t3;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b1;
     @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b1;
			  
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b0;
    
	 @(negedge clk)
         parity_done = 1'b0;
			low_pkt_vld = 1'b1;
			
	@(negedge clk) 
	@(negedge clk)
          fifo_full = 1'b0;	
  end
 endtask
 
  task t4;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b1;
     @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b1;
			  
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b0;
    
	 @(negedge clk)
         parity_done = 1'b0;
			low_pkt_vld = 1'b1;
			
	@(negedge clk) 
	@(negedge clk)
          fifo_full = 1'b0;	
  end
 endtask
 
  task t5;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b1;
     @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b1;
			  
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b0;
    
	 @(negedge clk)
         parity_done = 1'b0;
			low_pkt_vld = 1'b0;
			 
	@(negedge clk)
          fifo_full = 1'b0;
			 pkt_vld  = 1'b0;
	
   @(negedge clk)
	@(negedge clk)
	      fifo_full = 1'b0;
	
  end
 endtask
 
  task t6;
   begin
     @(negedge clk)
          pkt_vld = 1'b1;
          d_in = 2'b01;
          fifo_empty_1 = 1'b1;
     @(negedge clk)
     @(negedge clk) 
	        fifo_full= 1'b0;
           pkt_vld = 1'b0;
     @(negedge clk)
     @(negedge clk)
         fifo_full = 1'b1;
	  @(negedge clk)
	      fifo_full = 1'b0;
	  @(negedge clk)
         parity_done = 1'b1;
  end
 endtask
 
 
 
 initial
   begin
	  reset;
	  t3;
	  
	  #100 $finish;
	end
	
	

      
endmodule

