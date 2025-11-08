module cla_adder_32bit (
    input  logic [31:0] a_i    , 
    input  logic [31:0] b_i    ,
    input  logic        cin_i  ,
    output logic [31:0] sum_o  ,
    output logic        cout_o 
);

    logic [31:0] carry;
    assign carry[0] = cin_i;

    logic [31:0] propagate_wire;
    logic [31:0] generate_wire;

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin 
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

    cla_logic_32bit CLA_LOGIC_32BIT(
      .propagate_i (propagate_wire),    
      .generate_i  (generate_wire ),    
      .cin_i       (cin_i         ),  
      .carry_o     (carry[31:1]   ),  
      .cout_o      (cout_o        )
    );

endmodule
