`timescale 1ns/1ps

module pipeline_top_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg PCSrc;
    reg [31:0] branch_target;
    
    // Wires from pipeline_top outputs
    wire [31:0] current_pc;
    wire [31:0] if_id_ir;
    wire [31:0] if_id_npc;
    wire [31:0] id_ex_npc;
    wire [31:0] regData1;
    wire [31:0] regData2;
    wire [31:0] signExt;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [8:0]  control;
    
    // Instantiate your integrated pipeline top module
    pipeline_top dut (
        .clk(clk),
        .reset(reset),
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .current_pc(current_pc),
        .if_id_ir(if_id_ir),
        .if_id_npc(if_id_npc),
        .id_ex_npc(id_ex_npc),
        .regData1(regData1),
        .regData2(regData2),
        .signExt(signExt),
        .rt(rt),
        .rd(rd),
        .control(control)
    );
    
    //---------------------------------------------------
    // Optionally, if your if_stage has an instruction memory
    // array named "instruction_mem" or similar, you can
    // load instructions from a file using readmemh:
    //---------------------------------------------------
    // For example, in if_stage.v you might have:
    //   reg [31:0] instruction_mem [0:255];
    // then here in the TB you can do:
    //
    //   initial begin
    //     $readmemh("instructions.hex", dut.IF_STAGE.instruction_mem);
    //   end
    //
    // Or if you'd rather assign them manually:
    //   initial begin
    //     dut.IF_STAGE.instruction_mem[0] = 32'h002300AA;
    //     dut.IF_STAGE.instruction_mem[1] = 32'h10654321;
    //     ...
    //   end
    //---------------------------------------------------

    // Extract fields from IF/ID IR (for console display)
    wire [5:0] opcode  = if_id_ir[31:26];
    wire [4:0] rs      = if_id_ir[25:21];
    wire [4:0] rt_ifid = if_id_ir[20:16];
    wire [4:0] rd_ifid = if_id_ir[15:11];
    wire [15:0] imm16  = if_id_ir[15:0];
    
    // Generate clock: 10 ns period
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    // Simulation controls
    initial begin
        // 1) Dump waveforms for GTKWave or similar.
        //    (Comment out if you use ModelSim's "add wave" commands)
        $dumpfile("pipeline_dump.vcd");
        $dumpvars(0, pipeline_top_tb);
        
        // 2) Reset and initial signals
        reset          = 1;
        PCSrc          = 0;
        branch_target  = 32'h00000000; // Example branch destination
        
        // 3) Deassert reset after 12 ns
        #9 reset = 0;
        
        // 4) Run for some cycles, then force a branch
        #80  PCSrc = 1;
        #10  PCSrc = 0;
        
        // 5) Let it run a bit, then end
        #50  $finish;
    end

    // Basic monitor printing key signals each sim time
    initial begin
        $monitor($time, 
                 " | clk=%b reset=%b PC=%d IF_ID_IR=0x%h IF_ID_NPC=%d",
                 clk, reset, current_pc, if_id_ir, if_id_npc);
    end

    // More detailed printing of instruction decode & pipeline registers each cycle
    always @(posedge clk) begin
        $display("\n------------------- Cycle @ %0t ns -------------------", $time);
        $display(" PC      = %d", current_pc);
        $display(" IF/ID IR= 0x%08h   (opcode=%0d  rs=%0d  rt=%0d  rd=%0d  imm16=0x%04h)",
                 if_id_ir, opcode, rs, rt_ifid, rd_ifid, imm16);
        $display(" Control = %b (9 bits)  signExt=%d  ID_EX_npc=%d",
                 control, signExt, id_ex_npc);
        $display(" ID stage: regData1=%d regData2=%d rt=%0d rd=%0d",
                 regData1, regData2, rt, rd);
    end
endmodule
