module id_ex_reg(
    input         clk,
    input         reset,
    input  [31:0] npc_in,
    input  [31:0] regData1_in,
    input  [31:0] regData2_in,
    input  [31:0] signExt_in,
    input  [4:0]  rt_in,
    input  [4:0]  rd_in,
    input  [8:0]  control_in,
    output reg [31:0] npc_out,
    output reg [31:0] regData1_out,
    output reg [31:0] regData2_out,
    output reg [31:0] signExt_out,
    output reg [4:0]  rt_out,
    output reg [4:0]  rd_out,
    output reg [8:0]  control_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            npc_out      <= 32'd0;
            regData1_out <= 32'd0;
            regData2_out <= 32'd0;
            signExt_out  <= 32'd0;
            rt_out       <= 5'd0;
            rd_out       <= 5'd0;
            control_out  <= 9'd0;
        end else begin
            npc_out      <= npc_in;
            regData1_out <= regData1_in;
            regData2_out <= regData2_in;
            signExt_out  <= signExt_in;
            rt_out       <= rt_in;
            rd_out       <= rd_in;
            control_out  <= control_in;
        end
    end
endmodule
