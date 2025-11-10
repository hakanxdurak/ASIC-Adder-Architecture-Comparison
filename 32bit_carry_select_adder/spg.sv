module spg (
    input  logic a_i         ,       
    input  logic b_i         ,       
    input  logic carry_i     ,       
    output logic propagate_o ,     
    output logic generate_o  ,     
    output logic sum_o         
);
  half_adder HA (.a_i(a_i), .b_i(b_i), .sum_o(propagate_o), .cout_o(generate_o));
  
  // Sum is XOR of inputs
  assign sum_o = propagate_o ^ carry_i;

endmodule
