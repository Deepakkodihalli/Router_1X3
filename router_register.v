`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:46 04/03/2024 
// Design Name: 
// Module Name:    router_register 
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
module router_register(
    input clk,rstn,pkt_vld,fifo_full,rst_int_reg,detect_addr,
	       ld_state,laf_state,full_state,lfd_state,
    input [7:0] d_in,
    output reg parity_done,low_pkt_vld,err,
    output reg [7:0] d_out
    );
	 
	 reg [7:0] hb_reg, fifo_full_reg, int_parity, pkt_parity;
	 
//d_out
	 
	 always @(posedge clk)
	    begin
		   if(!rstn)
			 begin
			   hb_reg <= 8'b0;
				d_out  <= 8'b0;
			 end
			
			else 
			    begin
			        if(pkt_vld && detect_addr && d_in[1:0] !=2'b11)
			             hb_reg <= d_in;
				     else if(lfd_state)
				               d_out <= hb_reg;
									
					  else if(ld_state && ~fifo_full)
					            d_out <= d_in;
					  else if(ld_state && fifo_full)
					           fifo_full_reg <= d_in;
					  else if(laf_state)
					           d_out <= fifo_full_reg;
				 
			        else d_out <= d_out;
				 end
	   end
//internal parity
	
	always @(posedge clk)
	    begin
		    if(!rstn)
			    int_parity <= 8'b0;
				 
			else if(detect_addr)
			     int_parity <= 8'b0;
			 
			 else if (lfd_state)
			     int_parity <= int_parity^hb_reg;
				  
		    else if(pkt_vld && ld_state && ~full_state)
			          int_parity <= int_parity^d_in;
				  
			 else int_parity <= int_parity;
      end
//packet_parity
  always @(posedge clk)
      begin
		  if(!rstn)
		     pkt_parity <= 8'b0;
			  
		  else 
		      begin
				 if(detect_addr) pkt_parity <= 8'b0;

		      else if(!pkt_vld && ld_state)
				   pkt_parity <= d_in;
					
				else pkt_parity <= pkt_parity;
			 end
			
	  end
//parity_done
	  
  always @(posedge clk)
     begin
	    if(!rstn)
		    parity_done <= 1'b0;
			 
	    else begin
		        if(!pkt_vld && ld_state && !fifo_full)
		            parity_done <= 1'b1;
				  
				  else if(laf_state && low_pkt_vld && !parity_done)
				      parity_done <= 1'b1;
	   		end
	  end
	  
//low_packet valid
  always @(posedge clk)
     begin
	    if(!rstn)
		    low_pkt_vld <= 1'b0;
			
		 else
		    begin
			   if(rst_int_reg)
				   low_pkt_vld <= 1'b0;
				
				else if(ld_state && !pkt_vld)
				   low_pkt_vld <= 1'b1;
					
			 end
	 end

// error
  always @(posedge clk)
      begin
		  if(!rstn)
		    err <= 1'b0;
		  else
		     begin
			    if(parity_done)
				 begin
			    if(int_parity != pkt_parity)
				    err <= 1'b1;
			    else
				    err <= 1'b0;
				end
			end
		end
				   

endmodule
