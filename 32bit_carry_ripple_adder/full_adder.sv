module full_adder (
    input  logic a_i    ,        
    input  logic b_i    ,        
    input  logic cin_i  ,      
    output logic sum_o  ,      
    output logic cout_o      
);

    // Sum = XOR of all three inputs
    assign sum_o  = a_i ^ b_i ^ cin_i;

    // Carry out = (a & b) OR (b & cin) OR (a & cin)
    assign cout_o = (a_i & b_i) | (b_i & cin_i) | (a_i & cin_i);

endmodule
