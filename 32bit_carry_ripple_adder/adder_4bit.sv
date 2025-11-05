module adder_4bit (
    input  logic [3:0] A_i    ,  // 4-bit input A
    input  logic [3:0] B_i    ,  // 4-bit input B
    input  logic       cin_i  ,  // Carry input 
    output logic [3:0] SUM_o  ,  // 4-bit sum output
    output logic       cout_o    // Final carry output
);
//HD:    logic c1, c2, c3; // Internal carry signals
//HD:    // Instantiate 4 full adders
//HD:    full_adder FA0 (.a_i(A_i[0]), .b_i(B_i[0]), .cin_i(cin_i), .sum(SUM_o[0]), .cout_o(c1));
//HD:    full_adder FA1 (.a_i(A_i[1]), .b_i(B_i[1]), .cin_i(c1)   , .sum(SUM_o[1]), .cout_o(c2));
//HD:    full_adder FA2 (.a_i(A_i[2]), .b_i(B_i[2]), .cin_i(c2)   , .sum(SUM_o[2]), .cout_o(c3));
//HD:    full_adder FA3 (.a_i(A_i[3]), .b_i(B_i[3]), .cin_i(c3)   , .sum(SUM_o[3]), .cout_o(cout_o));

    logic [4:0] carry; // Carry chain (carry[0] = cin_i)
    assign carry[0] = cin_i;
    
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : FA_LOOP
            full_adder FA (.a_i(A_i[i]), .b_i(B_i[i]), .cin_i(carry[i]), .sum_o(SUM_o[i]), .cout_o(carry[i+1]));
        end
    endgenerate

    assign cout_o = carry[4];

endmodule
