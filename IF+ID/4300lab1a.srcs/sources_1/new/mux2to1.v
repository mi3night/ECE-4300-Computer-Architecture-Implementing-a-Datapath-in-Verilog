// 2-to-1 Multiplexer for 32-bit Data
// If sel == 0, output = a; if sel == 1, output = b.
module mux2to1(
    input  [31:0] a,
    input  [31:0] b,
    input         sel,
    output [31:0] y
);
    assign y = sel ? b : a;
endmodule