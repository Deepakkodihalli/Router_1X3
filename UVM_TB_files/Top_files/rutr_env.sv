class rutr_env extends uvm_env;

  `uvm_component_utils(rutr_env);

  source_agt_top s_agt_h;
  dest_agt_top d_agt_h;
  //rutr_scoreboard sb;
  
  env_config m_cfg;

 extern function new(string name = "rutr_env", uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);

endclass

function rutr_env:: new(string name = "rutr_env", uvm_component parent);
	super.new(name,parent);
endfunction

function void rutr_env:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	s_agt_h = source_agt_top::type_id::create("s_agt_top",this);
	
	d_agt_h = dest_agt_top::type_id::create("d_agt_top",this);
	
	if(!uvm_config_db #(env_config):: get(this,"","env_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get() env_config from db");
		
	//sb = new[m_cfg.no_of_dest_agt];
	//foreach(sb[i])
	//sb = rutr_scoreboard::type_id::create("scoreboard",this);
	
endfunction

function void rutr_env::connect_phase(uvm_phase phase);

	//foreach(s_agt_h.s_agnth[i])
		//s_agt_h.s_agnth[i].monh.monitor_port.connect(sb.fifo_srch.analysis_export);
		
	//foreach(d_agt_h.d_agnth[i])
	//	d_agt_h.d_agnth[i].monh.monitor_port.connect(sb.fifo_desth[i].analysis_export);
endfunction


task rutr_env:: run_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"i am running in ENV run phase",UVM_HIGH);
	uvm_top.print_topology;
endtask
