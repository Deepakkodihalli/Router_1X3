`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:03:57 04/02/2024 
// Design Name: 
// Module Name:    router_fsm 
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

module router_fsm(
        input clk,rstn,pkt_vld,parity_done,fifo_full,low_pkt_vld,
		  input [1:0]d_in,
		  input sft_rst_0,sft_rst_1,sft_rst_2,fifo_empty_0,fifo_empty_1,fifo_empty_2,
		  output  busy,detect_addr,ld_state,
		  output laf_state,full_state,wr_en_reg,rst_int_reg,lfd_state);
		  
		  
	  parameter [2:0] decode_addr        =0,
	                  load_first_data     =1,
					      wait_till_empty    =2,
					      load_data          =3,
					      load_parity        =4,
					      check_parity_error =5,
					      fifo_full_state     =6,
					      load_after_full    =7;
							
				reg [2:0] present_state,nxt_state;
				reg [1:0]temp;
				
	always@(posedge clk)
	begin
		if(!rstn)
			temp<=2'b0;
		else if(detect_addr)        
		 	temp<=d_in;
	end
	
   always @(posedge clk)
	      begin
			  if(!rstn)
			    present_state <= decode_addr;
				 
			  else if (((sft_rst_0) && (temp==2'b00)) || 
			  ((sft_rst_1) && (temp==2'b01)) || 
			  ((sft_rst_2) && (temp==2'b10)))		
			     present_state <= decode_addr;
				  
			  else present_state <= nxt_state;
		  end
	
	always @(*)
	   begin
		  nxt_state <= decode_addr;
		  case(present_state)
		   decode_addr: begin
			               if((pkt_vld &   (temp [1:0]== 0) & fifo_empty_0)|
			                  (pkt_vld &   (temp [1:0]== 1) & fifo_empty_1)|
									(pkt_vld &   (temp [1:0]==2) & fifo_empty_2))
									begin
									  nxt_state <= load_first_data;
									  
									end
							 
							  else if((pkt_vld & (temp [1:0]==0) & !fifo_empty_0)|
			                     (pkt_vld & (temp [1:0]== 1) & !fifo_empty_1)|
									   (pkt_vld & (temp[1:0]==2) & !fifo_empty_2))
										begin
										  nxt_state <= wait_till_empty;
										  
									   end
							 else nxt_state <= present_state;
							end
							
			wait_till_empty: begin         
			                   if((fifo_empty_0 && (temp==2'b00))||
									    (fifo_empty_1 && (temp==2'b01))||
										 (fifo_empty_2 && (temp==2'b10))) 
					                  
											nxt_state<=load_first_data;

				                else
					                  nxt_state<=wait_till_empty;
			                end

			 
			 load_first_data: begin
           			          nxt_state <= load_data;
						 
					            end
			 
			 load_data: begin
			              
			              if(!fifo_full && !pkt_vld) nxt_state <= load_parity;
			            
							  else if(fifo_full) nxt_state <= fifo_full_state;
							
							  else nxt_state <= present_state;
						  end
							
			 load_parity : begin
                			  nxt_state <= check_parity_error;
								  
								end
			 
			 check_parity_error: begin
			                       
                      			  if(!fifo_full) nxt_state <= decode_addr;
			                     
										  else if(fifo_full) nxt_state <= fifo_full_state;
										  
										  else nxt_state <= present_state;
										end
										
			 fifo_full_state: begin
			                    
                    			 if(!fifo_full) nxt_state <= load_after_full;
			                  
									 else nxt_state <= present_state;
								 end
									
			load_after_full: begin
			                    
			                   if(parity_done) nxt_state <= decode_addr;
			                 
								    else if(!parity_done && low_pkt_vld) nxt_state <= load_parity;
								  
								    else if(!parity_done && !low_pkt_vld) nxt_state <= load_data;
									 
									 else nxt_state <= present_state;
								 end
								
			default: nxt_state <= decode_addr;
			
	  endcase
	  
	end
			
	assign busy=((present_state==load_first_data)||
	             (present_state==load_parity)||
					 (present_state==fifo_full_state)||
					 (present_state==load_after_full)||
					 (present_state==wait_till_empty)||
					 (present_state==check_parity_error))?1'b1:1'b0;
					 
   assign detect_addr=((present_state==decode_addr))?1'b1:1'b0;
	
   assign lfd_state=((present_state==load_first_data))?1'b1:1'b0;
	
   assign ld_state=((present_state==load_data))?1'b1:1'b0;
	
   assign wr_en_reg=((present_state==load_data)||
	                      (present_state==load_after_full)||
								 (present_state==load_parity))   ?1'b1:1'b0;
								 
   assign full_state=((present_state==fifo_full_state))?1'b1:1'b0;
	
   assign laf_state=((present_state==load_after_full))?1'b1:1'b0;
	
   assign rst_int_reg=((present_state==check_parity_error))?1'b1:1'b0;
		  


endmodule
