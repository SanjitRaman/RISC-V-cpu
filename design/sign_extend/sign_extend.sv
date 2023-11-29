module sign_extend #(
    parameter DATA_WIDTH = 32,
    parameter IMM_SRC_WIDTH = 2
) (
    input  logic [DATA_WIDTH-1:0]    Instr,
    input  logic [IMM_SRC_WIDTH-1:0] ImmSrc,
    output logic [DATA_WIDTH-1:0]    ImmOp

);

    always_comb
        case (ImmSrc)
            2'b00:   ImmOp = {{20{Instr[31]}}, Instr[31:20]};
            2'b01:   ImmOp = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            2'b10:   ImmOp = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            2'b11:   ImmOp = {Instr[31:12], 12'b0}; // you can also use this for the jump instruction 
            //but whatever is decoding it will have to reorder the signal
            default: ImmOp = {{20{Instr[31]}}, Instr[31:20]};
        endcase
    
endmodule
