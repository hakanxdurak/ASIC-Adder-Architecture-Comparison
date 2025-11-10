module cs_logic #(
  parameter NIBBLE_SIZE = 4
)(
  input  logic [NIBBLE_SIZE-1:0] a_i,
  input  logic [NIBBLE_SIZE-1:0] b_i,
  output logic [NIBBLE_SIZE-1:0] h0_nibble_sum,
  output logic [NIBBLE_SIZE-1:0] h1_nibble_sum,
  output logic                   h0_nibble_carry,
  output logic                   h1_nibble_carry
);

  cla_adder_4bit HI4_0 (
    .a_i   (a_i            ), 
    .b_i   (b_i            ), 
    .cin_i (1'b0           ),
    .sum_o (h0_nibble_sum  ), 
    .cout_o(h0_nibble_carry)
  );

  cla_adder_4bit HI4_1 (
    .a_i   (a_i            ), 
    .b_i   (b_i            ), 
    .cin_i (1'b1           ),
    .sum_o (h1_nibble_sum  ), 
    .cout_o(h1_nibble_carry)
  );

endmodule
