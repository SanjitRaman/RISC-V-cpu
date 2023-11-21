module sinegen #(
  parameter WIDTH = 32
)(
  // interface signals
  input  logic             clk,      // clock 
  input  logic             rst,      // reset 
  output logic [WIDTH-1:0] a0       // sine output
);

  logic PC;
  logic  PCsrc;    
  logic  [WIDTH-1:0]       ImmOp;
  logic  [WIDTH-1:0]       instr;
  logic EQ;
  logic [1:0] ImmSrc;
  logic [WIDTH-1:0] regOp2;
  logic RegWrite;
  logic [WIDTH-1:0] ALUop1;
  logic [WIDTH-1:0] ALUop2;
  logic [2:0] ALUctrl;
  logic ALUsrc;
  logic [WIDTH-1:0] ALUout;


pc myPC (
  .clk (clk),
  .rst (rst),
  .ImmOp (ImmOp),
  .PCsrc (PCsrc), 
  .PC (PC),
);  

rom myRom (
  .clk (clk),
  .A (PC),
  .RD (instr),
);

control_unit myControlUnit (
  .instr (instr),
  .EQ (EQ),
  .PCsrc (PCsrc),
  .Immsrc (ImmSrc),
  .ALUsrc (ALUsrc),
  .ALUctrl (ALUctrl),
  .RegWrite (RegWrite), 
);

sign_extend mySignExtend (
  .instr (instr),
  .immSrc (ImmSrc),
  .immOp (ImmOp),
)

reg_file myRegFile (
  .clk (clk),
  .AD1 (instr[19:15]),
  .AD2 (instr[24:20]),
  .AD3 (instr[11:7]),
  .WE3 (RegWrite),
  .WD3 (ALUout),
  .RD1 (ALUop1),
  .RD2 (regOp2),
  .a0 (a0),
);

assign ALUop2 = ALUsrc ? ImmOp : regOp2;

alu myALU (
  ALUop1 (ALUop1),
  ALUop2 (ALUop2),
  ALUctrl (ALUctrl),
  ALUout (ALUout),
  EQ (EQ),
);

endmodule
