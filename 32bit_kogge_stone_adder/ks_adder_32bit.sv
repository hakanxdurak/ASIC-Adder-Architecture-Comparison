module ks_adder_32bit (
  input  logic [31:0] a_i,
  input  logic [31:0] b_i,
  input  logic        cin_i,
  output logic [31:0] sum_o,
  output logic        cout_o
);
  // ---------------------------------------
  // Stage 0
  // ---------------------------------------
  logic [31:0] g0, p0;
  assign g0 = a_i & b_i;    // generate
  assign p0 = a_i ^ b_i;    // propagate

  // ---------------------------------------
  // Prefix arrays for each stage 
  // ---------------------------------------
  logic [31:0] G1, P1;  // span 1
  logic [31:0] G2, P2;  // span 2
  logic [31:0] G3, P3;  // span 4
  logic [31:0] G4, P4;  // span 8
  logic [31:0] G5, P5;  // span 16

  // ---------------------------------------
  // Stage 1
  // ---------------------------------------
  // bit 0 passes through
  assign G1[0] = g0[0];
  assign P1[0] = p0[0];
  // bits 1..31
  generate
    for (genvar i = 1; i < 32; i++) begin : s1
      dot_operator d_o (
        .Gk   (g0[i]),
        .Pk   (p0[i]),
        .Gj   (g0[i-1]),
        .Pj   (p0[i-1]),
        .Gout (G1[i]),
        .Pout (P1[i])
      );
    end
  endgenerate

  // ---------------------------------------
  // Stage 2
  // ---------------------------------------
  assign G2[0] = G1[0]; assign P2[0] = P1[0];
  assign G2[1] = G1[1]; assign P2[1] = P1[1];
  generate
    for (genvar i = 2; i < 32; i++) begin : s2
      dot_operator d_o (
        .Gk   (G1[i]),
        .Pk   (P1[i]),
        .Gj   (G1[i-2]),
        .Pj   (P1[i-2]),
        .Gout (G2[i]),
        .Pout (P2[i])
      );
    end
  endgenerate

  // ---------------------------------------
  // Stage 3
  // ---------------------------------------
  assign G3[0] = G2[0]; assign P3[0] = P2[0];
  assign G3[1] = G2[1]; assign P3[1] = P2[1];
  assign G3[2] = G2[2]; assign P3[2] = P2[2];
  assign G3[3] = G2[3]; assign P3[3] = P2[3];
  generate
    for (genvar i = 4; i < 32; i++) begin : s3
      dot_operator d_o (
        .Gk   (G2[i]),
        .Pk   (P2[i]),
        .Gj   (G2[i-4]),
        .Pj   (P2[i-4]),
        .Gout (G3[i]),
        .Pout (P3[i])
      );
    end
  endgenerate

  // ---------------------------------------
  // Stage 4
  // ---------------------------------------
  assign G4[0] = G3[0]; assign P4[0] = P3[0];
  assign G4[1] = G3[1]; assign P4[1] = P3[1];
  assign G4[2] = G3[2]; assign P4[2] = P3[2];
  assign G4[3] = G3[3]; assign P4[3] = P3[3];
  assign G4[4] = G3[4]; assign P4[4] = P3[4];
  assign G4[5] = G3[5]; assign P4[5] = P3[5];
  assign G4[6] = G3[6]; assign P4[6] = P3[6];
  assign G4[7] = G3[7]; assign P4[7] = P3[7];
  generate
    for (genvar i = 8; i < 32; i++) begin : s4
      dot_operator d_o (
        .Gk   (G3[i]),
        .Pk   (P3[i]),
        .Gj   (G3[i-8]),
        .Pj   (P3[i-8]),
        .Gout (G4[i]),
        .Pout (P4[i])
      );
    end
  endgenerate

  // ---------------------------------------
  // Stage 5
  // ---------------------------------------
  assign G5[0]  = G4[0];  assign P5[0]  = P4[0];
  assign G5[1]  = G4[1];  assign P5[1]  = P4[1];
  assign G5[2]  = G4[2];  assign P5[2]  = P4[2];
  assign G5[3]  = G4[3];  assign P5[3]  = P4[3];
  assign G5[4]  = G4[4];  assign P5[4]  = P4[4];
  assign G5[5]  = G4[5];  assign P5[5]  = P4[5];
  assign G5[6]  = G4[6];  assign P5[6]  = P4[6];
  assign G5[7]  = G4[7];  assign P5[7]  = P4[7];
  assign G5[8]  = G4[8];  assign P5[8]  = P4[8];
  assign G5[9]  = G4[9];  assign P5[9]  = P4[9];
  assign G5[10] = G4[10]; assign P5[10] = P4[10];
  assign G5[11] = G4[11]; assign P5[11] = P4[11];
  assign G5[12] = G4[12]; assign P5[12] = P4[12];
  assign G5[13] = G4[13]; assign P5[13] = P4[13];
  assign G5[14] = G4[14]; assign P5[14] = P4[14];
  assign G5[15] = G4[15]; assign P5[15] = P4[15];
  generate
    for (genvar i = 16; i < 32; i++) begin : s5
      dot_operator d_o (
        .Gk   (G4[i]),
        .Pk   (P4[i]),
        .Gj   (G4[i-16]),
        .Pj   (P4[i-16]),
        .Gout (G5[i]),
        .Pout (P5[i])
      );
    end
  endgenerate

  // ---------------------------------------
  // Carries 
  // ---------------------------------------
  logic [32:0] c;
  assign c[0] = cin_i;

  generate
    for (genvar i = 0; i < 32; i++) begin : carries
      dot_operator d_o (
        .Gk   (G5[i]),
        .Pk   (P5[i]),
        .Gj   (cin_i),
        .Pj   (1'b0),
        .Gout (c[i+1]),
        .Pout ()
      );
    end
  endgenerate

  // ---------------------------------------
  // Final sums and cout_o
  // ---------------------------------------
  generate
    for (genvar i = 0; i < 32; i++) begin : sums
      assign sum_o[i] = p0[i] ^ c[i];
    end
  endgenerate

  assign cout_o = c[32];

endmodule
