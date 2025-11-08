module cla_adder_4bit (
    input  logic [3:0] a_i    , 
    input  logic [3:0] b_i    ,
    input  logic       cin_i  ,
    output logic       P_o    ,   
    output logic       G_o    ,   
    output logic [3:0] sum_o  ,
    output logic       cout_o 
);
    logic [3:0] carry;
    assign carry[0] = cin_i;

    logic [3:0] propagate_wire;
    logic [3:0] generate_wire;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin 
            spg SPG (
              .a_i         (a_i[i]           ),          
              .b_i         (b_i[i]           ),    
              .carry_i     (carry[i]         ),    
              .propagate_o (propagate_wire[i]),      
              .generate_o  (generate_wire[i] ),      
              .sum_o       (sum_o[i]         )
            );
        end
    endgenerate

    cla_logic_4bit CLA_4BIT(
      .propagate_i (propagate_wire),    
      .generate_i  (generate_wire ),    
      .cin_i       (cin_i         ),  
      .carry_o     (carry[3:1]    ),  
      .cout_o      (cout_o        ),
      .P_o         (P_o           ),
      .G_o         (G_o           )
    );

endmodule
