`ifndef TEST_1011_BOARD
`define TEST_1011_BOARD

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  	bit[3:0] 	ref_pattern;
  	bit[3:0] 	act_pattern;
	bit 				exp_out;
  
  uvm_analysis_imp #(Item, scoreboard) m_analysis_imp;
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_analysis_imp = new("m_analysis_imp", this);
    if (!uvm_config_db#(bit[3:0])::get(this, "*", "ref_pattern", ref_pattern))
			`uvm_fatal("SCBD", "Did not get ref_pattern !")
  endfunction
  
  virtual function write(Item item);        
    act_pattern = act_pattern << 1 | item.in;
    
    `uvm_info("SCBD", $sformatf("in=%0d out=%0d ref=0b%0b act=0b%0b", 
                               item.in, item.out, ref_pattern, act_pattern), UVM_LOW)

    // Always check that expected out value is the actual observed value
    // Since it takes 1 clock for out to be updated after pattern match, 
    // do the check first and then update exp_out value
    if (item.out != exp_out) begin
      `uvm_error("SCBD", $sformatf("ERROR ! out=%0d exp=%0d", 
                                   				item.out, exp_out))
    end else begin
      `uvm_info("SCBD", $sformatf("PASS ! out=%0d exp=%0d", 
                                  item.out, exp_out), UVM_HIGH)
    end

    // If current index has reached the full pattern, then set exp_out to be 1
    // which will be checked in the next clock. If pattern is not complete, keep
    // exp_out to zero
    if (!(ref_pattern ^ act_pattern)) begin
      `uvm_info("SCBD", $sformatf("Pattern found to match, next out should be 1"), UVM_LOW)
		exp_out = 1;
    end else begin
      exp_out = 0;
    end
		
  endfunction
endclass

`endif