class rutr_scoreboard extends uvm_scoreboard;

 `uvm_component_utils(rutr_scoreboard)
	uvm_tlm_analysis_fifo #(dest_xtn) fifo_desth[];
	uvm_tlm_analysis_fifo #(source_xtn) fifo_srch;

	source_xtn src_data;
	dest_xtn dest_data;

	dest_xtn dest_cov_data;
	source_xtn source_cov_data;
	env_config e_cfg;

	int data_verified_count;
	
	extern function new(string name,uvm_component parent); 
	extern function void build_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern function void check_data(dest_xtn dest);
	//extern function void report_phase(uvm_phase phase);

	covergroup rutr_fcov1;
	option.per_instance =1;

	CHANNEL: coverpoint source_cov_data.header [1:0]{
													bins low = {2'b00};
													bins mid1 = {2'b01};
													bins mid2 = {2'b10};
													}
	
	PAYLOAD_SIZE: coverpoint source_cov_data.header[7:2] {
															bins medium_packet = {[16:30]};
															bins small_packet = {[1:15]};
															bins large_packet = {[31:63]};
														   }
	
	BAD_PKT: coverpoint source_cov_data.err { bins bad_pkt ={1};}
	
	CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL, PAYLOAD_SIZE;
	CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT: cross CHANNEL, PAYLOAD_SIZE, BAD_PKT;
	
	endgroup

	covergroup rutr_fcov2;
	option.per_instance=1;
	
	CHANNEL: coverpoint dest_cov_data.header [1:0]{
													bins low  = {2'b00};
													bins mid1 ={2'b01};
													bins mid2 ={2'b10};
													}
	
	PAYLOAD_SIZE: coverpoint dest_cov_data.header[7:2] {
														bins small_packet = {[1:15]};
														bins medium_packet = {[16:30]};
														bins large_packet = {[31:63]};
														}
	CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL, PAYLOAD_SIZE;
	endgroup

endclass

function void rutr_scoreboard::build_phase(uvm_phase phase); 
	
	super.build_phase (phase);
	if(!uvm_config_db #(env_config)::get(this,"", "env_config",e_cfg)) 
		`uvm_fatal("EN_cfg", "no update");
		
	fifo_srch = new("fifo_srch", this);
	fifo_desth = new[e_cfg.no_of_dest_agt];
	
	foreach (fifo_desth[i])
	begin
	fifo_desth[i]=new($sformatf("fifo_desth[%d]",i), this);
	end
endfunction

function rutr_scoreboard::new(string name,uvm_component parent); 
	super.new(name,parent);
	rutr_fcov1 = new();
	rutr_fcov2 = new();
endfunction


task rutr_scoreboard:: run_phase (uvm_phase phase);
	fork
	begin
	forever
		begin
			fifo_srch.get(src_data);
			`uvm_info("WRITE SB", "source data", UVM_LOW)
			src_data.print;
			source_cov_data = src_data;
			rutr_fcov1.sample();
		end
	end
	begin
		begin
		forever
		fork
			begin
				fifo_desth[0].get(dest_data);
				`uvm_info("READ SB[0]", "dest data", UVM_LOW);
				dest_data.print;
				check_data(dest_data);
				dest_cov_data = dest_data;
				rutr_fcov2.sample();
			end
			
			begin
				fifo_desth[1].get(dest_data);
				`uvm_info("READ SB[1]", "dest data", UVM_LOW);
				dest_data.print;
				check_data(dest_data);
				dest_cov_data = dest_data;
				rutr_fcov2.sample();
			end
			
			begin
				fifo_desth[2].get(dest_data);
				`uvm_info("READ SB[2]", "dest data", UVM_LOW)
				dest_data.print;
				check_data(dest_data);
				dest_cov_data = dest_data;
				rutr_fcov2.sample();
			end

		join_any 
		disable fork;
		end
	end
	join
endtask

function void rutr_scoreboard::check_data(dest_xtn dest); 
	if(src_data.header == dest.header)
		`uvm_info("SB", "HEADER MATCHED SUCESSFULLY", UVM_MEDIUM)
	
	else `uvm_error("SB", "HEADER COMPARISION FAILED")
		
	if(src_data.payload == dest.payload) 
		`uvm_info("SB"," PAYLOAD MATCHED SUCESSFULLY", UVM_MEDIUM)
	else
		`uvm_error("SB", "PAYLOAD COMPARISION FAILED")
		
	if(src_data.parity == dest.parity) 
		`uvm_info("SB", "PARITY MATCHED SUCESSFULLY", UVM_MEDIUM)
		
	else `uvm_error("SB", "PARITY COMPARISION FAILED")
	
	data_verified_count++;
endfunction