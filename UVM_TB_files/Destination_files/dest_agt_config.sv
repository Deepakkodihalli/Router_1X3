class dest_agt_config extends uvm_object;

	`uvm_object_utils(dest_agt_config);
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	virtual dest_if d_vif;

	extern function new(string name = "dest_agt_config");
	
endclass

function dest_agt_config:: new(string name = "dest_agt_config");
	
	super.new(name);
endfunction