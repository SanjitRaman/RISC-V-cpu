module risc_v #(
  parameter                      DATA_WIDTH = 32,
  parameter                      OP_WIDTH   = 7,
  parameter                      FUNCT3_WIDTH = 3,
  parameter                      REG_ADDR_WIDTH = 5,
  parameter                      IMM_SRC_WIDTH = 2,
  parameter                      ALU_CTRL_WIDTH = 3,
  parameter                      ALU_OP_WIDTH = 2
)(
  // interface signals
  input  logic                   CLK,      // clock 
  input  logic                   RST,      // reset 
  output logic [DATA_WIDTH-1:0]  a0
);

// PC
  logic [DATA_WIDTH-1:0]         PC;
  logic [DATA_WIDTH-1:0]         PCNext;
  logic [DATA_WIDTH-1:0]         PCPlus4;

// Instruction Memory
  //logic                        PC;
  logic [DATA_WIDTH-1:0]         Instr;
  
// Sign Extend
  logic [24:0]                   Instr_31_7;
  //logic [1:0]                  ImmSrc;
  logic [DATA_WIDTH-1:0]         ImmExt;

// Control Unit
  logic [OP_WIDTH-1:0]           op;
  logic [FUNCT3_WIDTH-1:0]       funct3;
  logic                          funct7_5;
  logic                          PCSrc;
  logic                          ResultSrc;
  logic                          MemWrite;
  logic [ALU_CTRL_WIDTH-1:0]     ALUControl;
  logic                          ALUSrc;
  logic [IMM_SRC_WIDTH-1:0]      ImmSrc;
  logic                          RegWrite;
  logic                          WE3;

// ALU
  logic [DATA_WIDTH-1:0]         SrcA;
  logic [DATA_WIDTH-1:0]         SrcB;
  logic [DATA_WIDTH-1:0]         ALUResult;
  logic                          Zero;

// Data Memory
  //CLK
  //logic [DATA_WIDTH-1:0]       ALUResult;
  //logic [2:0]                  ALUControl;
  logic [DATA_WIDTH-1:0]         WriteData;
  logic [DATA_WIDTH-1:0]         ReadData;

// Register File
  //CLK
  logic [REG_ADDR_WIDTH-1:0]     A1;
  logic [REG_ADDR_WIDTH-1:0]     A2;
  logic [REG_ADDR_WIDTH-1:0]     A3;
  logic [DATA_WIDTH-1:0]         Result;
  //logic [DATA_WIDTH-1:0]       SrcA;
  //logic [DATA_WIDTH-1:0]       WriteData; RD2 output.

// linking wires
  logic [DATA_WIDTH-1:0]         PCTarget;


// extractions from Instruction
  assign op         = Instr[6:0];
  assign funct3     = Instr[14:12];
  assign funct7_5   = Instr[30];
  assign Instr_31_7 = Instr[31:7];
  assign A1         = Instr[19:15];
  assign A2         = Instr[24:20];
  assign A3         = Instr[11:7];


pc riscPC (
  .CLK        (CLK),
  .RST        (RST),
  .PCNext     (PCNext),
  .PC         (PC)
);

instr_mem riscInstrMem (
  .A          (PC[4:0]),
  .RD         (Instr)
);

control_unit #(
  .OP_WIDTH (OP_WIDTH),
  .FUNCT3_WIDTH (FUNCT3_WIDTH),
  .ALU_CTRL_WIDTH (ALU_CTRL_WIDTH),
  .IMM_SRC_WIDTH (IMM_SRC_WIDTH),
  .ALU_OP_WIDTH (ALU_OP_WIDTH)
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
  .RegWrite   (RegWrite)
);

sign_extend # (
  .DATA_WIDTH (DATA_WIDTH),
  .IMM_SRC_WIDTH (IMM_SRC_WIDTH)
)
riscSignExtend (
  .Instr      (Instr),
  .ImmSrc     (ImmSrc),
  .ImmOp      (ImmExt)
);

reg_file riscRegFile (
  .CLK        (CLK),
  .A1         (A1),
  .A2         (A2),
  .A3         (A3),
  .WE3        (RegWrite),
  .RD1        (SrcA),
  .RD2        (WriteData),
  .WD3        (Result),
  .a0         (a0)
);

alu riscALU (
  .SrcA        (SrcA),
  .SrcB        (SrcB),
  .ALUControl  (ALUControl),
  .ALUResult   (ALUResult),
  .Zero        (Zero)
);

data_mem riscDataMem (
  .CLK         (CLK),
  .A           (ALUResult[8:0]),
  .WD          (WriteData),
  .WE          (MemWrite),
  .RD          (ReadData)
);

// MUXs
assign SrcB     = ALUSrc    ? ImmExt   : WriteData;
assign Result   = ResultSrc ? ReadData : ALUResult;
assign PCNext   = PCSrc     ? PCTarget : PCPlus4;

// Adders
assign PCTarget = PC + ImmExt;
assign PCPlus4  = PC + 4;

endmodule
