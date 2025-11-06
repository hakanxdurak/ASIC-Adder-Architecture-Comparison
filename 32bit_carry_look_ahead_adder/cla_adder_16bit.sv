module cla_adder_16bit (
    input  logic [15:0] a_i   ,
    input  logic [15:0] b_i   ,
    input  logic        cin_i ,
    output logic        P_o   ,
    output logic        G_o   ,
    output logic [15:0] sum_o ,
    output logic        cout_o
);

    logic [3:0] P_block, G_block;
    logic [3:1] lookahead_carry; // from CLA logic

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : CLA_BLOCKS
            cla_adder_4bit CLA_ADDER_4BIT (
                .a_i    (a_i[(i*4)+3 : i*4]                   ),
                .b_i    (b_i[(i*4)+3 : i*4]                   ),
                .cin_i  ((i == 0) ? cin_i : lookahead_carry[i]),
                .sum_o  (sum_o[(i*4)+3 : i*4]                 ),
                .cout_o (                                     ),
                .P_o    (P_block[i]                           ),
                .G_o    (G_block[i]                           )
            );
        end
    endgenerate

    cla_logic_4bit CLA_LOGIC_4BIT (
        .propagate_i (P_block         ),
        .generate_i  (G_block         ),
        .cin_i       (cin_i           ),
        .carry_o     (lookahead_carry ), 
        .P_o         (P_o             ),
        .G_o         (G_o             ),
        .cout_o      (cout_o          )
    );

endmodule
