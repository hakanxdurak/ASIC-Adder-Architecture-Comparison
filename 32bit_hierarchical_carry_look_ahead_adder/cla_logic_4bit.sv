module cla_logic_4bit #(
    parameter N = 4
) (
    input  logic [N-1:0] propagate_i, // P signals
    input  logic [N-1:0] generate_i,  // G signals
    input  logic         cin_i,       // Initial carry
    output logic         P_o,         // Block propagate
    output logic         G_o,         // Block generate
    output logic [N-1:1] carry_o,     // Internal carries
    output logic         cout_o       // Final carry
);
    logic [N:0] carry;

    always_comb begin
        carry[0] = cin_i;

        // Compute all carries using full CLA formula
        for (int i = 0; i < N; i++) begin
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

    assign carry_o = carry[N-1:1];
    assign cout_o  = carry[N];
endmodule
