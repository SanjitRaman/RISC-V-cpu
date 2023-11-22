module control_unit #(
    paramter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3,
    parameter OP_WIDTH = 7,
    parameter ALU_OP_WIDTH = 2,
    parameter FUNCT3_WIDTH = 3
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
    output logic [1:0]                ImmSrc,
    output logic                      RegWrite
);

    main_decoder  #(
        .OP_WIDTH(OP_WIDTH),
        .ALU_OP_WIDTH(ALU_OP_WIDTH)
    ) 
    main_decoder (
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );


    
endmodule