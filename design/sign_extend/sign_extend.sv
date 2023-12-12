module sign_extend #(
    parameter DATA_WIDTH = 32,
    parameter IMM_SRC_WIDTH = 3
) (
    input  logic [DATA_WIDTH-1:0]    Instr,
    input  logic [IMM_SRC_WIDTH-1:0] ImmSrc,
    output logic [DATA_WIDTH-1:0]    ImmOp

);

    always_comb
        case (ImmSrc)
            3'b000:   ImmOp = {{20{Instr[31]}}, Instr[31:20]};
            3'b001:   ImmOp = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            3'b010:   ImmOp = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            3'b011:   ImmOp = {Instr[31:12], 12'b0};
            3'b100:   ImmOp = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
            default:  ImmOp = {{20{Instr[31]}}, Instr[31:20]};
        endcase
    
endmodule
