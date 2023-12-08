module risc_v #(
    parameter                      DATA_WIDTH     = 32,
    parameter                      OP_WIDTH       = 7,
    parameter                      FUNCT3_WIDTH   = 3,
    parameter                      REG_ADDR_WIDTH = 5,
    parameter                      IMM_SRC_WIDTH  = 3,
    parameter                      ALU_CTRL_WIDTH = 4,
    parameter                      RES_SRC_WIDTH = 2
)(
// interface signals
    input  logic                   CLK,      // clock 
    input  logic                   RST,      // reset 
    input  logic [REG_ADDR_WIDTH-1:0] address_to_view,
    output logic [DATA_WIDTH-1:0]  reg_output
);

// PC
    logic [DATA_WIDTH-1:0]         PC;
    logic [DATA_WIDTH-1:0]         PCNext;
    logic [DATA_WIDTH-1:0]         PCPlus4;

// Instruction Memory
    //logic                        PC;
    logic [DATA_WIDTH-1:0]         Instr;

// Sign Extend
    //logic [DATA_WIDTH-1:0]       Instr;
    //logic [IMM_SRC_WIDTH:0]      ImmSrc;
    logic [DATA_WIDTH-1:0]         ImmExt;

// Control Unit
    logic [OP_WIDTH-1:0]           op;
    logic [FUNCT3_WIDTH-1:0]       funct3;
    logic                          funct7_5;
    logic                          PCSrc;
    logic [RES_SRC_WIDTH-1:0]      ResultSrc;
    logic                          MemWrite;
    logic [ALU_CTRL_WIDTH-1:0]     ALUControl;
    logic                          ALUSrc;
    logic [IMM_SRC_WIDTH-1:0]      ImmSrc;
    logic                          RegWrite;
    logic                          Jump;
    logic                          Zero;
    logic                          N;
    logic                          C;
    logic                          V;

// ALU
    logic [DATA_WIDTH-1:0]         SrcA;
    logic [DATA_WIDTH-1:0]         SrcB;
    logic [DATA_WIDTH-1:0]         ALUResult;
    //logic                          Zero;
    //logic                          N;
    //logic                          C;
    //logic                          V;

// Data Memory
    //CLK
    logic WE0;
    logic WE1;
    logic WE2;
    logic WE3;
    //logic [ADDRESS_WIDTH-1:0] ALUResult;
    logic [DATA_WIDTH-1:0]   WriteData;
    logic [DATA_WIDTH-1:0]   ReadData;

// Register File
    //CLK
    logic [REG_ADDR_WIDTH-1:0]     A1;
    logic [REG_ADDR_WIDTH-1:0]     A2;
    logic [REG_ADDR_WIDTH-1:0]     A3;
    logic [DATA_WIDTH-1:0]         Result;
    //logic [DATA_WIDTH-1:0]       SrcA;
    //logic [DATA_WIDTH-1:0]       WriteData; RD2 output.

// WE decoder
    //logic[FUNCT3_WIDTH-1:0] funct3;
    //logic MemWrite;
    //logic WE0;
    //logic WE1;
    //logic WE2;
    //logic WE3;

//LD decoder
    //logic ReadData;
    //logic funct3;
    logic [31:0] RDOut;

// linking wires
    logic [DATA_WIDTH-1:0]         PCTarget;
    logic [DATA_WIDTH-1:0]         JumpMux;


// extractions from Instruction
    assign op         = Instr[6:0];
    assign funct3     = Instr[14:12];
    assign funct7_5   = Instr[30];
    assign A1         = Instr[19:15];
    assign A2         = Instr[24:20];
    assign A3         = Instr[11:7];


    pc #(
        .DATA_WIDTH (32)
    )
    riscPC (
        .CLK        (CLK),
        .RST        (RST),
        .PCNext     (PCNext),
        .PC         (PC)
    );

    instr_mem #(
        .DATA_WIDTH    (32),
        .ADDRESS_WIDTH (32)
    )
    riscInstrMem (
        .A          (PC),
        .RD         (Instr)
    );

    control_unit #(
        .OP_WIDTH       (7),
        .FUNCT3_WIDTH   (3),
        .ALU_CTRL_WIDTH (4),
        .IMM_SRC_WIDTH  (3),
        .ALU_OP_WIDTH   (3)
    )
    riscControlUnit (
        .op         (op),
        .funct3     (funct3),
        .funct7_5   (funct7_5),
        .Zero       (Zero),
        .PCSrc      (PCSrc),
        .ResultSrc  (ResultSrc),
        .MemWrite   (MemWrite),
        .ALUControl (ALUControl),
        .ALUSrc     (ALUSrc),
        .ImmSrc     (ImmSrc),
        .RegWrite   (RegWrite),
        .Jump       (Jump),
        .N          (N),
        .C          (C),
        .V          (V)
    );

    sign_extend # (
        .DATA_WIDTH    (32),
        .IMM_SRC_WIDTH (3)
    )
    riscSignExtend (
        .Instr      (Instr),
        .ImmSrc     (ImmSrc),
        .ImmOp      (ImmExt)
    );

    reg_file #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32)
    )
    riscRegFile (
        .CLK        (CLK),
        .A1         (A1),
        .A2         (A2),
        .A3         (A3),
        .WE3        (RegWrite),
        .RD1        (SrcA),
        .RD2        (WriteData),
        .WD3        (Result),
        .address_to_view(address_to_view),
        .reg_output (reg_output)
    );

    alu #(
        .DATA_WIDTH     (32),
        .ALU_CTRL_WIDTH (4)
    )
    riscALU (
        .SrcA        (SrcA),
        .SrcB        (SrcB),
        .ALUControl  (ALUControl),
        .ALUResult   (ALUResult),
        .Zero        (Zero),
        .N           (N),
        .C           (C),
        .V           (V)
    );

    data_mem #(
        .ADDRESS_WIDTH (17),
        .BYTE_WIDTH    (8),
        .DATA_WIDTH    (32)
    )
    riscDataMem (
        .CLK         (CLK),
        .A           (ALUResult[16:0]),
        .WD          (WriteData),
        .RD          (ReadData),
        .WE0         (WE0),
        .WE1         (WE1),
        .WE2         (WE2),
        .WE3         (WE3)
    );

    we_decoder riscWe_decoder (
        .funct3(funct3),
        .MemWrite(MemWrite),
        .WE0 (WE0),
        .WE1 (WE1),
        .WE2 (WE2),
        .WE3 (WE3)
    );
    ld_decoder #(
        .DATA_WIDTH(32)
    )
    riscLd_decoder(
        .RD (ReadData),
        .funct3 (funct3),
        .RDOut (RDOut)
    );

// MUXs
    assign SrcB     = ALUSrc    ? ImmExt   : WriteData;
    assign Result   = ResultSrc[1] ? (ResultSrc[0] ? PCPlus4 : PCTarget)  : (ResultSrc[0] ? RDOut : ALUResult);
    assign PCNext   = PCSrc     ? PCTarget  : PCPlus4;
    assign JumpMux  = Jump      ? SrcA : PC;

// Adders
    assign PCTarget = JumpMux + ImmExt;
    assign PCPlus4  = PC + 4;

endmodule
