class base_test extends uvm_test;

  `uvm_component_utils(base_test);

  rutr_env envh;   
  
  source_agt_config s_cfg[];
 dest_agt_config d_cfg[];
  env_config m_cfg;

  int no_of_source_agt = 1;
  int no_of_dest_agt = 3;	

	bit[1:0] addr = $urandom%3;
	
extern function new(string name = "base_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function base_test:: new(string name = "base_test", uvm_component parent);
	
	super.new(name,parent);
endfunction:new

 function void base_test:: build_phase(uvm_phase phase);
 
	m_cfg = env_config::type_id::create("env_config");
	m_cfg.s_cfg = new[no_of_source_agt];
	s_cfg = new[no_of_source_agt];
	foreach(s_cfg[i])
	begin
	s_cfg[i] = source_agt_config::type_id::create($sformatf("s_cfg[%0d]",i));
	
	if(!uvm_config_db #(virtual source_if):: get(this,"",$sformatf("s_vif%0d",i),s_cfg[i].s_vif))
		`uvm_fatal(get_type_name(),"cannot get() virtual if from db");  
		s_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.s_cfg[i] = s_cfg[i];
	end
	m_cfg.d_cfg = new[no_of_dest_agt];
	d_cfg = new[no_of_dest_agt];
	foreach(d_cfg[i])
	begin
	d_cfg[i] = dest_agt_config::type_id::create($sformatf("d_cfg[%0d]",i));
	if(!uvm_config_db #(virtual dest_if):: get(this,"",$sformatf("d_vif%0d",i),d_cfg[i].d_vif))
        `uvm_fatal(get_type_name(),"cannot get() virtual if from db");
		 d_cfg[i].is_active = UVM_ACTIVE;
		 m_cfg.d_cfg[i] = d_cfg[i];
	end 
	
	m_cfg.no_of_source_agt = no_of_source_agt;
	m_cfg.no_of_dest_agt = no_of_dest_agt;
	
	uvm_config_db #(env_config):: set(this,"*","env_config",m_cfg);
	//$display("i am in ruter test and setting env_cfg	= %d",m_cfg);
	super.build_phase(phase);
	
	envh = rutr_env::type_id::create("envh",this);
	//$display("i am in ruter test and creating env_cfg	= %d",m_cfg);
	
	
	uvm_config_db #(bit[1:0]):: set(this,"*","bit",addr);
endfunction

task base_test:: run_phase(uvm_phase phase);

	if(!uvm_config_db #(bit[1:0]):: get(this, "*","bit", addr))
		`uvm_fatal(get_type_name(),"cannot get() addr config from db");
endtask




class small_packet_test extends base_test;
	
	`uvm_component_utils(small_packet_test);
	
	small_packet small_seq;
	dest_seq1 d_seq1;
	
extern function new(string name = "small_packet_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass


function small_packet_test:: new(string name = "small_packet_test", uvm_component parent);
	
	super.new(name,parent);
endfunction:new

 function void small_packet_test:: build_phase(uvm_phase phase);


	super.build_phase(phase);
endfunction

task small_packet_test:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	small_seq = small_packet::type_id::create("small_seq");
	d_seq1 = dest_seq1::type_id::create("dest_seq1");
	phase.raise_objection(this);
	small_seq.start(envh.s_agt_h.s_agnth[0].seqrh);
	if(addr == 2'b00)
	d_seq1.start(envh.d_agt_h.d_agnth[0].seqrh);
	
	if(addr == 2'b01)
	d_seq1.start(envh.d_agt_h.d_agnth[1].seqrh);
	
	if(addr == 2'b10)
	d_seq1.start(envh.d_agt_h.d_agnth[2].seqrh);
	
	phase.drop_objection(this);
endtask

class medium_packet_test extends base_test;
	
	`uvm_component_utils(medium_packet_test);
	
	medium_packet medium_seq;
	
extern function new(string name = "medium_packet_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass


function medium_packet_test:: new(string name = "medium_packet_test", uvm_component parent);
	
	super.new(name,parent);
endfunction:new

 function void medium_packet_test:: build_phase(uvm_phase phase);


	super.build_phase(phase);
endfunction

task medium_packet_test:: run_phase(uvm_phase phase);

	medium_seq = medium_packet::type_id::create("medium_seq");
	phase.raise_objection(this);
	foreach(s_cfg[i])
	medium_seq.start(envh.s_agt_h.s_agnth[i].seqrh);
	
	phase.drop_objection(this);
endtask

class large_packet_test extends base_test;
	
	`uvm_component_utils(large_packet_test);
	
	medium_packet large_seq;
	
extern function new(string name = "large_packet_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass


function large_packet_test:: new(string name = "large_packet_test", uvm_component parent);
	
	super.new(name,parent);
endfunction:new

 function void large_packet_test:: build_phase(uvm_phase phase);


	super.build_phase(phase);
endfunction

task large_packet_test:: run_phase(uvm_phase phase);

	large_seq = medium_packet::type_id::create("large_seq");
	phase.raise_objection(this);
	foreach(s_cfg[i])
	large_seq.start(envh.s_agt_h.s_agnth[i].seqrh);
	
	phase.drop_objection(this);
endtask











