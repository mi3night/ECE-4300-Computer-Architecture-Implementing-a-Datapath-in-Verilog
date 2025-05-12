module wb_stage (
    input [1:0]  mem_wb_wb_ctl,
    input [31:0] mem_wb_mem_read_data,
    input [31:0] mem_wb_alu_result,
    input [4:0]  mem_wb_write_reg,

    output       regwrite_wb,
    output [4:0] write_reg_wb,
    output [31:0] write_data_wb
);

    wire regwrite   = mem_wb_wb_ctl[1];
    wire memtoreg   = mem_wb_wb_ctl[0];

    assign regwrite_wb    = regwrite;
    assign write_reg_wb   = mem_wb_write_reg;
    assign write_data_wb  = memtoreg ? mem_wb_mem_read_data : mem_wb_alu_result;

endmodule
