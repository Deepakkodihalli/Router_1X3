class source_monitor extends uvm_monitor;

  `uvm_component_utils(source_monitor);
	
	virtual source_if.MON_MP s_vif;
	source_agt_config s_cfg;

	uvm_analysis_port #(source_xtn) monitor_port;

extern function new(string name = "source_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass

function source_monitor:: new(string name = "source_monitor", uvm_component parent);
        super.new(name,parent);
		monitor_port = new("monitor_port", this);
endfunction

function void source_monitor:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(source_agt_config):: get(this,"","source_agt_config",s_cfg))
		`uvm_fatal(get_type_name(),"cannot get() source_agt_config from db");
endfunction

function void source_monitor:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	s_vif = s_cfg.s_vif ;
endfunction

task source_monitor:: run_phase(uvm_phase phase);
	forever
		collect_data();
			`uvm_info(get_type_name(),"i am monitoring in monitor run_phase",UVM_LOW);
endtask

task source_monitor:: collect_data();
	source_xtn xtn;
	xtn = source_xtn::type_id::create("source_xtn");
	
	wait(s_vif.mon_cb.busy == 0)
	wait(s_vif.mon_cb.pkt_vld == 1'b1)
	
	xtn.rstn <= s_vif.mon_cb.rstn;
	xtn.header <= s_vif.mon_cb.d_in;
	@(s_vif.mon_cb);
	xtn.payload = new[xtn.header[7:2]];
	$display("printing payload size = %d",xtn.header[7:2] );
		
	@(s_vif.mon_cb);
	
	foreach(xtn.payload[i])
		begin
			wait(s_vif.mon_cb.busy == 0)
			xtn.payload[i] = s_vif.mon_cb.d_in;
			@(s_vif.mon_cb);
				$display("printing busy state = %b",s_vif.mon_cb.busy );
		end
	//@(s_vif.mon_cb);	

	wait(s_vif.mon_cb.busy == 0)
	$display("printing busy state = %b",s_vif.mon_cb.busy );
	wait(s_vif.mon_cb.pkt_vld == 1'b0)
	xtn.parity = s_vif.mon_cb.d_in;
	
	//@(s_vif.mon_cb);
	//@(s_vif.mon_cb);
	
	xtn.err = s_vif.mon_cb.err;
	
	$display("printing from source_monitor");
	xtn.print();
	//`uvm_info(get_type_name(),$sformatf("printing from the source_monitor \n %s",xtn.sprint()),UVM_LOW);
	
	monitor_port.write(xtn);
endtask
	
