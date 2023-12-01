module pc_wrapper #(
    parameter DATA_WIDTH = 32
) (
    input logic [DATA_WIDTH-1:0] ImmExt,
    input logic                  PCsrc,
    input logic                  clk,
    input logic                  rst,
    output logic [DATA_WIDTH-1:0] PCOut
);


logic [DATA_WIDTH-1:0] PCTarget;
logic [DATA_WIDTH-1:0] PCPlus4;
logic [DATA_WIDTH-1:0] PCNext;
logic [DATA_WIDTH-1:0] PC;

always_comb begin
    PCPlus4 = PC + 4;
    PCTarget = PC + ImmExt;
    PCNext = PCsrc ? PCTarget : PCPlus4;
end

pc #(32) pc_reg (
    .CLK(clk),
    .RST(rst),
    .PCNext(PCNext),
    .PC(PC)
);

assign PCOut = PC;

endmodule
