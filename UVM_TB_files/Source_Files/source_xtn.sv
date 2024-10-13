
	`include "uvm_macros.svh"
	//import uvm_pkg::*;
class source_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(source_xtn);
	
	rand bit[7:0] header;
	randc bit[7:0] payload[];
    bit[7:0] parity;
	
	bit rstn;
	bit err,busy,pkt_vld;
	
	constraint valid_addr{header [1:0] inside{[0:2]};}
	constraint valid_length{header [7:2] != 0;}
	constraint payload_size{payload.size() == header[7:2];}
	
	extern function new(string name = "source_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
	
endclass

function source_xtn:: new(string name = "source_xtn");
	super.new(name);
endfunction

function void source_xtn:: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("header",	this.header,	8,	UVM_BIN);
	//payload = new[header[7:2]];
	foreach(payload[i])
	begin
	printer.print_field($sformatf("payload[%0d]",i),	this.payload[i],	8,	UVM_DEC);
	end
	printer.print_field("parity",	this.parity,	8,	UVM_DEC);
	printer.print_field("rstn",		this.rstn,		1,	UVM_DEC);
	printer.print_field("err",		this.err,		1,	UVM_DEC);
	printer.print_field("busy",		this.busy,		1,	UVM_DEC);
	printer.print_field("pkt_vld",	this.pkt_vld,	1,	UVM_DEC);
	
endfunction

function void source_xtn:: post_randomize();
	//$display("POST_RANDOMIZE : %p"payload);
	`uvm_info("POST_RANDOMIZE",$sformatf("Randomized Payload: %p", payload), UVM_LOW)
	foreach (payload[i]) begin
      payload[i] = $random;
   end
	parity = header^0;
	foreach(payload[i])
	begin
		parity = parity^payload[i];
	end
endfunction