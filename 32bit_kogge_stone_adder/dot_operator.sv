// Black cell: combines (Gk, Pk) with (Gj, Pj) to produce (Gout, Pout)
// Gout = Gk | (Pk & Gj)
// Pout = Pk & Pj
module dot_operator (
  input  logic Gk, Pk,
  input  logic Gj, Pj,
  output logic Gout, Pout
);
  assign Gout = Gk | (Pk & Gj);
  assign Pout = Pk & Pj;
endmodule

