module alu #(
    parameter DATA_WIDTH = 32,
    parameter ALU_CTRL_WIDTH = 4,
    parameter SHIFT_WIDTH = 5
)(
    input  logic [DATA_WIDTH-1:0]     SrcA,
    input  logic [DATA_WIDTH-1:0]     SrcB,
    input  logic [ALU_CTRL_WIDTH-1:0] ALUControl,
    input  logic [DATA_WIDTH-1:0]     PC,
    output logic [DATA_WIDTH-1:0]     ALUResult,
    output logic                      Zero
);

// 0000 - add
// 0001 - subtract
// 0010 - shift left logical
// 0011 - set less than
// 0100 - set less than unsigned 
// 0101 - xor 
// 0110 - shift right logical 
// 0111 - shift right illogical 
// 1000 - or
// 1001 - and
// 1010 - load upper + pc
// 1011 - load upper
// 1100 - jal (store pc+4 to register)

logic signs = {SrcA[DATA_WIDTH-1], SrcB[DATA_WIDTH-1]} ;

always_comb begin
    case(ALUControl)
        4'b0000:  ALUResult = SrcA + SrcB;
        4'b0001:  ALUResult = SrcA - SrcB;
        4'b0010:  ALUResult = (SrcA<<SrcB[SHIFT_WIDTH-1:0]);
        4'b0011:  case{signs}:
                    00: ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH{1'b0}};
                    01: ALUResult = {DATA_WIDTH-1{1'b0}};
                    10: ALUResult = {{DATA_WIDTH-1{1'b0}}, {1'b1}};
                    11: ALUResult = (SrcA[DATA_WIDTH-2:0] < SrcB[DATA_WIDTH-2:0]) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH-1{1'b0}};
                    default: ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH-1{1'b0}};
                endcase
        4'b0100:  ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH-1{1'b0}};
        4'b0101:  ALUResult = SrcA ^ SrcB;
        4'b0110:  ALUResult = (SrcA>>SrcB[SHIFT_WIDTH-1:0]);
        4'b0111:  ALUResult = (SrcA>>>SrcB[SHIFT_WIDTH-1:0]);
        4'b1000:  ALUResult = SrcA | SrcB;
        4'b1001:  ALUResult = SrcA & SrcB;
        4'b1010:  ALUResult = (SrcB<<12) + PC;
        4'b1011:  ALUResult = SrcB<<12; 
        4'b1100:  ALUResult = PC + 4;
        default:  ALUResult = SrcA + SrcB;
    endcase
    Zero = ({DATA_WIDTH-1{1'b0}} == ALUResult) ? 1'b1 : 1'b0;
end

endmodule
