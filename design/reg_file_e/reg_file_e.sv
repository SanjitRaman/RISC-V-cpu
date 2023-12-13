module reg_file_e #(
    parameter ADDRESS_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 4,
    parameter FUNCT3_WIDTH = 3,
    parameter OP_WIDTH = 7
)(
    input  logic                            CLK,
    input  logic                            CLR, 
    
    input  logic                            RegWriteD,
    input  logic [1:0]                      ResultSrcD, 
    input  logic                            MemWriteD, MemReadD, 
    input  logic                            JumpD, 
    input  logic                            BranchD, 
    input  logic [ALU_CTRL_WIDTH-1:0]       ALUControlD, 
    input  logic                            ALUSrcD, 
    input  logic [DATA_WIDTH-1:0]           RD1, 
    input  logic [DATA_WIDTH-1:0]           RD2,
    input  logic [DATA_WIDTH-1:0]           PCD, 
    input  logic [ADDRESS_WIDTH-1:0]        Rs1D, 
    input  logic [ADDRESS_WIDTH-1:0]        Rs2D,
    input  logic [ADDRESS_WIDTH-1:0]        RdD,
    input  logic [DATA_WIDTH-1:0]           ImmExtD,
    input  logic [DATA_WIDTH-1:0]           PCPlus4D, 
    input  logic [FUNCT3_WIDTH-1:0]         funct3D,
    input  logic [OP_WIDTH-1:0]             opD,

    output  logic                            RegWriteE,
    output  logic [1:0]                      ResultSrcE, 
    output  logic                            MemWriteE, MemReadE,
    output  logic                            JumpE, 
    output  logic                            BranchE, 
    output  logic [ALU_CTRL_WIDTH-1:0]       ALUControlE, 
    output  logic                            ALUSrcE, 
    output  logic [DATA_WIDTH-1:0]           RD1E, 
    output  logic [DATA_WIDTH-1:0]           RD2E,
    output  logic [DATA_WIDTH-1:0]           PCE, 
    output  logic [ADDRESS_WIDTH-1:0]        Rs1E, 
    output  logic [ADDRESS_WIDTH-1:0]        Rs2E,
    output  logic [ADDRESS_WIDTH-1:0]        RdE,
    output  logic [DATA_WIDTH-1:0]           ImmExtE,
    output  logic [DATA_WIDTH-1:0]           PCPlus4E,
    output  logic [FUNCT3_WIDTH-1:0]         funct3E,
    output  logic [OP_WIDTH-1:0]             opE   
);

always_ff @(posedge CLK) begin
    if(CLR)  begin
        // Flush
        RegWriteE     <= 0;
        ResultSrcE    <= 0;
        MemWriteE     <= 0;
        MemReadE      <= 0;
        JumpE         <= 0;
        BranchE       <= 0;
        ALUControlE   <= 0;
        ALUSrcE       <= 0;
        RD1E          <= 0;
        RD2E          <= 0;
        PCE           <= 0;
        Rs1E          <= 0;
        Rs2E          <= 0;
        RdE           <= 0;
        ImmExtE       <= 0;
        PCPlus4E      <= 0;
        funct3E       <= 0;
        opE           <= 0;
    end
    else begin
        RegWriteE    <= RegWriteD;
        ResultSrcE   <= ResultSrcD;
        MemWriteE    <= MemWriteD;
        MemReadE     <= MemReadE;
        JumpE        <= JumpD;
        BranchE      <= BranchD;
        ALUControlE  <= ALUControlD;
        ALUSrcE      <= ALUSrcD;
        RD1E         <= RD1;
        RD2E         <= RD2;
        PCE          <= PCD;
        Rs1E         <= Rs1D;
        Rs2E         <= Rs2D;
        RdE          <= RdD;
        ImmExtE      <= ImmExtD;
        PCPlus4E     <= PCPlus4D;
        funct3E      <= funct3D;
        opE          <= opD;
    end
end

endmodule
