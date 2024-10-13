class source_sequence extends uvm_sequence #(source_xtn);

	`uvm_object_utils(source_sequence);
	 bit[1:0] addr;
function new(string name = "source_sequence");
	super.new(name);
endfunction

/*task body();
uvm_config_db #(bit[1:0]):: get(null, get_type_name(),"bit",addr);
	`uvm_fatal(get_type_name(),"cannot get() addr config from db");
endtask*/

endclass

class small_packet extends source_sequence;

	`uvm_object_utils(small_packet);
	
extern function new(string name = "small_packet");
extern task body();

endclass

function small_packet:: new( string name = "small_packet");
	super.new(name);
endfunction

task small_packet:: body();
	
	super.body();
	req = source_xtn::type_id::create("small_source_xtn");
	start_item(req);
	assert(req.randomize() with {header [7:2] inside {[0:16]};
								 header [1:0] == 2'b00;});
	finish_item(req);
endtask

class medium_packet extends source_sequence;

	`uvm_object_utils(medium_packet);
	
extern function new(string name = "medium_packet");
extern task body();

endclass

function medium_packet:: new( string name = "medium_packet");
	super.new(name);
endfunction

task medium_packet:: body();

	req = source_xtn::type_id::create("medium_source_xtn");
	start_item(req);
	assert(req.randomize() with {header [7:2] inside{[17:40]};
								 header [1:0] == 2'b01;});
	finish_item(req);
endtask
								 
class large_packet extends source_sequence;

	`uvm_object_utils(large_packet);
	
extern function new(string name = "large_packet");
extern task body();

endclass

function large_packet:: new( string name = "large_packet");
	super.new(name);
endfunction

task large_packet:: body();

	req = source_xtn::type_id::create("large_source_xtn");
	start_item(req);
	assert(req.randomize() with {header [7:2] inside{[41:63]};
								 header [1:0] == 2'b10;});
	finish_item(req);
endtask