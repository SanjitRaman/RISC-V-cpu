module instr_mem #(
    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 5
) (
   input  logic [ADDRESS_WIDTH-1:0] A,
   output logic [DATA_WIDTH-1:0]    RD
);
    
    // 32 instructions, 32 bits each 
    logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading rom.");
    $readmemh("sinetestcode.mem", rom_array);
end;

assign RD = rom_array[{{2{1'b0}},A[ADDRESS_WIDTH-1:2]}]; // read from address A

endmodule
