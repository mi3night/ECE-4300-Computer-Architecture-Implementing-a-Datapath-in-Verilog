module tb_if_stage;
    reg clk;
    reg reset;
    reg PCSrc;
    reg [31:0] branch_target;
    wire [31:0] current_pc;
    wire [31:0] if_id_ir;
    wire [31:0] if_id_npc;

    // Instantiate the IF stage top module
    if_stage IF_STAGE(
        .clk(clk),
        .reset(reset),
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .current_pc(current_pc),
        .if_id_ir(if_id_ir),
        .if_id_npc(if_id_npc)
    );

    // Clock generation: period = 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main stimulus
    initial begin
        // Initialize signals
        reset = 1;
        PCSrc = 0;               // Sequential operation initially
        branch_target = 32'd2; // Arbitrary branch target

        // Release reset after a short delay
        #12;
        reset = 0;

        // Schedule branch tests by momentarily asserting PCSrc.
    
        #40;       // Delay ~40 ns
        PCSrc = 1; // Activate branch signal
        #10;       // Hold for one clock cycle (10 ns)
        PCSrc = 0; // Deactivate branch signal

       
        #50;
        PCSrc = 1;
        #10;
        PCSrc = 0;

       
        #50;
        PCSrc = 1;
        #10;
        PCSrc = 0;

       
        #70; reset = 1;
        #20; reset = 0;
        #50;
        
        $finish;
    end

    // Print the PC, IF/ID IR, and IF/ID NPC at each rising edge for ~30 cycles.
    // (This block uses 'repeat' rather than an explicit cycle index variable.)
    initial begin
        repeat (30) begin
            @(posedge clk);
            $display("PC = %0d, IF/ID IR = 0x%h, IF/ID NPC = %0d", 
                     current_pc, if_id_ir, if_id_npc);
        end
    end
endmodule
