module data_mem_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter MEM_ADDRESS_WIDTH = 17,
    parameter FUNCT3_WIDTH = 3,
    parameter BYTE_WIDTH   = 8,
    parameter string MEM_FILE = "data_mem_wrapper.mem"
)(
    input logic                  CLK,
    input logic [DATA_WIDTH-1:0] ALUResult,
    input logic [DATA_WIDTH-1:0] WriteData,
    input logic [FUNCT3_WIDTH-1:0] funct3,
    input logic                    MemWrite,
    output logic [DATA_WIDTH-1:0]  RDOut
);
    logic WE0;
    logic WE1;
    logic WE2;
    logic WE3;
    logic [DATA_WIDTH-1:0] RD;
    data_mem  #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(MEM_ADDRESS_WIDTH),
        .BYTE_WIDTH(BYTE_WIDTH),
        .MEM_FILE (MEM_FILE)
    )
    data_mem (
        .CLK(CLK),
        .A(ALUResult[16:0]),
        .WD(WriteData),
        .WE0(WE0),
        .WE1(WE1),
        .WE2(WE2),
        .WE3(WE3),
        .RD(RD)
    );

    we_decoder #()
    we_decoder (
        .funct3(funct3),
        .MemWrite(MemWrite),
        .WE0(WE0),
        .WE1(WE1),
        .WE2(WE2),
        .WE3(WE3)
    );

    ld_decoder #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    ld_decoder(
        .RD(RD),
        .funct3(funct3),
        .RDOut(RDOut)
    );


endmodule
