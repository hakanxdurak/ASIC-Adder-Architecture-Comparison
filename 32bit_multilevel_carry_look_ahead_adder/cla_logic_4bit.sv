module cla_logic_4bit (
    input  logic [3:0] propagate_i ,     
    input  logic [3:0] generate_i  ,     
    input  logic       cin_i       ,
    output logic       P_o         ,
    output logic       G_o         ,
    output logic [3:1] carry_o     ,       
    output logic       cout_o             
);
    logic [4:0] carry;
    assign carry[0] = cin_i;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : CLA_LOOP
            assign carry[i+1] = generate_i[i] || (propagate_i[i] && carry[i]);
        end
    endgenerate
   
//HD:    assign P_o = &propagate_i;
    assign P_o = propagate_i[3] && propagate_i[2] && propagate_i[1] && propagate_i[0];
    assign G_o = generate_i[3] || 
                 (propagate_i[3] && generate_i[2]) || 
                 (propagate_i[3] && propagate_i[2] && generate_i[1]) || 
                 (propagate_i[3] && propagate_i[2] && propagate_i[1] && propagate_i[0] && generate_i[0]); 

    assign carry_o = carry[3:1];
    assign cout_o = carry[4];

endmodule
