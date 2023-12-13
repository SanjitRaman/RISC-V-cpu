module reg_file #(
    parameter ADDRESS_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input  logic                     CLK,
    input  logic [ADDRESS_WIDTH-1:0] A1,  // read adr 1
    input  logic [ADDRESS_WIDTH-1:0] A2,  // read adr 2
    input  logic [ADDRESS_WIDTH-1:0] A3,  // write adr 
    input logic  [ADDRESS_WIDTH-1:0] address_to_view,
    input  logic                     WE3, // write enable 
    input  logic [DATA_WIDTH-1:0]    WD3, // write data 
    output logic [DATA_WIDTH-1:0]    RD1, // read out 1
    output logic [DATA_WIDTH-1:0]    RD2, // read out 2
    output logic [DATA_WIDTH-1:0]    reg_output,   // register 10
    output logic [DATA_WIDTH-1:0]    a0
);

logic [DATA_WIDTH-1:0] registers [2**ADDRESS_WIDTH-1:0];

always_ff @(posedge CLK) begin
    if(WE3 == 1'b1 && A3 != 0) registers[A3] <= WD3;
end

always_comb begin
    RD1 = registers[A1];
    RD2 = registers[A2];
    reg_output = registers[address_to_view];
    a0 = registers[5'b01010];
end

endmodule
