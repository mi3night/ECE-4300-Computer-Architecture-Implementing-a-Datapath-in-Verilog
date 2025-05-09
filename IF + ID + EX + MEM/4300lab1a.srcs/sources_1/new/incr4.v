// Incrementer: Adds 4 to the 32-bit input
module incr4(
    input  [31:0] in,
    output [31:0] out
);
    assign out = in + 32'd4;
endmodule