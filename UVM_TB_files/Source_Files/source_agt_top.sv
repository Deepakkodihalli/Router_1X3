class source_agt_top extends uvm_env;

  `uvm_component_utils(source_agt_top);
  
  source_agt s_agnth[];
  env_config m_cfg;
  source_agt_config s_cfg[];

extern function new(string name = "source_agt_top", uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass

function source_agt_top:: new(string name = "source_agt_top", uvm_component parent);
	super.new(name,parent);
endfunction

function void source_agt_top:: build_phase(uvm_phase phase);
	
	super.build_phase(phase);
	if(!uvm_config_db #(env_config):: get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get() env_config from db");
		
	s_cfg = new[m_cfg.no_of_source_agt];	
	s_agnth = new[m_cfg.no_of_source_agt];
	foreach(s_agnth[i])
	begin
	s_cfg[i] = source_agt_config::type_id::create($sformatf("s_cfg[%d]",i));
	s_cfg[i] = m_cfg.s_cfg[i];
	//$display("i am in ruter source_agt_top and setting source_cfg	= %d",m_cfg.s_cfg[i]);
	s_agnth[i] = source_agt::type_id::create($sformatf("s_agnth[%0d]",i),this);
	
	uvm_config_db #(source_agt_config):: set(this,$sformatf("s_agnth[%0d]*",i),"source_agt_config",s_cfg[i]);
	end
endfunction
