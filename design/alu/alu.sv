module alu #(
    parameter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3
)(
    input logic ALUop1,
    input logic ALUop2,
    input logic ALUctrl,
    output logic ALUout,
    output logic EQ
);

// 000 - add
// 001 - subtract
// 101 - set less than
// 011 - or
// 010 - and

endmodule
