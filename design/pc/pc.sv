module pc #(
    parameter DATA_WIDTH = 32
) (
    input  logic                  CLK,
    input  logic                  RST,
    input  logic [DATA_WIDTH-1:0] PCNext,
    output logic [DATA_WIDTH-1:0] PC
);

    always_ff @ (posedge CLK)
        if (RST) PC <= 32'hBFC00000;
        else PC <= PCNext;

endmodule
