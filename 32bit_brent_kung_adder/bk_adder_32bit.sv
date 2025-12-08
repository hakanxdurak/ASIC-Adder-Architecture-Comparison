module bk_adder_32bit (
  input  logic [31:0] a_i,
  input  logic [31:0] b_i,
  input  logic        cin_i,
  output logic [31:0] sum_o,
  output logic        cout_o
);
  // ---------------------------------------
  // Stage 0: bitwise generate/propagate
  // ---------------------------------------
  logic [31:0] g0, p0;
  assign g0 = a_i & b_i;
  assign p0 = a_i ^ b_i;

  // ---------------------------------------
  // Upsweep: compute partial prefixes at Brent–Kung nodes
  // ---------------------------------------
  // Span 1: nodes at odd indices
  logic [31:0] G1, P1;
  generate
    for (genvar i = 1; i < 32; i += 2) begin
      assign G1[i] = g0[i] | (p0[i] & g0[i-1]);
      assign P1[i] = p0[i] & p0[i-1];
    end
  endgenerate

  // Span 2: nodes at indices 3,7,11,...,31
  logic [31:0] G2, P2;
  generate
    for (genvar i = 3; i < 32; i += 4) begin
      assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
      assign P2[i] = P1[i] & P1[i-2];
    end
  endgenerate

  // Span 4: nodes at 7,15,23,31
  logic [31:0] G3, P3;
  generate
    for (genvar i = 7; i < 32; i += 8) begin
      assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
      assign P3[i] = P2[i] & P2[i-4];
    end
  endgenerate

  // Span 8: nodes at 15,31
  logic [31:0] G4, P4;
  generate
    for (genvar i = 15; i < 32; i += 16) begin
      assign G4[i] = G3[i] | (P3[i] & G3[i-8]);
      assign P4[i] = P3[i] & P3[i-8];
    end
  endgenerate

  // Span 16: node at 31 (root)
  logic [31:0] G5, P5;
  assign G5[31] = G4[31] | (P4[31] & G4[15]);
  assign P5[31] = P4[31] & P4[15];

  // ---------------------------------------
  // Down-sweep: distribute carries
  // ---------------------------------------
  logic [32:0] c;
  assign c[0] = cin_i;

  // Example pattern: each carry depends on nearest prefix ancestor
  // c1 = g0[0] | (p0[0] & c0)
  assign c[1] = g0[0] | (p0[0] & c[0]);

  generate
    for (genvar i = 1; i < 32; i++) begin
      if (i % 2 == 0) begin
        // even indices: gray cell from bit itself
        assign c[i+1] = g0[i] | (p0[i] & c[i]);
      end else begin
        // odd indices: use prefix from upsweep
        assign c[i+1] = G1[i] | (P1[i] & c[i-1]);
      end
    end
  endgenerate

  // Root carry out
  assign cout_o = G5[31] | (P5[31] & c[0]);

  // ---------------------------------------
  // Final sums
  // ---------------------------------------
  assign sum_o = p0 ^ c[31:0];

endmodule

