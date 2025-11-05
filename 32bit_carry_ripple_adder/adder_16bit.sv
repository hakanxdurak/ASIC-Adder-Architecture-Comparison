module adder_16bit (
    input  logic [15:0] A_i,       // 16-bit input A
    input  logic [15:0] B_i,       // 16-bit input B
    input  logic        cin_i,     // Initial carry input
    output logic [15:0] SUM_o,     // 16-bit sum output
    output logic        cout_o     // Final carry output
);
    logic carry_mid; // Carry between the two 8-bit adders

    // Lower 8 bits
    adder_8bit ADDER_8BIT_LOW (
        .A_i   (A_i[7:0]  ),
        .B_i   (B_i[7:0]  ),
        .cin_i (cin_i     ),
        .SUM_o (SUM_o[7:0]),
        .cout_o(carry_mid )
    );

    // Upper 8 bits
    adder_8bit ADDER_8BIT_HIGH (
        .A_i   (A_i[15:8]  ),
        .B_i   (B_i[15:8]  ),
        .cin_i (carry_mid  ),
        .SUM_o (SUM_o[15:8]),
        .cout_o(cout_o     )
    );

endmodule
