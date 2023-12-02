module ld_decoder #(
    parameter DATA_WIDTH = 32
) (
    input  logic [DATA_WIDTH-1:0] RD,
    input  logic [           2:0] funct3,
    output logic [DATA_WIDTH-1:0] RDOut
);

  always_comb
    case (funct3)
      // Load byte (lb)
      3'b000: RDOut = {{(DATA_WIDTH - 8){RD[7]}}, RD[7:0]};
      // Load Half (lh)         
      3'b001: RDOut = {{(DATA_WIDTH - 16){RD[7]}}, RD[7:0], RD[15:8]};

      // Load word (lw)
      3'b010: RDOut = {RD[7:0], RD[15:8], RD[23:16], RD[31:24]};

      // Load byte unsigned (lbu)
      3'b100: RDOut = {{(DATA_WIDTH - 8){1'b0}}, RD[7:0]};

      // Load half unsigned (lhu)
      3'b101: RDOut = {{(DATA_WIDTH - 16){1'b0}}, RD[7:0], RD[15:8]};

      // default: don't write to show that something is wrong
      default: RDOut = {DATA_WIDTH{1'b0}};
    endcase

endmodule
