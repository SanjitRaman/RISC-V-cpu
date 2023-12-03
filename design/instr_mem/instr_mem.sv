module instr_mem #(
    parameter DATA_WIDTH   = 32,
    parameter BYTE_WIDTH    = 8,
    parameter ADDRESS_WIDTH = 5
) (
   input  logic [ADDRESS_WIDTH-1:0] A,
   output logic [DATA_WIDTH-1:0]    RD
);

    // 32 instructions, 32 bits each 
    logic [BYTE_WIDTH-1:0] rom_array [32'hBFC00FFF:32'hBFC00000];

initial begin
    $display("Loading rom.");
    $readmemh("instr_mem.mem", rom_array, 32'hBFC00000);
end;

assign RD = {rom_array[A+3], rom_array[A+2], rom_array[A+1], rom_array[A]}; // read from address A

endmodule
