module if_id_reg_tb;
    reg clk;
    reg reset;
    reg [31:0] npc_in;
    reg [31:0] ir_in;
    wire [31:0] npc_out;
    wire [31:0] ir_out;
    
    // Instantiate the IF/ID pipeline register (device under test)
    if_id_reg uut (
       .clk(clk),
       .reset(reset),
       .npc_in(npc_in),
       .ir_in(ir_in),
       .npc_out(npc_out),
       .ir_out(ir_out)
    );
    
    // Generate clock: period = 10 time units
    initial begin
       clk = 0;
       forever #5 clk = ~clk;
    end
    
    // Apply reset and drive npc_in and ir_in with test values.
    initial begin
       // Apply reset for one clock cycle.
       reset = 1;
       npc_in = 32'd0;
       ir_in  = 32'h00000000;
       #10;
       reset = 0;
       
       // Cycle 1: drive values into inputs.
       npc_in = 32'd4;
       ir_in  = 32'hDEADBEEF;
       #10;
       
       // Cycle 2: update inputs.
       npc_in = 32'd8;
       ir_in  = 32'hCAFEBABE;
       #10;
       
       // Cycle 3: update inputs.
       npc_in = 32'd12;
       ir_in  = 32'h12345678;
       #10;
       
       $finish;
    end
    
    // Monitor the outputs.
    initial begin
       $monitor("Time=%0t | npc_in=%d, ir_in=0x%h | npc_out=%d, ir_out=0x%h", 
                $time, npc_in, ir_in, npc_out, ir_out);
    end
endmodule
