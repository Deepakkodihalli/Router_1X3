class dest_driver extends uvm_driver #(dest_xtn);

  `uvm_component_utils(dest_driver);
  
   virtual dest_if.DRV_MP d_vif;
   dest_agt_config d_cfg;
   


extern function new(string name = "dest_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(dest_xtn xtn); 
endclass

function dest_driver:: new(string name = "dest_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void dest_driver:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(dest_agt_config):: get(this,"","dest_agt_config",d_cfg))
		`uvm_fatal(get_type_name(),"cannot get() dest_agt_config from db");
endfunction

function void dest_driver:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	d_vif = d_cfg.d_vif ;
endfunction

task dest_driver:: run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task dest_driver:: send_to_dut(dest_xtn xtn);
	$display("printing from dest_driver");
	xtn.print();
	$display("printing the vld_out = %b",d_vif.drv_cb.vld_out);
	//`uvm_info(get_type_name(),$sformatf("printing from the DRIVER \n %s",xtn.sprint()),UVM_LOW);
	wait(d_vif.drv_cb.vld_out == 1)
	
	repeat(xtn.delay)
	@(d_vif.drv_cb);
	d_vif.drv_cb.rd_enb <= 1'b1;
	wait(d_vif.drv_cb.vld_out == 0)
	
	@(d_vif.drv_cb);
	d_vif.drv_cb.rd_enb <= 1'b0;

endtask