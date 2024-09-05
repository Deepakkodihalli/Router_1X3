`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:23:17 03/28/2024 
// Design Name: 
// Module Name:    fifo_router1x3 
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
module fifo_router(
           
			  input clk,rstn,wr_en,rd_en,soft_rst,lfd_state,
			  input [7:0] d_in,
			  output empty,full,
			  output reg [7:0] d_out
    );
	 reg [3:0] wr_ptr, rd_ptr; 
	 reg [8:0] mem [15:0];
	 reg [5:0] temp;
	 reg a;
	 integer i;
 
 // empty and full
 
	 assign empty = (wr_ptr == rd_ptr)? 1'b1:1'b0;
	 assign full  = (wr_ptr == 4'b1111 && rd_ptr == 4'b0)? 1'b1: 1'b0;

//lfd_state
always@(posedge clk)
	begin
		if(!rstn)
			a<=1'b0;
		else 
			a<=lfd_state;
	end 
	
// write operation
	 
	 always @(posedge clk)
	   begin
		  if(!rstn)
		     begin
			    for(i=0; i<16; i=i+1)
				   begin
					  mem[i] <= 1'b0;
					  wr_ptr <= 1'b0;
			      end
			  end
			  
		  else if(soft_rst)
		     begin
			    for(i=0; i<16; i=i+1)
				   begin
					  mem[i] <= 1'b0;
					  wr_ptr <= 1'b0;
			      end
			  end
			  
		  else if(wr_en && !full)
		    begin
			  {mem[wr_ptr[3:0]][8], mem[wr_ptr[3:0]][7:0]} <= {a,d_in};
				 wr_ptr <= wr_ptr+1'b1;
			end
	 end
 // read operation
 
	 always @(posedge clk)
	    begin
		   if(!rstn)
			   begin
				  d_out <= 8'b0;
				  rd_ptr <= 1'b0;
				end
			else if(soft_rst) d_out <= 8'bz;
			  
			else 
			  begin
			    if(rd_en && !empty)
				   begin
	  				   d_out <= mem[rd_ptr[3:0]][7:0];
						rd_ptr <= rd_ptr+1'b1;
						if(temp == 0) d_out <= 8'bz;
					end
			end
		end
	// temp logic	
	always @(posedge clk)
	   begin
		  if(rd_en && !empty)
		    begin
			   if(mem[rd_ptr[3:0]][8])
				   
					temp <= mem[rd_ptr[3:0]][7:2] +1'b1;
				
				else temp <= temp-1'b1;     
		    end
		end 
		 
		
endmodule
