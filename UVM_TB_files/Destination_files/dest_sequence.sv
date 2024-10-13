class dest_sequence extends uvm_sequence #(dest_xtn);

	`uvm_object_utils(dest_sequence);
	
extern function new(string name = "dest_sequence");
//extern task body();

endclass

function dest_sequence:: new( string name = "dest_sequence");
	super.new(name);
endfunction


class dest_seq1 extends dest_sequence;

	`uvm_object_utils(dest_seq1);

extern function new(string name = "dest_seq1");
extern task body();	

endclass

function dest_seq1:: new( string name = "dest_seq1");
	super.new(name);
endfunction	
	
task dest_seq1:: body();

	req = dest_xtn::type_id::create("dest_seq1");
	start_item(req);
	assert(req.randomize() with {delay inside {[1:29]};}); 
	finish_item(req);
endtask

class dest_seq2 extends dest_sequence;

	`uvm_object_utils(dest_seq2);

extern function new(string name = "dest_seq2");
extern task body();	

endclass

function dest_seq2:: new( string name = "dest_seq2");
	super.new(name);
endfunction	
	
task dest_seq2:: body();

	req = dest_xtn::type_id::create("dest_seq2");
	start_item(req);
	assert(req.randomize() with {delay >30;}); 
	finish_item(req);
endtask