module reg_file_w #(
    parameter ADDRESS_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter FUNCT3_WIDTH = 3
)(
    input  logic                            CLK, 
    
    input  logic                            RegWriteM,
    input  logic [1:0]                      ResultSrcM, 
    input  logic [DATA_WIDTH-1:0]           ALUResultM,
    input  logic [DATA_WIDTH-1:0]           RD,
    input  logic [ADDRESS_WIDTH-1:0]        RdM,
    input  logic [DATA_WIDTH-1:0]           PCPlus4M, 
    input  logic [FUNCT3_WIDTH-1:0]         funct3M,

    output  logic                            RegWriteW,
    output  logic [1:0]                      ResultSrcW, 
    output  logic [DATA_WIDTH-1:0]           ALUResultW,
    output  logic [DATA_WIDTH-1:0]           ReadDataW,
    output  logic [ADDRESS_WIDTH-1:0]        RdW,
    output  logic [DATA_WIDTH-1:0]           PCPlus4W,
    output  logic [FUNCT3_WIDTH-1:0]         funct3W
    
    
);

always_ff @(posedge CLK) begin
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
    ALUResultW <= ALUResultM;
    ReadDataW <= RD;
    RdW <= RdM;
    PCPlus4W <= PCPlus4M;
    funct3W <= funct3M;
end

endmodule
