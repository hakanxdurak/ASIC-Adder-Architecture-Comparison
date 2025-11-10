module cs_adder_32bit #(
  parameter TOTAL_WIDTH = 32,
  parameter NIBBLE_SIZE = 4
)(
  input  logic [TOTAL_WIDTH-1:0] a_i,
  input  logic [TOTAL_WIDTH-1:0] b_i,
  input  logic                   cin_i,
  output logic [TOTAL_WIDTH-1:0] sum_o,
  output logic                   cout_o
);

  localparam NUM_BLOCKS = TOTAL_WIDTH / NIBBLE_SIZE;

  // Carry chain
  logic [NUM_BLOCKS:0] carry;
  assign carry[0] = cin_i;

  // Intermediate sums and carries for carry-select blocks
  logic [NUM_BLOCKS-1:0][NIBBLE_SIZE-1:0] sum0, sum1;
  logic [NUM_BLOCKS-1:0] carry0, carry1;

  genvar i;
  generate
    for (i = 0; i < NUM_BLOCKS; i++) begin : BLOCK
      if (i == 0) begin
        // First block: simple CLA
        cla_adder_4bit LO4 (
          .a_i   (a_i[NIBBLE_SIZE-1:0]  ),
          .b_i   (b_i[NIBBLE_SIZE-1:0]  ),
          .cin_i (carry[0]              ),
          .sum_o (sum_o[NIBBLE_SIZE-1:0]),
          .cout_o(carry[1]              )
        );
      end else begin
        // Carry-select block for upper parts
        cs_logic #(.NIBBLE_SIZE(NIBBLE_SIZE)) cs_logic_inst (
          .a_i            (a_i[(i*NIBBLE_SIZE)+:NIBBLE_SIZE]),
          .b_i            (b_i[(i*NIBBLE_SIZE)+:NIBBLE_SIZE]),
          .h0_nibble_sum  (sum0[i]                          ),
          .h1_nibble_sum  (sum1[i]                          ),
          .h0_nibble_carry(carry0[i]                        ),
          .h1_nibble_carry(carry1[i]                        )
        );

        // Mux logic for sum and carry based on previous carry
        always_comb begin
          if (carry[i]) begin
            sum_o[(i*NIBBLE_SIZE)+:NIBBLE_SIZE] = sum1[i];
            carry[i+1] = carry1[i];
          end else begin
            sum_o[(i*NIBBLE_SIZE)+:NIBBLE_SIZE] = sum0[i];
            carry[i+1] = carry0[i];
          end
        end
      end
    end
  endgenerate

  assign cout_o = carry[NUM_BLOCKS];

endmodule
