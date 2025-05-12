module if_id_reg(
    input         clk,
    input         reset,
    input  [31:0] npc_in,
    input  [31:0] ir_in,
    output reg [31:0] npc_out,
    output reg [31:0] ir_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            npc_out <= 32'd0;
            ir_out  <= 32'd0;
        end else begin
            npc_out <= npc_in + 4;
            ir_out  <= ir_in;
        end
    end
endmodule