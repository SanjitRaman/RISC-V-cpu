module sign_extend #(
    DATA_WIDTH = 32,
    IMM_SRC_WIDTH = 2
) (
    input logic [DATA_WIDTH-1:0] instr,
    input logic [IMM_SRC_WIDTH-1:0] immSrc,
    output logic [DATA_WIDTH-1:0] immOp

);

    always_comb
        case (immSrc)
            2'b00:   immOp = {{20{instr[31]}}, instr[31:20]};
            2'b01:   immOp = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            default: immOp = {{20{instr[31]}}, instr[31:20]};
        endcase
    
endmodule
