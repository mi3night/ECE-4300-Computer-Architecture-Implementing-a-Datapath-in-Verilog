module id_stage_tb;
    reg         clk;
    reg         reset;
    reg  [31:0] npc;
    reg  [31:0] instr;
    
    wire [31:0] id_ex_npc;
    wire [31:0] regData1;
    wire [31:0] regData2;
    wire [31:0] signExt;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [8:0]  control;
    
    // Instantiate the ID stage
    id_stage DUT(
        .clk(clk),
        .reset(reset),
        .npc(npc),
        .instr(instr),
        .id_ex_npc(id_ex_npc),
        .regData1(regData1),
        .regData2(regData2),
        .signExt(signExt),
        .rt(rt),
        .rd(rd),
        .control(control)
    );
    
    // Clock generation: 10 time unit period.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        // Apply reset initially
        reset = 1;
        npc = 32'd0;
        instr = 32'h002300AA; // First instruction: 002300AA
        #10;
        reset = 0;
        
        // Cycle 1 (Time ~10):
        // npc = 0+4 = 4, instr = 002300AA.
        #10;
        
        // Cycle 2 (Time ~20):
        npc = npc + 4;
        instr = 32'h10654321;
        #10;
        
        // Cycle 3 (Time ~30):
        npc = npc + 4;
        instr = 32'h00100022;
        #10;
        
        // Cycle 4 (Time ~40):
        npc = npc + 4;
        instr = 32'h8C123456;
        #10;
        
        // Cycle 5 (Time ~50):
        npc = npc + 4;
        instr = 32'h8F123456;
        #10;
        
        // Cycle 6 (Time ~60):
        npc = npc + 4;
        instr = 32'hAD654321;
        #10;
        
        // Cycle 7 (Time ~70):
        npc = npc + 4;
        instr = 32'h13012345;
        #10;
        
        // Cycle 8 (Time ~80):
        npc = npc + 4;
        instr = 32'hAC654321;
        #10;
        
        // Cycle 9 (Time ~90):
        npc = npc + 4;
        instr = 32'h12012345;
        #20;
        $finish;
    end
    
    // Monitor the outputs at each clock edge.
    initial begin
        $monitor("Time=%0t | npc=%d | id_ex_npc=%d | control=%b | regData1=%d | regData2=%d | signExt=%d | rt=%d | rd=%d", 
                 $time, npc, id_ex_npc, control, regData1, regData2, signExt, rt, rd);
    end
endmodule
