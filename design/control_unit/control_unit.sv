module control_unit #(
    paramter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3,
) (
    input logic [DATA_WIDTH-1:0]      instr,
    input logic                       EQ,
    
    output logic                      PCsrc, 
    output logic [ALU_CTRL_WIDTH-1:0] ALUctrl,
    output logic                      ALUsrc,
    output logic [1:0]                ImmSrc,
    output logic                      RegWrite
);
    
endmodule