module ld_decoder #(
    parameter DATA_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter ADDRESS_WIDTH = 9

) (
    input  logic [DATA_WIDTH-1:0] RD,
    input  logic [           2:0] funct3,
    output logic [DATA_WIDTH-1:0] RDOut
);

  always_comb
    case (funct3)
      // Load byte (lb)
      3'b000: RDOut = {{(DATA_WIDTH - 7) {RD[7]}}, RD[6:0]};

      // Load Half (lh)         
      3'b001: RDOut = {{(DATA_WIDTH - 15) {RD[15]}}, RD[14:0]};

      // Load word (lw)
      3'b010: RDOut = RD;

      // Load byte unsigned (lbu)
      3'b100: RDOut = {{(DATA_WIDTH - 7) {1'b0}}, RD[6:0]};

      // Load half unsigned (lhu)
      3'b101: RDOut = {{(DATA_WIDTH - 15) {1'b0}}, RD[14:0]};

      // default: don't write to show that something is wrong
      default: RDOut = {DATA_WIDTH{1'b0}};
    endcase

endmodule
