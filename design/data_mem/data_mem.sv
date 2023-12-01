module data_mem #(
    parameter ADDRESS_WIDTH = 5,
    parameter BYTE_WIDTH    = 8,
    parameter DATA_WIDTH    = 32

)(
    input  logic                     CLK,
    input  logic                     WE,
    input  logic [ADDRESS_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0]    WD,
    input  logic [2:0]               funct3,
    output logic [DATA_WIDTH-1:0]    RD
);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram.");
    $readmemh("sineram.mem", ram_array);
end;

always_ff @(posedge CLK)
    if (WE == 1'b1) begin
        ram_array[A] <= WD;
    end

assign RD = ram_array[A];
endmodule
