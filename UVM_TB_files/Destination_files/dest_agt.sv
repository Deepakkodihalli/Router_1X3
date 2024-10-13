class dest_agt extends uvm_agent;

  `uvm_component_utils(dest_agt);
  
  dest_driver drvh;
  dest_monitor monh;
  dest_sequencer seqrh;
  
  dest_agt_config d_cfg;
	//env_config m_cfg;
extern function new(string name = "dest_agt", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function dest_agt:: new(string name = "dest_agt", uvm_component parent);
	super.new(name,parent);
endfunction

function void dest_agt:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(dest_agt_config):: get(this,"","dest_agt_config",d_cfg))
		`uvm_fatal(get_type_name(),"cannot get() dest_agt_config from db");
	//$display("i am in ruter dest_agt and getting dest_cfg	= %d",d_cfg[i]);	
	monh = dest_monitor::type_id::create("dest_monitor",this);
	if(d_cfg.is_active == UVM_ACTIVE)
	begin
		drvh = dest_driver::type_id::create("dest_driver",this);
		seqrh = dest_sequencer::type_id::create("dest_sequencer",this);
	end
endfunction

function void dest_agt:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(d_cfg.is_active == UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction