module adder_8bit (
    input  logic [7:0] A_i    , // 8-bit input A
    input  logic [7:0] B_i    , // 8-bit input B
    input  logic       cin_i  , // Initial carry input
    output logic [7:0] SUM_o  , // 8-bit sum output
    output logic       cout_o   // Final carry output
);
    logic carry_mid; // Carry between the two 4-bit adders

    // Lower 4 bits
    adder_4bit ADDER_4BIT_LOW (
        .A_i   (A_i[3:0]  ),
        .B_i   (B_i[3:0]  ),
        .cin_i (cin_i     ),
        .SUM_o (SUM_o[3:0]),
        .cout_o(carry_mid )
    );

    // Upper 4 bits
    adder_4bit ADDER_4BIT_HIGH (
        .A_i   (A_i[7:4]  ),
        .B_i   (B_i[7:4]  ),
        .cin_i (carry_mid ),
        .SUM_o (SUM_o[7:4]),
        .cout_o(cout_o    )
    );

endmodule
