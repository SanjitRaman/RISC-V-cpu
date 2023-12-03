module main_decoder #(
    parameter                         IMM_SRC_WIDTH = 2,
    parameter                         ALU_OP_WIDTH = 2,
    parameter                         OP_WIDTH = 7
) (
    input logic [OP_WIDTH-1:0]        op,

    output logic                      RegWrite,
    output logic [IMM_SRC_WIDTH-1:0]  ImmSrc,
    output logic                      ALUSrc,
    output logic                      MemWrite,
    output logic                      ResultSrc,
    output logic                      Branch,
    output logic [ALU_OP_WIDTH-1:0]   ALUOp
);
    // From Table in Lecture 7 Slide 18 
    always_comb begin
        case (op)
            7'b0000011: // Load Word (lw)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 2'b00;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    ResultSrc = 1'b1;
                    Branch    = 1'b0;
                    ALUOp     = 2'b00;
                end
            7'b0100011: // Store Word (sw)
                begin
                    RegWrite  = 1'b0;
                    ImmSrc    = 2'b01;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b1;
                    ResultSrc = 1'b0; // X
                    Branch    = 1'b0;
                    ALUOp     = 2'b00;
                end
            7'b0110011: // R-Type 
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 2'b00;
                    ALUSrc    = 1'b0; // X
                    MemWrite  = 1'b0;
                    ResultSrc = 1'b0;
                    Branch    = 1'b0;
                    ALUOp     = 2'b10;
                end
            7'b0010011: // I-Type (addi, slli, slti, sltiu, xori, srli, srai, ori, andi)
                begin
                    RegWrite  = 1'b1;
                    ImmSrc    = 2'b00;
                    ALUSrc    = 1'b1;
                    MemWrite  = 1'b0;
                    ResultSrc = 1'b0;
                    Branch    = 1'b0;
                    ALUOp     = 2'b10;
                end
            7'b1100011: // B-type (beq, bne, blt, bge, bltu, bgeu)
                begin
                    RegWrite  = 1'b0;
                    ImmSrc    = 2'b10;
                    ALUSrc    = 1'b0;
                    MemWrite  = 1'b0;
                    ResultSrc = 1'b0; // X
                    Branch    = 1'b1;
                    ALUOp     = 2'b01;
                end
            default:
                begin
                    RegWrite  = 0;
                    ImmSrc    = 2'b00;
                    ALUSrc    = 0;
                    MemWrite  = 0;
                    ResultSrc = 0;
                    Branch    = 0;
                    ALUOp     = 2'b00;
                end
        endcase
    end


endmodule
