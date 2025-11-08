module cla_logic_32bit #(
    parameter P_CLA_SIZE = 32
) (
    input  logic [(P_CLA_SIZE-1):0] propagate_i, // P signals
    input  logic [(P_CLA_SIZE-1):0] generate_i,  // G signals
    input  logic                    cin_i,       // Initial carry
    output logic [(P_CLA_SIZE-1):1] carry_o,     // Internal carries
    output logic                    cout_o       // Final carry
);
    logic [P_CLA_SIZE:0] carry;

    always_comb begin
        carry[0] = cin_i; // Procedural assignment instead of assign
        for (int i = 0; i < P_CLA_SIZE; i++) begin
            logic result;
            logic chain;

            result = generate_i[i];

            // Add terms: P[i]*G[i-1], P[i]*P[i-1]*G[i-2], ...
            for (int j = i-1; j >= 0; j--) begin
                chain = 1'b1;
                for (int k = i; k > j; k--) begin
                    chain &= propagate_i[k];
                end
                result |= (chain & generate_i[j]);
            end

            // Add final term: P[i]*P[i-1]*...*P[0]*cin
            chain = 1'b1;
            for (int k = i; k >= 0; k--) begin
                chain &= propagate_i[k];
            end
            result |= (chain & cin_i);

            carry[i+1] = result;
        end
    end

    assign carry_o = carry[(P_CLA_SIZE-1):1];
    assign cout_o  = carry[P_CLA_SIZE];
endmodule
