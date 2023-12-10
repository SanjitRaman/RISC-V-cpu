module data_mem #(
    parameter ADDRESS_WIDTH = 17,
    parameter DATA_WIDTH    = 32,
    parameter BYTE_WIDTH    = 8

)(
    input  logic                     CLK,
    input  logic                     WE0,
    input  logic                     WE1,
    input  logic                     WE2,
    input  logic                     WE3,
    input  logic [ADDRESS_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0]    WD,
    output logic [DATA_WIDTH-1:0]    RD
);

    logic [BYTE_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram.");
    $readmemh("data_mem.mem", ram_array, 32'h10000);
end;
// TODO: check if writing in between words is allowed.
always_ff @(posedge CLK) begin
    if (WE0 == 1'b1)
        ram_array[A] <= WD[7:0];
    
    if (WE1 == 1'b1)
        ram_array[A+1] <= WD[15:8];
    
    if (WE2 == 1'b1)
        ram_array[A+2] <= WD[23:16];
    
    if (WE3 == 1'b1)
        ram_array[A+3] <= WD[31:24];
end
    
assign RD = {ram_array[A+3], ram_array[A+2], ram_array[A+1], ram_array[A]};

endmodule
