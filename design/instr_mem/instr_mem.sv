module instr_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 2
) (
   input logic clk,
   input logic [ADDRESS_WIDTH-1:0] A,
   output logic [DATA_WIDTH-1:0] RD
);
    
logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading rom.");
    $readmemh("testCode.mem", rom_array);
end;

always_ff @(posedge clk) begin
    RD <= rom_array[A];
    end

endmodule
