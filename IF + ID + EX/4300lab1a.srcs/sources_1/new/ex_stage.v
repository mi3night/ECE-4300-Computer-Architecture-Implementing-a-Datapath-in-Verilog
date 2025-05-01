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

    output reg [31:0] ex_mem_pc_branch,
    output reg        ex_mem_zero,
    output reg [31:0] ex_mem_alu_result,
    output reg [31:0] ex_mem_write_data,
    output reg [4:0]  ex_mem_write_reg
);

    wire [2:0] alu_ctl_signal;
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire alu_zero;
    wire [4:0] dest_reg;

    alu_control_ex u_alu_control (
        .alu_op(id_ex_alu_op),
        .funct(id_ex_funct),
        .alu_control(alu_ctl_signal)
    );

    mux2_ex #(32) u_mux_alu_src (
        .a(id_ex_read_data2),
        .b(id_ex_sign_ext),
        .sel(id_ex_alu_src),
        .y(alu_operand_b)
    );

    alu_ex u_alu (
        .a(id_ex_read_data1),
        .b(alu_operand_b),
        .alu_control(alu_ctl_signal),
        .result(alu_result),
        .zero(alu_zero)
    );

    mux2_ex #(5) u_mux_reg_dst (
        .a(id_ex_rt),
        .b(id_ex_rd),
        .sel(id_ex_reg_dst),
        .y(dest_reg)
    );

    wire [31:0] branch_target = id_ex_pc_add4 + id_ex_sign_ext;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_mem_pc_branch    <= 0;
            ex_mem_zero         <= 0;
            ex_mem_alu_result   <= 0;
            ex_mem_write_data   <= 0;
            ex_mem_write_reg    <= 0;
        end else begin
            ex_mem_pc_branch    <= branch_target;
            ex_mem_zero         <= alu_zero;
            ex_mem_alu_result   <= alu_result;
            ex_mem_write_data   <= id_ex_read_data2;
            ex_mem_write_reg    <= dest_reg;
        end
    end

endmodule
