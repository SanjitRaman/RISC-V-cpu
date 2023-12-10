module data_mem_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter MEM_ADDRESS_WIDTH = 9,
    parameter FUNCT3_WIDTH = 3,
    parameter BYTE_WIDTH   = 8

)(
    input logic                  CLK,
    input logic                  RST,
    input logic [DATA_WIDTH-1:0] ALUResult,
    input logic [DATA_WIDTH-1:0] WriteData,
    input logic [FUNCT3_WIDTH-1:0] funct3,
    input logic                    MemWrite,
    input logic                    MemRead, // TODO: implement this in control unit.
    output logic [DATA_WIDTH-1:0]  RDOut
);
    logic WE0, WE1, WE2, WE3;
    logic [DATA_WIDTH-1:0] RDMem, WD;
    logic hit;
    logic WE0Cache, WE1Cache, WE2Cache, WE3Cache;
    logic [DATA_WIDTH-1:0] ACache, RDCache, WDCache;
    logic [DATA_WIDTH-1:0] FoundData;

    data_mem  #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(MEM_ADDRESS_WIDTH),
        .BYTE_WIDTH(BYTE_WIDTH)
    )
    data_mem (
        .CLK(CLK),
        .A(ACache),
        .WD(WDCache),
        .WE0(WE0Cache),
        .WE1(WE1Cache),
        .WE2(WE2Cache),
        .WE3(WE3Cache),
        .RD(RDMem)
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
        .RD(FoundData),
        .funct3(funct3),
        .RDOut(RDOut)
    );

    cache #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    riscCache (
        // inputs
        .CLK(CLK),
        .RST(),
        .WE0(WE0),
        .WE1(WE1),
        .WE2(WE2),
        .WE3(WE3),
        .A(ALUResult),
        .WD(WD),
        // outputs
        .RD(RDCache),
        .hit(hit),
        .WE0Cache(WE0Cache),
        .WE1Cache(WE1Cache),
        .WE2Cache(WE2Cache),
        .WE3Cache(WE3Cache),
        .ACache(ACache),
        .WDCache(WDCache)
    );


    assign WD = (MemRead & ~hit) ? FoundData : WriteData;
    
    assign FoundData = (hit) ? RDCache : RDMem;






endmodule
