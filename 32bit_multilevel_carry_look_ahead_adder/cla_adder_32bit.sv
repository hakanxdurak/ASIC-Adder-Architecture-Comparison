module cla_adder_32bit (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        cin_i,
    output logic [31:0] sum_o,
    output logic        cout_o
);
    logic [1:0] P_block, G_block;
    logic [1:0] lookahead_carry; 
    
    genvar i;
    generate
        for (i = 0; i < 2; i++) begin 
            cla_adder_16bit CLA_ADDER_16BIT (
                .a_i   (a_i[(i*16)+15 : i*16]                  ),
                .b_i   (b_i[(i*16)+15 : i*16]                  ),
                .cin_i ((i == 0) ? cin_i : lookahead_carry[i-1]),
                .sum_o (sum_o[(i*16)+15 : i*16]                ),
                .cout_o(                                       ),
                .P_o   (P_block[i]                             ),
                .G_o   (G_block[i]                             )
            );
        end
    endgenerate

    cla_logic_2bit CLA_LOGIC_2BIT (
        .propagate_i(P_block        ),
        .generate_i (G_block        ),
        .carry_o    (lookahead_carry), 
        .cout_o     (cout_o         )
    );
endmodule
