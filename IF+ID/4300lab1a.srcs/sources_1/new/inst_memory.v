module inst_memory(
    input [8:2] addr, 
    output [31:0] instruction
);
    reg [31:0] mem [0:127];
    integer i;
    initial begin
        mem[0] = 32'hA00000AA;
        mem[1] = 32'h10000011;
        mem[2] = 32'h20000022;
        mem[3] = 32'h30000033;
        mem[4] = 32'h40000044;
        mem[5] = 32'h50000055;
        mem[6] = 32'h60000066;
        mem[7] = 32'h70000077;
        mem[8] = 32'h80000088;
        mem[9] = 32'h90000099;
        for(i = 10; i < 128; i = i + 1)
            mem[i] = 32'd0;
    end
    assign instruction = mem[addr[8:2]];
endmodule
