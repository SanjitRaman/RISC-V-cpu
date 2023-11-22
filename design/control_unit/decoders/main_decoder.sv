module main_decoder #(
    parameter IMM_SRC_WIDTH = 2,
    parameter ALU_OP_WIDTH = 2
) (
    input logic                       op_5,

    output logic                      Branch,
    output logic                      ResultSrc,
    output logic                      MemWrite,
    output logic                      ALUSrc,
    output logic [IMM_SRC_WIDTH-1:0]  ImmSrc,
    output logic                      RegWrite,
    output logic [ALU_OP_WIDTH-1:0]   ALUOp
);
    // From Table in Lecture 7 Slide 18 
    always_comb begin
        case (op)
            7'b0000011: // Load Word (lw)
                begin
                    RegWrite  = 1;
                    ImmSrc    = 2'b00;
                    ALUSrc    = 1;
                    MemWrite  = 0;
                    ResultSrc = 1;
                    Branch    = 0;
                    ALUOp     = 2'b00;
                end
            7'b0100011: // Store Word (sw)
                begin
                    RegWrite  = 0;
                    ImmSrc    = 2'b01;
                    ALUSrc    = 1;
                    MemWrite  = 1;
                 // ResultSrc = ;
                    Branch    = 0;
                    ALUOp     = 2'b00;
                end
            7'b0110011: // R-Type 
                begin
                    RegWrite  = 1;
                 // ImmSrc    = ;
                    ALUSrc    = 0;
                    MemWrite  = 0;
                    ResultSrc = 0;
                    Branch    = 0;
                    ALUOp     = 2'b10;
                end
            7'b1100011: // Branch (beq)
                begin
                    RegWrite  = 0;
                    ImmSrc    = 2'b10;
                    ALUSrc    = 0;
                    MemWrite  = 0;
                 // ResultSrc = ;
                    Branch    = 1;
                    ALUOp     = 2'b01;
                end
        endcase
    end


endmodule