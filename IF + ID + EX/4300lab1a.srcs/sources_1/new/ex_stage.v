module ex_stage (
    input clk,
    input reset,

    input [1:0] id_ex_alu_op,
    input       id_ex_alu_src,
    input       id_ex_reg_dst,
    input [31:0] id_ex_pc_add4,
    input [31:0] id_ex_read_data1,
    input [31:0] id_ex_read_data2,
    input [31:0] id_ex_sign_ext,
    input [4:0]  id_ex_rt,
    input [4:0]  id_ex_rd,
    input [5:0]  id_ex_funct,

    input [1:0] id_ex_wb_ctl,
    input [2:0] id_ex_m_ctl,

    output [1:0] ex_mem_wb_ctl,
    output [2:0] ex_mem_m_ctl,
    output [31:0] ex_mem_pc_branch,
    output        ex_mem_zero,
    output [31:0] ex_mem_alu_result,
    output [31:0] ex_mem_write_data,
    output [4:0]  ex_mem_write_reg
);

    wire [2:0] alu_ctl_signal;
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire alu_zero;
    wire [4:0] dest_reg;
    wire [31:0] branch_target;

    alu_control_ex alu_ctrl (
        .alu_op(id_ex_alu_op),
        .funct(id_ex_funct),
        .alu_control(alu_ctl_signal)
    );

    mux2_ex #(32) mux_alu_src (
        .a(id_ex_read_data2),
        .b(id_ex_sign_ext),
        .sel(id_ex_alu_src),
        .y(alu_operand_b)
    );

    alu_ex alu (
        .a(id_ex_read_data1),
        .b(alu_operand_b),
        .alu_control(alu_ctl_signal),
        .result(alu_result),
        .zero(alu_zero)
    );

    mux2_ex #(5) mux_reg_dst (
        .a(id_ex_rt),
        .b(id_ex_rd),
        .sel(id_ex_reg_dst),
        .y(dest_reg)
    );

    assign branch_target = id_ex_pc_add4 + id_ex_sign_ext;

    ex_mem_reg EX_MEM (
        .clk(clk),
        .reset(reset),
        .ex_mem_wb_ctl_in(id_ex_wb_ctl),
        .ex_mem_m_ctl_in(id_ex_m_ctl),
        .ex_mem_pc_branch_in(branch_target),
        .ex_mem_zero_in(alu_zero),
        .ex_mem_alu_result_in(alu_result),
        .ex_mem_write_data_in(id_ex_read_data2),
        .ex_mem_write_reg_in(dest_reg),
        .ex_mem_wb_ctl_out(ex_mem_wb_ctl),
        .ex_mem_m_ctl_out(ex_mem_m_ctl),
        .ex_mem_pc_branch_out(ex_mem_pc_branch),
        .ex_mem_zero_out(ex_mem_zero),
        .ex_mem_alu_result_out(ex_mem_alu_result),
        .ex_mem_write_data_out(ex_mem_write_data),
        .ex_mem_write_reg_out(ex_mem_write_reg)
    );

endmodule
