module mem_wb_reg (
    input clk,
    input reset,
    input [1:0]  mem_wb_wb_ctl_in,
    input [31:0] mem_wb_alu_result_in,
    input [31:0] mem_wb_mem_read_data_in,
    input [4:0]  mem_wb_write_reg_in,
    output reg [1:0]  mem_wb_wb_ctl_out,
    output reg [31:0] mem_wb_alu_result_out,
    output reg [31:0] mem_wb_mem_read_data_out,
    output reg [4:0]  mem_wb_write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_wb_wb_ctl_out        <= 2'b00;
            mem_wb_alu_result_out    <= 32'd0;
            mem_wb_mem_read_data_out <= 32'd0;
            mem_wb_write_reg_out     <= 5'd0;
        end else begin
            mem_wb_wb_ctl_out        <= mem_wb_wb_ctl_in;
            mem_wb_alu_result_out    <= mem_wb_alu_result_in;
            mem_wb_mem_read_data_out <= mem_wb_mem_read_data_in;
            mem_wb_write_reg_out     <= mem_wb_write_reg_in;
        end
    end

endmodule
