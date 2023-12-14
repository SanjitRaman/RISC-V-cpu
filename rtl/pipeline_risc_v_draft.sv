module risc_v #(
    parameter                      DATA_WIDTH     = 32,
    parameter                      OP_WIDTH       = 7,
    parameter                      FUNCT3_WIDTH   = 3,
    parameter                      ADDRESS_WIDTH = 5,
    parameter                      IMM_SRC_WIDTH  = 3,
    parameter                      ALU_CTRL_WIDTH = 4,
    parameter                      RES_SRC_WIDTH = 2,
    parameter                      FORWARD_WIDTH = 2
)(
// interface signals
    input  logic                   CLK, RST, 
    output logic [DATA_WIDTH-1:0]  a0
);

// Hazard Unit
    logic                          StallF, StallD;
    logic                          FlushD, FLushE;
    logic [FORWARD_WIDTH-1:0]      ForwardAE, ForwardBE;

// PC
    logic [DATA_WIDTH-1:0]         PCF, PCNextF, PCPlus4F;

// Instruction Memory
    logic [DATA_WIDTH-1:0]         InstrF;

// Reg File D
    logic [DATA_WIDTH-1:0]         InstrD, PCD, PCPlus4D;

// Control Unit
    logic [OP_WIDTH-1:0]           op;
    logic [FUNCT3_WIDTH-1:0]       funct3D;
    logic [RES_SRC_WIDTH-1:0]      ResultSrcD;
    logic [ALU_CTRL_WIDTH-1:0]     ALUControlD;
    logic [IMM_SRC_WIDTH-1:0]      ImmSrcD;
    logic                          MemWriteD, ALUSrcD, RegWriteD, BranchD, JumpD;
    logic                          funct7_5D;

// Register File
    logic [ADDRESS_WIDTH-1:0]     A1, A2, RdD;
    logic [DATA_WIDTH-1:0]        RD1, RD2; 

// Sign Extend
    logic [DATA_WIDTH-1:0]         ImmExtD;

// Reg File E
    logic                          RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    logic [ALU_CTRL_WIDTH-1:0]     ALUControlE;
    logic [RES_SRC_WIDTH-1:0]      ResultSrcE;
    logic [DATA_WIDTH-1:0]         RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    logic [ADDRESS_WIDTH-1:0]      Rs1E, Rs2E, RdE;
    logic [FUNCT3_WIDTH-1:0]       funct3E;

    logic [DATA_WIDTH-1:0]         JumpMux;
    logic [DATA_WIDTH-1:0]         WriteDataE;
    logic [DATA_WIDTH-1:0]         PCTargetE;

// ALU
    logic [DATA_WIDTH-1:0]         SrcA;
    logic [DATA_WIDTH-1:0]         SrcB;
    logic [DATA_WIDTH-1:0]         ALUResultE;
    logic                          Zero, N, C, V;
    logic [DATA_WIDTH-1:0]         ResultW;

// Reg File M 
    logic                          RegWriteM, MemWriteM;
    logic [RES_SRC_WIDTH-1:0]      ResultSrcM;
    logic [DATA_WIDTH-1:0]         ALUResultM, ReadDataM, PCPlus4M;
    logic [ADDRESS_WIDTH-1:0]      RdM;
    logic [FUNCT3_WIDTH-1:0]       funct3M;

// Data Memory
    logic                          WE0, WE1, WE2, WE3;
    logic [DATA_WIDTH-1:0]         ReadData;

