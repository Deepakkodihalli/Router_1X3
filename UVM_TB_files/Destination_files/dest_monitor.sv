class dest_monitor extends uvm_monitor;

  `uvm_component_utils(dest_monitor);
	
	virtual dest_if.MON_MP d_vif;
	dest_agt_config d_cfg;

	uvm_analysis_port #(dest_xtn) monitor_port;

extern function new(string name = "dest_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass

function dest_monitor:: new(string name = "dest_monitor", uvm_component parent);
        super.new(name,parent);
		monitor_port = new("monitor_port", this);
endfunction

function void dest_monitor:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(dest_agt_config):: get(this,"","dest_agt_config",d_cfg))
		`uvm_fatal(get_type_name(),"cannot get() dest_agt_config from db");
endfunction

function void dest_monitor:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	d_vif = d_cfg.d_vif ;
endfunction

task dest_monitor:: run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task dest_monitor:: collect_data();
	dest_xtn xtn;
	xtn = dest_xtn::type_id::create("dest_xtn");
	
	wait(d_vif.mon_cb.rd_enb == 1)
	@(d_vif.mon_cb);
	
	xtn.header <= d_vif.mon_cb.d_out;
	xtn.payload = new[xtn.header[7:2]];
	@(d_vif.mon_cb);
	
	foreach(xtn.payload[i])
		begin
			wait(d_vif.mon_cb.rd_enb == 1)
			xtn.payload[i] = d_vif.mon_cb.d_out;
			@(d_vif.mon_cb);
		end
	xtn.parity = d_vif.mon_cb.d_out;
	
	$display("printing from dest_monitor");
	xtn.print();
	//`uvm_info(get_type_name(),$sformatf("printing from the dest_monitor \n %s",xtn.sprint()),UVM_LOW);
	monitor_port.write(xtn);
endtask
	
