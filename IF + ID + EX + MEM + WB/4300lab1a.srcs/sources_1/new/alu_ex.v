module alu_ex (
    input [31:0] a, b,
    input [2:0] alu_control,
    output reg [31:0] result,
    output zero
);
    always @(*) begin
        case (alu_control)
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b111: result = (a < b) ? 32'd1 : 32'd0;
            default: result = 32'hxxxxxxxx;
        endcase
    end

    assign zero = (result == 0);
endmodule
