module if_stage(
    input         clk,
    input         reset,
    input         PCSrc,         // Control signal (0 = sequential, 1 = branch)
    input  [31:0] branch_target, // Branch target address (used if PCSrc == 1)
    output [31:0] current_pc,    // Current PC value (for observation)
    output [31:0] if_id_ir,      // Instruction fetched (latched in IF/ID)
    output [31:0] if_id_npc      // Next PC value (PC+4, latched in IF/ID)
);
    wire [31:0] pc_next;        // Next PC value from mux
    wire [31:0] pc_current;     // Current PC from PC register
    wire [31:0] npc_candidate;  // PC + 4 computed by the incrementer
    wire [31:0] instruction;    // Instruction from memory

    // PC Register: holds current PC value
    pc_reg PC(
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc(pc_current)
    );

    // Incrementer: compute PC + 4
    incr4 INCR(
        .in(pc_current),
        .out(npc_candidate)
    );

    // Multiplexer: selects between npc_candidate and branch_target
    mux2to1 MUX(
        .a(npc_candidate),
        .b(branch_target),
        .sel(PCSrc),
        .y(pc_next)
    );

inst_memory IM(
    .addr(pc_current[8:2]),
    .instruction(instruction)
);

    // IF/ID Pipeline Register: latch PC+4 and fetched instruction
    if_id_reg IF_ID(
        .clk(clk),
        .reset(reset),
        .npc_in(npc_candidate),
        .ir_in(instruction),
        .npc_out(if_id_npc),
        .ir_out(if_id_ir)
    );

    // Output the current PC for observation
    assign current_pc = pc_current;
endmodule