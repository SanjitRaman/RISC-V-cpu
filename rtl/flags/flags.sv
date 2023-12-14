module flags #(
    parameter                      OP_WIDTH       = 7,
    parameter                      FUNCT3_WIDTH   = 3
)(

    input logic                       Zero,
    input logic                       N,
    input logic                       C,
    input logic                       V,
    input logic                       Branch,
    input logic [OP_WIDTH-1:0]        op,
    input logic [FUNCT3_WIDTH-1:0]    funct3,

    output logic                      PCSrc
);

    logic signed_greater_than;

    always_comb begin
        signed_greater_than = ((~N & ~V) |  Zero | (N & V));
        if({op[6:5], op[2:0]} == 5'b11111) // jal
            PCSrc = 1;
        else if ({op[6:5], op[1:0]} == 4'b1111) // b-type
            case (funct3)
                3'b000: // beq
                    PCSrc = Branch & Zero;
                3'b001: // bne
                    PCSrc = Branch & ~Zero;
                3'b100: // blt
                    PCSrc = Branch &  ~signed_greater_than;
                3'b101: // bge
                    PCSrc = Branch & signed_greater_than;
                3'b110: // bltu
                    PCSrc = Branch & C;
                3'b111: // bgeu
                    PCSrc = Branch & ~C;
                default: PCSrc = 0;
            endcase
        else
            PCSrc = 0;
    end  

endmodule
