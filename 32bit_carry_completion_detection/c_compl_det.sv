module c_compl_det (
    input  logic [31:0] A_i,       // 32-bit input A
    input  logic [31:0] B_i,       // 32-bit input B
    input  logic        cin_i,     // Initial carry input
    output logic [31:0] SUM_o,     // 32-bit sum output
    output logic        cout_o     // Final carry output
);

logic [31:0] SUM_wire;
logic [32:0] no_carry; // No carry chain
logic [32:0] carry;    // Carry chain
logic [31:0] d;        // 
logic alldone;

always_comb begin
    no_carry[0] = ~cin_i;
    carry[0] = cin_i;
    for (int i = 0; i < 32; i++) begin
       // Sum calculation
       SUM_wire[i] = A_i[i] ^ B_i[i] ^ carry[i];
       
        //No carry propagation
        no_carry[i+1] = (~(A_i[i] | B_i[i])) || (no_carry[i] && ~(A_i[i] & B_i[i]));

        //Carry propagation
        carry[i+1] = (A_i[i] & B_i[i]) || (carry[i] && (A_i[i] | B_i[i]));

        d[i] = (no_carry[i+1] || carry[i+1]);
    end
end 

assign alldone = &d;

assign SUM_o = alldone ? SUM_wire : 32'h0000_0000;
assign cout_o = alldone ? carry[32] : 1'b0;

endmodule

