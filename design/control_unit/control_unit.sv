module control_unit #(
    parameter                         OP_WIDTH       = 7,
    parameter                         FUNCT3_WIDTH   = 3,
    parameter                         ALU_CTRL_WIDTH = 4,
    parameter                         IMM_SRC_WIDTH  = 3,
    parameter                         ALU_OP_WIDTH   = 3
) (
    input logic [OP_WIDTH-1:0]        op,
    input logic [FUNCT3_WIDTH-1:0]    funct3,
    input logic                       funct7_5,
    input logic                       Zero,
    input logic                       N,
    input logic                       C,
    input logic                       V,

    output logic                      PCSrc,
    output logic [1:0]                ResultSrc,
    output logic                      MemWrite,
    output logic [ALU_CTRL_WIDTH-1:0] ALUControl,
    output logic                      ALUSrc,
    output logic [IMM_SRC_WIDTH-1:0]  ImmSrc,
    output logic                      RegWrite,
    output logic                      Jump
);

    logic [ALU_OP_WIDTH-1:0]          ALUOp;
    logic                             Branch;
    logic                             signed_less_than;

    main_decoder  #(
        .IMM_SRC_WIDTH  (IMM_SRC_WIDTH),
        .ALU_OP_WIDTH   (ALU_OP_WIDTH)
    ) 
    main_decoder (
        .op             (op),
        .Branch         (Branch),
        .ResultSrc      (ResultSrc),
        .MemWrite       (MemWrite),
        .ALUSrc         (ALUSrc),
        .ImmSrc         (ImmSrc),
        .RegWrite       (RegWrite),
        .ALUOp          (ALUOp),
        .Jump           (Jump)
    );

    alu_decoder #(
        .OP_WIDTH       (OP_WIDTH),
        .FUNCT3_WIDTH   (FUNCT3_WIDTH),
        .ALU_OP_WIDTH   (ALU_OP_WIDTH),
        .ALU_CTRL_WIDTH (ALU_CTRL_WIDTH)
    ) alu_decoder (
        .op             (op),
        .funct3         (funct3),
        .funct7_5       (funct7_5),
        .ALUOp          (ALUOp),
        .ALUControl     (ALUControl)
    );

    always_comb begin
        signed_greater_than = (N ^ V) || (~N ^ Zero);
        if({op[6:5], op[2:0]} == 5'b11111) // jal
            PCSrc = 1;
        else if ({op[6:5], op[1:0]} == 4'b1111) // b-type
            case (funct3)
                3'b000: // beq
                    PCSrc = Branch & Zero;
                3'b001: // bne
                    PCSrc = Branch & ~Zero;
                3'b100: // blt
                    PCSrc = Branch &  ~signed_greater_than;
                3'b101: // bge
                    PCSrc = Branch & signed_greater_than;
                3'b110: // bltu
                    PCSrc = Branch & C;
                3'b111: // bgeu
                    PCSrc = Branch & ~C;
                default: PCSrc = 0;
            endcase
        else
            PCSrc = 0;
    end    
endmodule
