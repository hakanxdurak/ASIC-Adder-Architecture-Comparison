module ling_adder_32bit (
    input  logic [31:0] A_i,       // 32-bit input A
    input  logic [31:0] B_i,       // 32-bit input B
    input  logic        cin_i,     // Carry-in (h[-1])
    output logic [31:0] SUM_o,     // 32-bit sum
    output logic        cout_o     // Carry-out
);

    // Bit-local signals
    logic [31:0] g;  // generate  = A & B
    logic [31:0] p;  // propagate = A ^ B
    logic [31:0] t;  // transmit  = A | B

    // Ling pseudo-carry h[i] equals carry-out of bit i
    logic [31:0] h;

    // Helper (previous pseudo-carry)
    logic       h_prev;

    always_comb begin
        // Local bit 
        for (int i = 0; i < 32; i++) begin
            g[i] = A_i[i] & B_i[i];
            p[i] = A_i[i] ^ B_i[i];
            t[i] = A_i[i] | B_i[i];
        end

        // Seed: h[-1] = cin_i
        h_prev = cin_i;

        // Prefix (pseudo-carry) and sum
        for (int i = 0; i < 32; i++) begin
            // Ling recurrence: h[i] = g[i] | (t[i] & h[i-1])
            h[i]     = g[i] | (t[i] & h_prev);

            // Sum uses h[i-1]
            SUM_o[i] = p[i] ^ h_prev;

            // advance
            h_prev   = h[i];
        end

        // Final carry-out is h[31]
        cout_o = h[31];
    end

endmodule
