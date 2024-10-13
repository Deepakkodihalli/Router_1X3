class source_agt extends uvm_agent;

  `uvm_component_utils(source_agt);
  
  source_driver drvh;
  source_monitor monh;
  source_sequencer seqrh;
  
  source_agt_config s_cfg;
  

extern function new(string name = "source_agt", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function source_agt:: new(string name = "source_agt", uvm_component parent);
	super.new(name,parent);
endfunction

function void source_agt:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(source_agt_config):: get(this,"","source_agt_config",s_cfg))
		`uvm_fatal(get_type_name(),"cannot get() source_agt_config from db");
	//$display("i am in source_agt = %d",m_cfg.s_cfg[i]);	
	monh = source_monitor::type_id::create("source_monitor",this);
	if(s_cfg.is_active == UVM_ACTIVE)
	begin
		drvh = source_driver::type_id::create("source_driver",this);
		seqrh = source_sequencer::type_id::create("source_sequencer",this);
	end
	
endfunction

function void source_agt:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(s_cfg.is_active == UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction