module control_unit #(
    paramter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3,
) (
    input logic [DATA_WIDTH-1:0]      instr,
    input logic                       eq,
    
    output logic                      pc_src, 
    output logic                      result_src,
    output logic                      mem_write,
    output logic [ALU_CTRL_WIDTH-1:0] alu_ctrl,
    output logic                      alu_src,
    output logic [1:0]                imm_src,
    output logic                      reg_write
);
    
endmodule