// Reg File W 
    logic                          RegWriteW;
    logic [RES_SRC_WIDTH-1:0]      ResultSrcW;
    logic [DATA_WIDTH-1:0]         ALUResultW, WriteDataW, PCPlus4W, ReadDataW;
    logic [ADDRESS_WIDTH-1:0]      RdW;
    logic [FUNCT3_WIDTH-1:0]       funct3W;

    assign PCNextF   = PCSrcE     ? PCTargetE  : PCPlus4F;

    hazard_unit #(
        .ADDRESS_WIDTH(5),
        .FORWARD_WIDTH(2)
    ) 
    risc_HazardUnit (
        .Rs1D        (A1),
        .Rs2D        (A2),
        .RdE         (RdE),
        .Rs1E        (Rs1E),
        .Rs2E        (Rs2E),
        .PCSrcE      (PCSrcE),
        .ResultSrcE0 (ResultSrcE[0]),
        .RdM         (RdM),
        .RegWriteM   (RegWriteM),
        .RdW         (RdW),
        .RegWriteW   (RegWriteW),
        .StallF      (StallF),
        .StallD      (StallD),
        .FlushD      (FlushD),
        .FlushE      (FlushE),
        .ForwardAE   (ForwardAE),
        .ForwardBE   (ForwardBE)
    );

    pc #(
        .DATA_WIDTH (32)
    )
    riscPC (
        .CLK        (CLK),
        .RST        (RST),
        .PCNext     (PCNextF),
        .PC         (PCF),
        .EN         (StallF)        
    );

    instr_mem #(
        .DATA_WIDTH    (32),
        .ADDRESS_WIDTH (32)
    )
    riscInstrMem (
        .A          (PCF),
        .RD         (Instr)
    );

    assign PCPlus4F  = PCF + 4;

    reg_file_d #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32)
    )
    risc_reg_file_d (
        .CLK(CLK),
        .CLR(FlushD), 
        .EN (StallD),
        .RD(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        
        .InstrD(InstrD),
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D)
    );

    // extractions from Instruction
    assign op         = InstrD[6:0];
    assign funct3D    = InstrD[14:12];
    assign funct7_5D   = InstrD[30];
    assign A1         = InstrD[19:15];
    assign A2         = InstrD[24:20];
    assign RdD         = InstrD[11:7];

    control_unit #(
        .OP_WIDTH       (7),
        .FUNCT3_WIDTH   (3),
        .ALU_CTRL_WIDTH (4),
        .IMM_SRC_WIDTH  (3),
        .ALU_OP_WIDTH   (3)
    )
    riscControlUnit (
        .op         (op),
        .funct3     (funct3D),
        .funct7_5   (funct7_5D),
        .ResultSrc  (ResultSrcD),
        .MemWrite   (MemWriteD),
        .ALUControl (ALUControlD),
        .ALUSrc     (ALUSrcD),
        .ImmSrc     (ImmSrcD),
        .RegWrite   (RegWriteD),
        .Jump       (JumpD),
        .Branch     (BranchD)
    );

    reg_file #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32)
    )
    riscRegFile (
        .CLK        (CLK),
        .A1         (A1),
        .A2         (A2),
        .A3         (), 
        .WE3        (), 
        .RD1        (RD1),
        .RD2        (RD2),
        .WD3        (),
        .a0         (a0)
    );

    sign_extend # (
        .DATA_WIDTH    (32),
        .IMM_SRC_WIDTH (3)
    )
    riscSignExtend (
        .Instr      (InstrD),
        .ImmSrc     (ImmSrcD),
        .ImmOp      (ImmExtD)
    );

        reg_file_e #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32),
        .ALU_CTRL_WIDTH (4)
    )
    reg_file_e (
        .CLK(CLK),
        .CLR(FlushE), 
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD), 
        .MemWriteD(MemWriteD), 
        .JumpD(JumpD), 
        .BranchD(BranchD), 
        .ALUControlD(ALUControlD), 
        .ALUSrcD(ALUSrcD),
        .RD1(RD1), 
        .RD2(RD2),
        .PCD(PCD), 
        .Rs1D(A1), 
        .Rs2D(A2),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D), 
        .funct3D(funct3D),

        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE), 
        .JumpE(JumpE), 
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .ALUSrcE(ALUSrcE), 
        .RD1E(RD1E), 
        .RD2E(RD2E),
        .PCE(PCE), 
        .Rs1E(Rs1E), 
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .funct3E(funct3E)
    );

    assign SrcA = ForwardAE[1] ? ALUResultM : (ForwardAE[0] ? ResultW : RD1E);
    assign WriteDataE = ForwardBE[1] ? ALUResultM : (ForwardBE[0] ? ResultW : RD2E);
    assign SrcB     = ALUSrcE ? ExtImmE : WriteDataE; 
    assign JumpMux  = JumpE      ? RD1E : PCE;
    assign PCTarget = JumpMux + ImmExtE;

    flags #(
        .OP_WIDTH     (7),
        .FUNCT3_WIDTH (3)
    ) 
    riscflags (
        .op (op),
        .funct3 (funct3E),
        .Zero(Zero),
        .N(N),
        .C(C),
        .V(V),
        .Branch(BranchE),
        .PCSrc(PCSrcE)
    );

    alu #(
        .DATA_WIDTH     (32),
        .ALU_CTRL_WIDTH (4)
    )
    riscALU (
        .SrcA        (SrcA),
        .SrcB        (SrcB),
        .ALUControl  (ALUControlE),
        .ALUResult   (ALUResultE),
        .Zero        (Zero),
        .N           (N),
        .C           (C),
        .V           (V)
    );

    reg_file_m #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32)
    )
    reg_file_m (
        .CLK(CLK),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE), 
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .funct3E(funct3E),

        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .funct3M(funct3M)
    );

    we_decoder riscWe_decoder (
        .funct3(funct3M),
        .MemWrite(MemWriteM),
        .WE0 (WE0),
        .WE1 (WE1),
        .WE2 (WE2),
        .WE3 (WE3)
    );

    data_mem #(
        .ADDRESS_WIDTH (17),
        .BYTE_WIDTH    (8),
        .DATA_WIDTH    (32)
    )
    riscDataMem (
        .CLK         (CLK),
        .A           (ALUResultM[16:0]),
        .WD          (WriteDataM),
        .RD          (ReadData),
        .WE0         (WE0),
        .WE1         (WE1),
        .WE2         (WE2),
        .WE3         (WE3)
    );

    ld_decoder #(
        .DATA_WIDTH(32)
    )
    riscLd_decoder(
        .RD (ReadData),
        .funct3 (funct3M),
        .RDOut (ReadDataM)
    );

    reg_file_w #(
        .ADDRESS_WIDTH (5),
        .DATA_WIDTH    (32),
        .ALU_CONTROL_WIDTH (3)
    )
    reg_file_w (
        .CLK(CLK),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .RD(ReadDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .funct3M(funct3M),

        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W),
        .funct3W(funct3W)
    );

    assign ResultW  = ResultSrcW[1] ? PCPlus4W : (ResultSrcW[0] ? ReadDataM : ALUResultW);
endmodule