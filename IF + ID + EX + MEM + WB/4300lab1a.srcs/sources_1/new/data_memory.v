module data_memory (
    input clk,
    input memread,
    input memwrite,
    input [31:0] addr,
    input [31:0] writedata,
    output reg [31:0] readdata
);

    reg [31:0] mem_array [0:127];  // 128 words (512 bytes)

    integer i;
    initial begin
        // Zero all memory initially
        for (i = 0; i < 128; i = i + 1)
            mem_array[i] = 32'b0;

        // Load values from file (binary)
        $readmemb("data.mem", mem_array);
    end

    // Handle writes
    always @(posedge clk) begin
        if (memwrite) begin
            mem_array[addr[8:2]] <= writedata;
            $display("MEM WRITE: mem[%0d] = %h", addr[8:2], writedata);
        end
    end

    // Combinational read
    always @(*) begin
        if (memread) begin
            readdata = mem_array[addr[8:2]];
            $display("MEM READ : mem[%0d] -> %h", addr[8:2], readdata);
        end else begin
            readdata = 32'b0;
        end
    end

endmodule
