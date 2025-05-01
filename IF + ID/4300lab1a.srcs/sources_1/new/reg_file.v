module reg_file(
    input         clk,
    input         regWrite,
    input  [4:0]  readReg1,
    input  [4:0]  readReg2,
    input  [4:0]  writeReg,
    input  [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);
    reg [31:0] registers [0:31];
    integer i;
    initial begin
        registers[0] = 32'd0;
        for (i = 1; i < 32; i = i + 1)
            registers[i] = i;  
    end
    
    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];
    
    always @(posedge clk) begin
        if (regWrite)
            registers[writeReg] = writeData;
    end
endmodule
