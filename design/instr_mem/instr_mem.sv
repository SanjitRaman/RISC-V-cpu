module instr_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 5
) (
   input logic CLK,
   input logic [ADDRESS_WIDTH-1:0] A,
   output logic [DATA_WIDTH-1:0] RD
);
    
    // 32 instructions, 32 bits each 
    logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading rom.");
    $readmemh("testCode.mem", rom_array);
end;

always_ff @(posedge CLK) begin
    RD <= rom_array[{{2{1'b0}},A[ADDRESS_WIDTH-1:2]}]; // read from address A
    end

endmodule
