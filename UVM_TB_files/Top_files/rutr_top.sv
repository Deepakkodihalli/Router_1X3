`timescale 1ns / 1ps
module rutr_top;

import rutr_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
bit clk;
always #5 clk = ~clk;

source_if s_vif(clk);
dest_if d_vif0(clk), d_vif1(clk), d_vif2(clk);

router_top_module DUT(.clk(clk),
					  .d_in(s_vif.d_in),
					  .err(s_vif.err),
					  .pkt_vld(s_vif.pkt_vld),
					  .rstn(s_vif.rstn),
					  .busy(s_vif.busy),
					  .d_out_0(d_vif0.d_out),
					  .vld_out_0(d_vif0.vld_out),
					  .rd_en_0(d_vif0.rd_enb),
					  .d_out_1(d_vif1.d_out),
					  .vld_out_1(d_vif1.vld_out),
					  .rd_en_1(d_vif1.rd_enb),
					  .d_out_2(d_vif2.d_out),
					  .vld_out_2(d_vif2.vld_out),
					  .rd_en_2(d_vif2.rd_enb));
					  
					  					  
initial 
  begin
    uvm_config_db #(virtual source_if):: set(null,"*","s_vif0",s_vif);
	uvm_config_db #(virtual dest_if):: set(null,"*","d_vif0",d_vif0);
	uvm_config_db #(virtual dest_if):: set(null,"*","d_vif1",d_vif1);
	uvm_config_db #(virtual dest_if):: set(null,"*","d_vif2",d_vif2);
	
	run_test();
  end

endmodule
