module alu_decoder #(
    parameter                         OP_WIDTH       = 7,
    parameter                         FUNCT3_WIDTH   = 3,
    parameter                         ALU_OP_WIDTH   = 2,
    parameter                         ALU_CTRL_WIDTH = 3


) (
    input logic [OP_WIDTH-1:0]        op,
    input logic [FUNCT3_WIDTH-1:0]    funct3,
    input logic                       funct7_5,
    input logic [ALU_OP_WIDTH-1:0]    ALUOp

    output logic [ALU_CTRL_WIDTH-1:0] ALUControl;
);

    logic [1:0]                       op_5_funct_5_5;
    
    assign op_5_funct_5_5 = {op[5], funct7_5};

    // From Table in Lecture 7 Slide 19
    always_comb
        case (ALUOp)
            2'b00:                                      // Load/Store (lw/sw)
                ALUControl = 3'b000;                    //      add
            2'b01:                                      // Branch (beq)
                ALUControl = 3'b001;                    //      subtract
            2'b10:                                      // R-Type
                case (funct3)
                    3'b000:
                        if (op_5_funct_5_5 == 2'b11)
                            ALUControl = 3'b001;        // subtract
                        else
                            ALUControl = 3'b000;        // add
                    3'b010:
                        ALUControl = 3'b010;            // slt
                    3'b110:
                        ALUControl = 3'b011             // or
                    3'b111:
                        ALUControl = 3'b010;            // and
                    default:
                        ALUControl = 3'b000;            // add
                endcase
            default:
                ALUControl = 3'b000;                    // add

        endcase
    
endmodule
