module id_stage(
    input         clk,
    input         reset,
    input  [31:0] npc,    
    input  [31:0] instr,  // Instruction from IF stage
    // Outputs to the EX stage
    output [31:0] id_ex_npc,
    output [31:0] regData1,
    output [31:0] regData2,
    output [31:0] signExt,
    output [4:0]  rt,
    output [4:0]  rd,
    output [8:0]  control
);
    // Extract fields from the instruction
    wire [5:0] opcode;
    wire [4:0] rs, rt_field, rd_field;
    wire [15:0] immediate;
    assign opcode    = instr[31:26];
    assign rs        = instr[25:21];
    assign rt_field  = instr[20:16];
    assign rd_field  = instr[15:11];
    assign immediate = instr[15:0];
    
    wire [8:0] control_signals;
    // Generate control signals based on the opcode
    control_unit CU(
        .opcode(opcode),
        .control(control_signals)
    );
    
    // Read registers using rs and rt fields.
    // (For this lab, no writeback is performed, so regWrite is set to 0.)
    wire [31:0] readData1, readData2;
    reg_file RF(
        .clk(clk),
        .regWrite(1'b0),
        .readReg1(rs),
        .readReg2(rt_field),
        .writeReg(5'd0),
        .writeData(32'd0),
        .readData1(readData1),
        .readData2(readData2)
    );
    
    // Sign extend the immediate field
    wire [31:0] imm_ext;
    sign_extend SE(
        .imm(immediate),
        .imm_ext(imm_ext)
    );
    
    // Latch all signals into the ID/EX pipeline register
    id_ex_reg ID_EX(
        .clk(clk),
        .reset(reset),
        .npc_in(npc),
        .regData1_in(readData1),
        .regData2_in(readData2),
        .signExt_in(imm_ext),
        .rt_in(rt_field),
        .rd_in(rd_field),
        .control_in(control_signals),
        .npc_out(id_ex_npc),
        .regData1_out(regData1),
        .regData2_out(regData2),
        .signExt_out(signExt),
        .rt_out(rt),
        .rd_out(rd),
        .control_out(control)
    );
endmodule
