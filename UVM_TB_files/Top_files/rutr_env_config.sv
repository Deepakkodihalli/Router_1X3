class env_config extends uvm_object;

	`uvm_object_utils(env_config);
	
	source_agt_config s_cfg[];
	dest_agt_config d_cfg[];
	
	int no_of_source_agt;
	int no_of_dest_agt;

	extern function new(string name = "env_config");
	
endclass

function env_config:: new(string name = "env_config");
	
	super.new(name);
endfunction