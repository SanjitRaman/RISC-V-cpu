module control_unit #(
    parameter OP_WIDTH = 7,
    parameter FUNCT3_WIDTH = 3,
    parameter ALU_CTRL_WIDTH = 3,
    parameter IMM_SRC_WIDTH = 2,
    parameter ALU_OP_WIDTH = 2
) (
    input logic [OP_WIDTH-1:0]        op,
    input logic [FUNCT3_WIDTH-1:0]    funct3,
    input logic                       funct7_5,
    input logic                       Zero,

    output logic                      PCSrc,
    output logic                      ResultSrc,
    output logic                      MemWrite
    output logic [ALU_CTRL_WIDTH-1:0] ALUControl,
    output logic                      ALUSrc,
    output logic [IMM_SRC_WIDTH-1:0]  ImmSrc,
    output logic                      RegWrite
);

    logic [ALU_OP_WIDTH-1:0]          ALUOp;
    logic                             op_5;


    main_decoder  #(
        .IMM_SRC_WIDTH(IMM_SRC_WIDTH),
        .ALU_OP_WIDTH(ALU_OP_WIDTH)
    ) 
    main_decoder (
        .op(op),
        .Branch(Branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    alu_decoder #(
        .OP_WIDTH(OP_WIDTH),
        .FUNCT3_WIDTH(FUNCT3_WIDTH),
        .ALU_OP_WIDTH(ALU_OP_WIDTH),
        .ALU_CTRL_WIDTH(ALU_CTRL_WIDTH)
    ) alu_decoder (
        .op_5(op_5),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    assign op_5 = op[5];
    assign PCSrc = Branch & Zero; // Branching logic




    
endmodule