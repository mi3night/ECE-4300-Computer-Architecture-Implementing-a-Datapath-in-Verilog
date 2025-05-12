module pipeline_top(
    input         clk,
    input         reset,
    input         PCSrc,
    input  [31:0] branch_target,
    output [31:0] current_pc,
    output [31:0] if_id_ir,
    output [31:0] if_id_npc,
    output [31:0] id_ex_npc,
    output [31:0] regData1,
    output [31:0] regData2,
    output [31:0] signExt,
    output [4:0]  rt,
    output [4:0]  rd,
    output [8:0]  control
);
    // Wires to carry IF outputs
    wire [31:0] instr;  
    wire [31:0] npc;

    // -----------------------------
    // IF STAGE
    // -----------------------------
    if_stage IF_STAGE (
         .clk(clk),
         .reset(reset),
         .PCSrc(PCSrc),
         .branch_target(branch_target),
         .current_pc(current_pc),
         .if_id_ir(instr),    // "instr" wire from IF
         .if_id_npc(npc)      // "npc" wire from IF
    );

    // Make these wires visible at top level
    assign if_id_ir  = instr; 
    assign if_id_npc = npc;

    // -----------------------------
    // ID STAGE
    // -----------------------------
    id_stage ID_STAGE (
         .clk(clk),
         .reset(reset),
         // Inputs taken directly from IF outputs
         .npc(npc),
         .instr(instr),

         // Outputs
         .id_ex_npc(id_ex_npc),
         .regData1(regData1),
         .regData2(regData2),
         .signExt(signExt),
         .rt(rt),
         .rd(rd),
         .control(control)
    );
endmodule
