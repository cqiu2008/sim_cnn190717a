
`timescale 1 ns / 1 ps

  module cnna_mul_mul_18ns_13ns_31_1_1_DSP48_10(a, b, p);
input [18 - 1 : 0] a;
input [13 - 1 : 0] b;
output [31 - 1 : 0] p;

assign p = $unsigned (a) * $unsigned (b);

endmodule
`timescale 1 ns / 1 ps
module cnna_mul_mul_18ns_13ns_31_1_1(
    din0,
    din1,
    dout);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;
input[din0_WIDTH - 1:0] din0;
input[din1_WIDTH - 1:0] din1;
output[dout_WIDTH - 1:0] dout;



cnna_mul_mul_18ns_13ns_31_1_1_DSP48_10 cnna_mul_mul_18ns_13ns_31_1_1_DSP48_10_U(
    .a( din0 ),
    .b( din1 ),
    .p( dout ));

endmodule

