class source_agt_config extends uvm_object;

	`uvm_object_utils(source_agt_config);
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	virtual source_if s_vif;
	
	

	extern function new(string name = "source_agt_config");
	
endclass

function source_agt_config:: new(string name = "source_agt_config");
	
	super.new(name);
endfunction	
