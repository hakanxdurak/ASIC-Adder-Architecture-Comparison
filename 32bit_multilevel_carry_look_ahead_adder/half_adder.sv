module half_adder (
    input  logic a_i     ,       
    input  logic b_i     ,       
    output logic sum_o   ,     
    output logic cout_o    
);

    // Sum is XOR of inputs
    assign sum_o   = a_i ^ b_i;

    // Carry is AND of inputs
    assign cout_o = a_i & b_i;

endmodule
