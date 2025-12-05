module synopsys_adder (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        cin_i,
    output wire  [31:0] sum_o,
    output wire         cout_o
);

assign {cout_o, sum_o} = {1'b0, a_i} + {1'b0, b_i} + cin_i;

endmodule
