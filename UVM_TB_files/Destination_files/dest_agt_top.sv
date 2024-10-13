class dest_agt_top extends uvm_env;

	`uvm_component_utils(dest_agt_top);

	dest_agt d_agnth[];
	env_config m_cfg;
    dest_agt_config d_cfg[];

extern function new (string name = "dest_agt_top", uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function dest_agt_top :: new(string name = "dest_agt_top", uvm_component parent);

	super.new(name,parent);
endfunction
function void dest_agt_top:: build_phase(uvm_phase phase);

	super.build_phase(phase);
	if(!uvm_config_db #(env_config):: get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get() env_config from db");
	d_cfg = new[m_cfg.no_of_dest_agt]; 
	d_agnth = new[m_cfg.no_of_dest_agt];
	foreach(d_agnth[i])
	begin
	//d_cfg[i] = dest_agt_config::type_id::create($sformatf("d_cfg[%d]",i));
	d_cfg[i] = m_cfg.d_cfg[i];
	d_agnth[i] = dest_agt::type_id::create($sformatf("d_agnth[%0d]",i),this);

	uvm_config_db #(dest_agt_config):: set(this,$sformatf("d_agnth[%0d]*",i),"dest_agt_config",d_cfg[i]);

	end
endfunction
