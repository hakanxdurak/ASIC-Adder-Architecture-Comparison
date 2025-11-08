module cla_logic_2bit (
    input  logic [1:0] propagate_i, // P signals
    input  logic [1:0] generate_i,  // G signals
    output logic [1:0] carry_o,     // Internal carries
    output logic       cout_o       // Final carry
);
    logic [2:0] carry;

    always_comb begin
        carry[0] = 1'b0; // Initial carry is zero

        // Full CLA formula for 2 bits:
        // C1 = G0 + P0*C0
        carry[1] = generate_i[0] |
                   (propagate_i[0] & carry[0]);

        // C2 = G1 + P1*G0 + P1*P0*C0
        carry[2] = generate_i[1] |
                   (propagate_i[1] & generate_i[0]) |
                   (propagate_i[1] & propagate_i[0] & carry[0]);
    end

    assign carry_o = carry[2:1];
    assign cout_o  = carry[2];
endmodule
