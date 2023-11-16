module alu #(
    parameter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3
)(
    input logic [DATA_WIDTH-1:0] ALUop1,
    input logic [DATA_WIDTH-1:0] ALUop2,
    input logic [ALU_CTRL_WIDTH-1:0] ALUctrl,
    output logic [DATA_WIDTH-1:0] ALUout,
    output logic EQ
);

// 000 - add
// 001 - subtract
// 101 - set less than
// 011 - or
// 010 - and

always_comb begin
    case(ALUctrl)
        3'b000: ALUout = ALUop1 + ALUop2;
        3'b001: ALUout = ALUop1 - ALUop2;
        3'b101: ALUout = ALUop1 < ALUop2;
        3'b011: ALUout = ALUop1 | ALUop2;
        3'b101: ALUout = ALUop1 & ALUop2;
        default: ALUout = ALUop1 + ALUop2;
    endcase
    EQ = {[DATA_WIDTH]{1'b0}} || (ALUop1 ^ ALUop2);
end

endmodule
