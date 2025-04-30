module inst_memory(
    input [8:2] addr, 
    output [31:0] instruction
);
    reg [31:0] mem [0:127];
    integer i;
    initial begin
        mem[0] = 32'h002300AA;
        mem[1] = 32'h10654321;
        mem[2] = 32'h00100022;
        mem[3] = 32'h8C123456;
        mem[4] = 32'h8F123456;
        mem[5] = 32'hAD654321;
        mem[6] = 32'h13012345;
        mem[7] = 32'hAC654321;
        mem[8] = 32'h12012345;
        for(i = 9; i < 128; i = i + 1)
            mem[i] = 32'd0;
    end
    assign instruction = mem[addr[8:2]];
endmodule
