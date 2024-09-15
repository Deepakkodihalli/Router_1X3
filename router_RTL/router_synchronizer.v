`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:29 03/30/2024 
// Design Name: 
// Module Name:    router_synchronizer 
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
module router_synchronizer( 
      
		input detect_addr, wr_en_reg, clk, rstn,
		input rd_en_0,rd_en_1,rd_en_2, empty_0,empty_1,empty_2, full_0,full_1,full_2,
		input [1:0] d_in,
		output reg fifo_full,
		output reg [2:0] wr_en, 
		output reg sft_rst_0,sft_rst_1,sft_rst_2,
      output  vld_out_0,vld_out_1,vld_out_2	
	 );
	 
	 reg [1:0] temp;
	 reg [4:0]count0,count1,count2;

	 
	 always @(posedge clk)
	   begin
		   if(!rstn) temp <= 1'b0;
		  
		   else if(detect_addr) temp <= d_in;
		  
		  else temp <=1'b0;
		end
		
	always @(posedge clk) 
	   begin
		   if(wr_en_reg)
		     case (temp)
			     2'b00 : wr_en[0] <= 1'b1;
				  2'b01 : wr_en[1] <= 1'b1;
				  2'b10 : wr_en[2] <= 1'b1;
				  default: wr_en <= 3'b0;
		     endcase
		  else wr_en <= 3'b0;
		end
   
	always @(*)
	  begin
	   case(temp)
		  2'b00: fifo_full = full_0;
		  2'b01: fifo_full = full_1;
		  2'b10: fifo_full = full_2;
		  default fifo_full = 1'b0;
		endcase
	 end
	 
	assign vld_out_0 = ~empty_0;
	assign vld_out_1 = ~empty_1;
	assign vld_out_2 = ~empty_2;
	
	wire flag0;
	assign flag0 = (count0==5'b11110);
	
	always@(posedge clk)
	begin
		if(!rstn)
			count0<=5'b0;
		else if(vld_out_0)
			begin
				if(!rd_en_0)
					begin
						if(flag0)	
							begin
								sft_rst_0<=1'b1;
								count0<=1'b0;
							end
						else
							begin
								count0<=count0+1'b1;
								sft_rst_0<=1'b0;
							end
					end
				else count0<=5'd0;
			end
		else count0<=5'd0;
	end
	
	wire flag1;
	assign flag1 = (count1==5'b11110);

 always@(posedge clk)
	begin
		if(!rstn)
			count1<=5'b0;
		else if(vld_out_1)
			begin
				if(!rd_en_1)
					begin
						if(flag1)	
							begin
								sft_rst_1<=1'b1;
								count1<=1'b0;
							end
						else
							begin
								count1<=count1+1'b1;
								sft_rst_1 <=1'b0;
							end
					end
				else count1<=5'd0;
			end
		else count1<=5'd0;
	end
	
	wire flag2;
	assign flag2 = (count2==5'b11110);

always@(posedge clk)
	begin
		if(!rstn)
			count2<=5'b0;
		else if(vld_out_2)
			begin
				if(!rd_en_2)
					begin
						if(flag2)	
							begin
								sft_rst_2 <= 1'b1;
								count2 <= 1'b0;
							end
						else
							begin
								count2<=count2+1'b1;
								sft_rst_2 <=1'b0;
							end
					end
				else count2<=5'd0;
			end
		else count2<=5'd0;
	end

		  
endmodule
