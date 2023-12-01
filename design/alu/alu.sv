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
    output logic                      Zero,
    output logic                      N,
    output logic                      C, // carry out of adder
    output logic                      V // signed overflow
);
    
logic [1:0] signs;
assign signs = {SrcA[DATA_WIDTH-1], SrcB[DATA_WIDTH-1]};

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
// 1011 - load upper
    
always_comb begin
    case(ALUControl)
        4'b0000:  {C, ALUResult} = SrcA + SrcB;
        4'b0001:  {C, ALUResult} = SrcA - SrcB;
        4'b0010:  ALUResult = (SrcA<<SrcB[SHIFT_WIDTH-1:0]);
        4'b0011:  case(signs)
                    2'b00: ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH{1'b0}};
                    2'b01: ALUResult = {DATA_WIDTH{1'b0}};
                    2'b10: ALUResult = {{DATA_WIDTH-1{1'b0}}, {1'b1}};
                    2'b11: ALUResult = (SrcA[DATA_WIDTH-2:0] < SrcB[DATA_WIDTH-2:0]) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH{1'b0}};
                    default: ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH{1'b0}};
                endcase
        4'b0100:  ALUResult = (SrcA < SrcB) ? {{DATA_WIDTH-1{1'b0}}, {1'b1}} : {DATA_WIDTH{1'b0}};
        4'b0101:  ALUResult = SrcA ^ SrcB;
        4'b0110:  ALUResult = (SrcA>>SrcB[SHIFT_WIDTH-1:0]);
        4'b0111:  ALUResult = SrcA[31] ? ~({32{1'b1}}>>SrcB[SHIFT_WIDTH-1:0])| SrcA>>SrcB[SHIFT_WIDTH-1:0]: SrcA>>SrcB[SHIFT_WIDTH-1:0];
        4'b1000:  ALUResult = SrcA | SrcB;
        4'b1001:  ALUResult = SrcA & SrcB;
        4'b1011:  ALUResult = SrcB; 
        default:  ALUResult = {32{1'b0}};
    endcase
    
    Zero = ({DATA_WIDTH{1'b0}} == ALUResult) ? 1'b1 : 1'b0;
    N = ALUResult[DATA_WIDTH-1];
    V = (SrcA[DATA_WIDTH-1] == SrcB[DATA_WIDTH-1]) && (SrcA[DATA_WIDTH-1] != ALUResult[DATA_WIDTH-1]);
end

endmodule
