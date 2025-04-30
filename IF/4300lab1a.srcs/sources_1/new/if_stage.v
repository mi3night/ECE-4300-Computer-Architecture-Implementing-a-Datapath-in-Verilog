module if_stage(
    input         clk,
    input         reset,
    input         PCSrc,         // 0 = sequential, 1 = branch
    input  [31:0] branch_target, // Branch target address
    output [31:0] current_pc,    // For observation
    output [31:0] if_id_ir,      // Instruction fetched (latched in IF/ID)
    output [31:0] if_id_npc      // Next PC (PC+4, latched in IF/ID)
);
    wire [31:0] pc_next;
    wire [31:0] pc_current;
    wire [31:0] npc_candidate;
    wire [31:0] instruction;

    // PC register holds current PC.
    pc_reg PC(
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc(pc_current)
    );

    // Incrementer calculates PC+4.
    incr4 INCR(
        .in(pc_current),
        .out(npc_candidate)
    );

    // Mux selects sequential or branch target.
    mux2to1 MUX(
        .a(npc_candidate),
        .b(branch_target),
        .sel(PCSrc),
        .y(pc_next)
    );

    // Instruction memory fetch.
    inst_memory IM(
        .addr(pc_current[8:2]),
        .instruction(instruction)
    );

    // IF/ID pipeline register captures NPC and instruction.
    if_id_reg IF_ID(
        .clk(clk),
        .reset(reset),
        .npc_in(npc_candidate),
        .ir_in(instruction),
        .npc_out(if_id_npc),
        .ir_out(if_id_ir)
    );

    assign current_pc = pc_current;
endmodule
