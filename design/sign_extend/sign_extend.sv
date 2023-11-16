module sign_extend #(
    DATA_WIDTH = 32,
    IMM_SRC_WIDTH = 2
) (
    input logic [DATA_WIDTH-1:0] instr,
    input logic [1:0] immSrc,
    output logic [DATA_WIDTH-1:0] immOp

);
    
endmodule
