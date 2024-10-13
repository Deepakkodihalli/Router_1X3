class dest_xtn extends uvm_sequence_item;

	`uvm_object_utils(dest_xtn);
	
	 bit[7:0] header;
	 bit[7:0] payload[];
	 bit[7:0] parity;
	 rand bit[5:0] delay;
	 
	constraint payload_size{payload.size() == header[7:2];}
	extern function new(string name = "dest_xtn");
	extern function void do_print(uvm_printer printer);
	
endclass

function dest_xtn:: new(string name = "dest_xtn");
	super.new(name);
endfunction

function void dest_xtn:: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("header",	this.header,	8,	UVM_BIN);
	payload = new[header[7:2]];
	foreach(payload[i])
	begin
	printer.print_field($sformatf("payload[%0d]",i),	this.payload[i],	8,	UVM_DEC);
	end
	printer.print_field("parity",	this.parity,	8,	UVM_DEC);
	printer.print_field("delay",	this.delay,		6,  UVM_DEC);
endfunction
