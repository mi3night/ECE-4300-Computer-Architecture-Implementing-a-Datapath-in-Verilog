module control_unit (
    input      [5:0] opcode,        // bits [31:26] of the instruction
    output reg [8:0] control        // 9-bit control bus
);


    localparam R_TYPE = 6'b000000;   // e.g., add, sub, etc. 
    localparam LW     = 6'b100011;   // opcode 35 decimal
    localparam SW     = 6'b101011;   // opcode 43 decimal
    localparam BEQ    = 6'b000100;   // opcode 4  decimal
    localparam ADDI   = 6'b001000;   // opcode 8  decimal
    localparam ADDIU  = 6'b001001;   // opcode 9  decimal
    localparam NOP    = 6'b100000;   // example if you define NOP as 0x20 in labs

    // Decode the opcode to generate the 9 control bits
    // control = { RegWrite, MemtoReg, Branch, MemRead, MemWrite, RegDst, ALUOp1, ALUOp0, ALUSrc }
    always @(*) begin
        case (opcode)
            R_TYPE: begin
                // R-type: RegDst=1, ALUOp=10, ALUSrc=0, Branch=0, MemRead=0,
                //         MemWrite=0, RegWrite=1, MemtoReg=0
                // => control = 1 0 0 0 0 1 1 0 0 in that order
                control = 9'b10_000_1100; 
                //         = {RegWrite=1, MemtoReg=0, Branch=0, MemRead=0, MemWrite=0,
                //            RegDst=1, ALUOp=2 (10 in binary), ALUSrc=0}
            end

            LW: begin
                // LW: RegDst=0, ALUOp=00, ALUSrc=1, Branch=0, MemRead=1,
                //     MemWrite=0, RegWrite=1, MemtoReg=1
                // => control = 1 1 0 1 0 0 0 0 1
                control = 9'b11_010_0001;
                // Bits: {RegWrite=1, MemtoReg=1, Branch=0, MemRead=1, MemWrite=0,
                //        RegDst=0, ALUOp=0, ALUOp=0, ALUSrc=1}
            end

            SW: begin
                // SW: RegDst=X, ALUOp=00, ALUSrc=1, Branch=0, MemRead=0,
                //     MemWrite=1, RegWrite=0, MemtoReg=X
                // => you can mark "X" bits as 0 or 1 if truly don't care
                // => control = 0 0 0 0 1 0 0 0 1
                control = 9'b00_001_0001;
                // {RegWrite=0, MemtoReg=0 (DC), Branch=0, MemRead=0, MemWrite=1,
                //  RegDst=0 (DC), ALUOp=00, ALUSrc=1}
            end

            BEQ: begin
                // BEQ: ALUOp=01 => subtract check zero
                //      Branch=1, RegWrite=0, MemRead=0, MemWrite=0, ALUSrc=0, etc.
                // => control = 0 0 1 0 0 0 0 1 0
                control = 9'b00_100_0100;
                // {RegWrite=0, MemtoReg=0, Branch=1, MemRead=0, MemWrite=0,
                //  RegDst=0, ALUOp=01, ALUSrc=0}
            end

            ADDI: begin
                // ADDI: RegWrite=1, MemtoReg=0, Branch=0, MemRead=0, MemWrite=0,
                //       RegDst=0, ALUOp=00, ALUSrc=1
                control = 9'b10_000_0001;
                // {1,0,0,0,0,0,0,0,1}
            end

            ADDIU: begin
                // Usually same as ADDI for basic pipeline control
                control = 9'b10_000_0001;
            end

            NOP: begin
                // All control signals 0 => does nothing
                control = 9'b00_000_0000;
            end

            default: begin
                // If unknown opcode, you might set everything to 0 or raise an error
                control = 9'b00_000_0000;
            end
        endcase
    end

endmodule
