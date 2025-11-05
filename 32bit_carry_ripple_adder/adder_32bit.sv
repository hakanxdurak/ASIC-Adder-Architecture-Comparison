module adder_32bit (
    input  logic [31:0] A_i,       // 32-bit input A
    input  logic [31:0] B_i,       // 32-bit input B
    input  logic        cin_i,     // Initial carry input
    output logic [31:0] SUM_o,     // 32-bit sum output
    output logic        cout_o     // Final carry output
);
    logic carry_mid; // Carry between the two 16-bit adders

    // Lower 16 bits
    adder_16bit ADDER_16BIT_LOW (
        .A_i   (A_i[15:0]  ),
        .B_i   (B_i[15:0]  ),
        .cin_i (cin_i      ),
        .SUM_o (SUM_o[15:0]),
        .cout_o(carry_mid  )
    );

    // Upper 16 bits
    adder_16bit ADDER_16BIT_HIGH (
        .A_i   (A_i[31:16]  ),
        .B_i   (B_i[31:16]  ),
        .cin_i (carry_mid   ),
        .SUM_o (SUM_o[31:16]),
        .cout_o(cout_o      )
    );

endmodule
