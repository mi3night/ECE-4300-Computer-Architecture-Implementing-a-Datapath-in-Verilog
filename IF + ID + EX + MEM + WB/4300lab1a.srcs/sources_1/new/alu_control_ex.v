module alu_control_ex (
    input      [1:0] alu_op,
    input      [5:0] funct,
    output reg [2:0] alu_control
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 3'b010; // lw, sw, addi ? ADD
            2'b01: alu_control = 3'b110; // beq         ? SUB
            2'b10: begin // R-type
                case (funct)
                    6'b100000: alu_control = 3'b010; // ADD
                    6'b100010: alu_control = 3'b110; // SUB
                    6'b100100: alu_control = 3'b000; // AND
                    6'b100101: alu_control = 3'b001; // OR
                    6'b101010: alu_control = 3'b111; // SLT
                    default:   alu_control = 3'b010; // fallback = ADD
                endcase
            end
            default: alu_control = 3'b010; // fallback = ADD
        endcase
    end

endmodule
