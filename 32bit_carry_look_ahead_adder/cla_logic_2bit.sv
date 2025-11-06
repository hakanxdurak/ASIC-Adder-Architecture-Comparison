module cla_logic_2bit (
    input  logic [1:0] propagate_i,
    input  logic [1:0] generate_i ,
    input  logic       cin_i      ,
    output logic [1:0] carry_o    ,  
    output logic       cout_o
);
    logic [2:0] carry;
    assign carry[0] = cin_i;

    genvar i;
    generate
        for (i = 0; i < 2; i++) begin : CLA_LOOP
            assign carry[i+1] = generate_i[i] || (propagate_i[i] && carry[i]);
        end
    endgenerate

    assign carry_o = carry[2:1]; 
    assign cout_o  = carry[2];

endmodule
