`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:21:09 04/05/2024
// Design Name:   router_register
// Module Name:   /home/deepak/Documents/3436-verilog_labs_f/Router_1x3/router_register/router_register_tb.v
// Project Name:  router_register
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router_register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_register_tb;

	// Inputs
	reg clk;
	reg rstn;
	reg pkt_vld;
	reg fifo_full;
	reg rst_int_reg;
	reg detect_addr;
	reg ld_state;
	reg laf_state;
	reg full_state;
	reg lfd_state;
	reg [7:0] d_in;

	// Outputs
	wire parity_done;
	wire low_pkt_vld;
	wire err;
	wire [7:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	router_register uut (
		.clk(clk), 
		.rstn(rstn), 
		.pkt_vld(pkt_vld), 
		.fifo_full(fifo_full), 
		.rst_int_reg(rst_int_reg), 
		.detect_addr(detect_addr), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.lfd_state(lfd_state), 
		.d_in(d_in), 
		.parity_done(parity_done), 
		.low_pkt_vld(low_pkt_vld), 
		.err(err), 
		.d_out(d_out)
	);

	initial begin
		// Initialize Inputs
		
		rstn = 0;
		pkt_vld = 0;
		fifo_full = 0;
		rst_int_reg = 0;
		detect_addr = 0;
		ld_state = 0;
		laf_state = 0;
		full_state = 0;
		lfd_state = 0;
		d_in = 0;
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
	  
  task packet_generation_1;
     reg [7:0] payload_data, parity, header;
     reg [5:0]payload_len;
     reg [1:0] addr;
	  integer i;
     begin
       @(negedge clk)
           payload_len = 6'd14; 
			  addr=2'b10;
           pkt_vld = 1'b1;
			  detect_addr = 1'b1;
           header =  {payload_len,addr};
			  parity = 8'b0^header;
			  d_in = header;
		  
      @(negedge clk)
		    lfd_state=1'b1;
          detect_addr = 1'b0; 
          full_state=1'b0;
          fifo_full=1'b0; 
			 laf_state = 1'b0;
              for(i=0;i<payload_len;i=i+1)
                  begin
                    @(negedge clk)
                       lfd_state = 1'b0;
							  ld_state=1'b1;
                       payload_data={$random}%256; 
							  d_in = payload_data;
                       parity = parity^d_in;
                  end
     @(negedge clk)
         pkt_vld = 1'b0;
			d_in = parity;
     @ (negedge clk)
         ld_state =0;
  end
endtask

 task packet_generation_2;
     reg [7:0] payload_data, parity, header;
     reg [5:0]payload_len;
     reg [1:0] addr;
	  integer i;
     begin
       @(negedge clk)
           payload_len = 6'd14; 
			  addr=2'b01;
           pkt_vld = 1'b1;
			  detect_addr = 1'b1;
           header =  {payload_len,addr};
			  parity = 8'b0^header;
			  d_in = header;
		  
      @(negedge clk)
		    lfd_state=1'b1;
          detect_addr = 1'b0; 
          full_state=1'b0;
          fifo_full=1'b0; 
			 laf_state = 1'b0;
              for(i=0;i<payload_len;i=i+1)
                  begin
                    @(negedge clk)
                       lfd_state = 1'b0;
							  ld_state=1'b1;
                       payload_data={$random}%256; 
							  d_in = payload_data;
                       parity = parity^d_in;
                  end
     @(negedge clk)
         pkt_vld = 1'b0;
			d_in = {$random}%256;
     @ (negedge clk)
         ld_state =0;
   end
 endtask

  initial
    begin
	   reset;
		#10;
		packet_generation_2;
		
		#100 $finish;
	 end
		
      
endmodule

