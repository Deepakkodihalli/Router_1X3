class source_driver extends uvm_driver #(source_xtn);

  `uvm_component_utils(source_driver);
  
   virtual source_if.DRV_MP s_vif;
   source_agt_config s_cfg; 
   


extern function new(string name = "source_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(source_xtn xtn); 
endclass

function source_driver:: new(string name = "source_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void source_driver:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(source_agt_config):: get(this,"","source_agt_config",s_cfg))
		`uvm_fatal(get_type_name(),"cannot get() source_agt_config from db");
endfunction

function void source_driver:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	s_vif = s_cfg.s_vif ;
	`uvm_info(get_type_name(),"i am connecting s_vif to s_cfg.s_vif in driver",UVM_HIGH);
endfunction

task source_driver:: run_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"i am running in driver run phase",UVM_HIGH);
	//super.run_phase(phase);
	
	@(s_vif.drv_cb);
		`uvm_info(get_type_name(),"i gave one delay in driver run_phase",UVM_HIGH);
	s_vif.drv_cb.rstn <= 1'b0;
	@(s_vif.drv_cb);
	s_vif.drv_cb.rstn <= 1'b1;
	forever
	begin
		`uvm_info(get_type_name(),"i am REQUESTING FOR NXT ITEM IN run phase",UVM_HIGH);
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done;
	end
endtask

task source_driver:: send_to_dut(source_xtn xtn);
	$display("printing from source_driver");
	xtn.print;
	`uvm_info(get_type_name(),"i am PRINTING THE source_xtn in driver",UVM_HIGH);
	
	//`uvm_info(get_type_name(),$sformatf("printing from the DRIVER \n %s",xtn.sprint()),UVM_LOW);
	wait(s_vif.drv_cb.busy == 0)
	@(s_vif.drv_cb);
	
	s_vif.drv_cb.pkt_vld <= 1'b1;
	s_vif.drv_cb.d_in <= xtn.header;
	@(s_vif.drv_cb);
	foreach(xtn.payload[i])
	begin
		wait(s_vif.drv_cb.busy == 0)
		s_vif.drv_cb.d_in <= xtn.payload[i];
		@(s_vif.drv_cb);
	end
	wait(s_vif.drv_cb.busy == 0)
	s_vif.drv_cb.pkt_vld <= 1'b0;
	s_vif.drv_cb.d_in <= xtn.parity;
	@(s_vif.drv_cb);
endtask
