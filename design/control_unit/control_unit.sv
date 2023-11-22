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

    logic [6:0]                       op;
    logic [2:0]                       funct3;
    logic                             funct7_5;
    logic                             branch;
    logic [1:0]                       alu_op;

    main_decoder
    
endmodule