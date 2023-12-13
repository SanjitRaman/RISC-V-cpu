module main_decoder #(
    parameter                         IMM_SRC_WIDTH = 3,
    parameter                         ALU_OP_WIDTH = 3,
    parameter                         OP_WIDTH = 7
) (
    input logic [OP_WIDTH-1:0]        op,

    output logic                      RegWrite,
    output logic [IMM_SRC_WIDTH-1:0]  ImmSrc,
    output logic                      ALUSrc,
    output logic                      MemWrite, MemRead,
    output logic [1:0]                ResultSrc,
    output logic                      Branch,
    output logic [ALU_OP_WIDTH-1:0]   ALUOp,
    output logic                      Jump
);
    // From Table in Lecture 7 Slide 18 
    always_comb begin
        case (op)
            7'b0000011: // Load Word (lw)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b000;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b1;
                    ResultSrc = 2'b01;
                    Branch    = 1'b0;
                    ALUOp     = 3'b000;
                    Jump      = 1'b0;
                end
            7'b0100011: // Store Word (sw)
                begin
                    RegWrite  = 1'b0;
                    ImmSrc    = 3'b001;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b1;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00; // X
                    Branch    = 1'b0;
                    ALUOp     = 3'b000;
                    Jump      = 1'b0;
                end
            7'b0110011: // R-Type 
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b000;
                    ALUSrc    = 1'b0; // X
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00;
                    Branch    = 1'b0;
                    ALUOp     = 3'b010;
                    Jump      = 1'b0;
                end
            7'b0010011: // I-Type (addi, slli, slti, sltiu, xori, srli, srai, ori, andi)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b000;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00;
                    Branch    = 1'b0;
                    ALUOp     = 3'b010;
                    Jump      = 1'b0;
                end
            7'b1100011: // B-type (beq, bne, blt, bge, bltu, bgeu)
                begin
                    RegWrite  = 1'b0;
                    ImmSrc    = 3'b010;
                    ALUSrc    = 1'b0;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00; // X
                    Branch    = 1'b1;
                    ALUOp     = 3'b001;
                    Jump      = 1'b0;
                end
            7'b0010111: // U-type (Load upper immediate + PC)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b011;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b10;
                    Branch    = 1'b0;
                    ALUOp     = 3'b100;
                    Jump      = 1'b0;
                end
            7'b0110111: // U-type (Load upper immediate)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b011;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00;
                    Branch    = 1'b0;
                    ALUOp     = 3'b100;
                    Jump      = 1'b0;
                end
            7'b01100111: // JALR
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b000;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b10;
                    Branch    = 1'b1;
                    ALUOp     = 3'b011;
                    Jump      = 1'b1;
                end
            7'b1101111: // JAL 
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 3'b100;
                    ALUSrc    = 1'b0;
                    MemWrite  = 1'b0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b11;
                    Branch    = 1'b1;
                    ALUOp     = 3'b100;
                    Jump      = 1'b0;
                end
            default:
                begin
                    RegWrite  = 0;
                    ImmSrc    = 3'b000;
                    ALUSrc    = 0;
                    MemWrite  = 0;
                    MemRead   = 1'b0;
                    ResultSrc = 2'b00;
                    Branch    = 0;
                    ALUOp     = 3'b000;
                    Jump      = 1;
                end
        endcase
    end


endmodule
