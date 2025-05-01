module ex_mem_reg (
    input clk,
    input reset,

    input [1:0] ex_mem_wb_ctl_in,
    input [2:0] ex_mem_m_ctl_in,
    input [31:0] ex_mem_pc_branch_in,
    input        ex_mem_zero_in,
    input [31:0] ex_mem_alu_result_in,
    input [31:0] ex_mem_write_data_in,
    input [4:0]  ex_mem_write_reg_in,

    output reg [1:0] ex_mem_wb_ctl_out,
    output reg [2:0] ex_mem_m_ctl_out,
    output reg [31:0] ex_mem_pc_branch_out,
    output reg        ex_mem_zero_out,
    output reg [31:0] ex_mem_alu_result_out,
    output reg [31:0] ex_mem_write_data_out,
    output reg [4:0]  ex_mem_write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_mem_wb_ctl_out      <= 2'b00;
            ex_mem_m_ctl_out       <= 3'b000;
            ex_mem_pc_branch_out   <= 32'd0;
            ex_mem_zero_out        <= 1'b0;
            ex_mem_alu_result_out  <= 32'd0;
            ex_mem_write_data_out  <= 32'd0;
            ex_mem_write_reg_out   <= 5'd0;
        end else begin
            ex_mem_wb_ctl_out      <= ex_mem_wb_ctl_in;
            ex_mem_m_ctl_out       <= ex_mem_m_ctl_in;
            ex_mem_pc_branch_out   <= ex_mem_pc_branch_in;
            ex_mem_zero_out        <= ex_mem_zero_in;
            ex_mem_alu_result_out  <= ex_mem_alu_result_in;
            ex_mem_write_data_out  <= ex_mem_write_data_in;
            ex_mem_write_reg_out   <= ex_mem_write_reg_in;
        end
    end

endmodule
