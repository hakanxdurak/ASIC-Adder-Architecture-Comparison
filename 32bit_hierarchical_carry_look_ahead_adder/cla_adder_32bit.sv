module cla_adder_32bit (
    input  logic [31:0] a_i    , 
    input  logic [31:0] b_i    ,
    input  logic        cin_i  ,
    output logic [31:0] sum_o  ,
    output logic        cout_o 
);

logic [32:0] carry;
assign carry[0] = cin_i;

genvar i;
generate
  for (i = 0; i < 32; i+=4) begin : CLA_LOOP
    cla_adder_4bit cla_adder_4bit_inst (
      .a_i   (a_i[(i+3):i]  ),      
      .b_i   (b_i[(i+3):i]  ),     
      .cin_i (carry[i]      ),       
      .sum_o (sum_o[(i+3):i]),     
      .cout_o(carry[i+4]    )
    );
  end
endgenerate

assign cout_o = carry[8];

endmodule
