module data_mem #(
    parameter ADDRESS_WIDTH = 9,
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
    $readmemh("data_mem_wrapper_test.mem", ram_array);
end;
// TODO: check if writing in between words is allowed.
always_ff @(posedge CLK) begin
    $display("%h", WD);
    if (WE0 == 1'b1) begin
        ram_array[A] <= WD[31:24]; $display("WD0: %h", WD[31:24]); end
    
    if (WE1 == 1'b1) begin
        ram_array[A+1] <= WD[23:16]; $display("WD1: %h", WD[23:16]); end
    
    if (WE2 == 1'b1) begin
        ram_array[A+2] <= WD[15:8]; $display("WD2: %h", WD[15:8]); end
    
    if (WE3 == 1'b1) begin
        ram_array[A+3] <= WD[7:0]; $display("WD3: %h", WD[7:0]); end
    $display("%h", {ram_array[A+3], ram_array[A+2], ram_array[A+1], ram_array[A]});
end
    
assign RD = {ram_array[A+3], ram_array[A+2], ram_array[A+1], ram_array[A]};

endmodule
