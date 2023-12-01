module alu_decoder #(
    parameter                         OP_WIDTH       = 7,
    parameter                         FUNCT3_WIDTH   = 3,
    parameter                         ALU_OP_WIDTH   = 3,
    parameter                         ALU_CTRL_WIDTH = 4


) (
    input logic  [OP_WIDTH-1:0]       op,
    input logic  [FUNCT3_WIDTH-1:0]   funct3,
    input logic                       funct7_5,
    input logic  [ALU_OP_WIDTH-1:0]   ALUOp,

    output logic [ALU_CTRL_WIDTH-1:0] ALUControl
);

    logic [1:0]                       op_5_funct_5_5;
    
    assign op_5_funct_5_5 = {op[5], funct7_5};

    always_comb
        case (ALUOp)
            3'b000:                                      // Load/Store (lw/sw)
                ALUControl = 4'b0000;                    //      add
            3'b001:                                      // Branch (beq)
                ALUControl = 4'b0001;                    //      subtract
            3'b100:
                ALUControl = 4'b1011;                    //U-Type and J-type

                
            3'b010:                                      // R-Type
                case (funct3)
                    3'b000:
                        if (op_5_funct_5_5 == 2'b11)
                            ALUControl = 4'b0001;           // subtract
                        else
                            ALUControl = 4'b0000;           // add
                    3'b001:
                            ALUControl = 4'b0010;           // sll 
                    3'b010:
                        ALUControl = 4'b0011;               // slt
                    3'b011:
                        ALUControl = 4'b0100;               // sltu
                    3'b100:
                        ALUControl = 4'b0101;               // xor
                    3'b101:
                        if (op_5_funct_5_5 == 2'b10)
                            ALUControl = 4'b0110;            // srl
                        else if (op_5_funct_5_5 == 2'b11)
                            ALUControl = 4'b0111;            // sra

                    3'b110:
                        ALUControl = 4'b011;                // or
                    3'b111:
                        ALUControl = 4'b010;                // and
                    default:
                        ALUControl = 4'b000;                // add
                endcase

            default:
                ALUControl = 4'b000;                        // add

        endcase
    
endmodule
