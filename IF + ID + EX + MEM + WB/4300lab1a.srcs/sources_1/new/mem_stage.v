module mem_stage (
    input clk,
    input reset,

    // From EX/MEM pipeline
    input [1:0]  ex_mem_wb_ctl,
    input [2:0]  ex_mem_m_ctl,
    input        ex_mem_zero,
    input [31:0] ex_mem_alu_result,
    input [31:0] ex_mem_write_data,
    input [4:0]  ex_mem_write_reg,
    input [31:0] ex_mem_pc_branch,

    // To IF stage
    output       PCSrc,
    output [31:0] branch_target,

    // To WB stage (via MEM/WB latch)
    output [1:0]  mem_wb_wb_ctl,
    output [31:0] mem_wb_alu_result,
    output [31:0] mem_wb_mem_read_data,
    output [4:0]  mem_wb_write_reg
);

    wire branch   = ex_mem_m_ctl[2];
    wire memread  = ex_mem_m_ctl[1];
    wire memwrite = ex_mem_m_ctl[0];
    wire zero = ex_mem_zero;

    wire [31:0] read_data;
    assign branch_target = ex_mem_pc_branch;

    // AND gate for branch decision
    mem_and_gate branch_and (
        .a(branch),
        .b(zero),
        .y(PCSrc)
    );

    // Data memory submodule
    data_memory data_mem_block (
        .clk(clk),
        .memread(memread),
        .memwrite(memwrite),
        .addr(ex_mem_alu_result),
        .writedata(ex_mem_write_data),
        .readdata(read_data)
    );

    // MEM/WB register submodule
    mem_wb_reg mem_wb_latch (
        .clk(clk),
        .reset(reset),
        .mem_wb_wb_ctl_in(ex_mem_wb_ctl),
        .mem_wb_alu_result_in(ex_mem_alu_result),
        .mem_wb_mem_read_data_in(read_data),
        .mem_wb_write_reg_in(ex_mem_write_reg),
        .mem_wb_wb_ctl_out(mem_wb_wb_ctl),
        .mem_wb_alu_result_out(mem_wb_alu_result),
        .mem_wb_mem_read_data_out(mem_wb_mem_read_data),
        .mem_wb_write_reg_out(mem_wb_write_reg)
    );

endmodule
