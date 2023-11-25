module alu #(
    parameter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 3
)(
    input logic [DATA_WIDTH-1:0] SrcA,
    input logic [DATA_WIDTH-1:0] SrcB,
    input logic [ALU_CTRL_WIDTH-1:0] ALUControl,
    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic Zero
);

// 000 - add
// 001 - subtract
// 101 - set less than
// 011 - or
// 010 - and

always_comb begin
    case(ALUControl)
        3'b000: ALUResult = SrcA + SrcB;
        3'b001: ALUResult = SrcA - SrcB;
        3'b101: ALUResult = (SrcA < SrcB) ? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}};
        3'b011: ALUResult = SrcA | SrcB;
        3'b010: ALUResult = SrcA & SrcB;
        default: ALUResult = SrcA + SrcB;
    endcase
    Zero = ({DATA_WIDTH{1'b0}} == (SrcA ^ SrcB)) ? 1'b1 : 1'b0;
end

endmodule
