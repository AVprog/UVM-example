`ifndef TEST_1011_TB
`define TEST_1011_TB

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "test_1011.sv"
//`include "base_test.sv"
//`include "agent.sv"
//`include "env.sv"
//`include "gen_item_seq.sv"
//`include "scoreboard.sv"
//`include "item.sv"


module tb;
  reg clk;
  
  always #10 clk =~ clk;
  des_if _if (clk);
	
	det_1011 u0 	( .clk(clk),
                     .rstn(_if.rstn),
                     .in(_if.in),
                     .out(_if.out));
  
  
  initial begin
    clk <= 0;
    uvm_config_db#(virtual des_if)::set(null, "uvm_test_top", "des_vif", _if);
    run_test("test_1011");
  end
endmodule

`endif