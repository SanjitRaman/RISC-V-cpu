module pc #(
    parameter PC_WIDTH = 32
) (
    input logic CLK,
    input logic RST,
    input logic [PC_WIDTH-1:0] PCNext,
    output logic [PC_WIDTH-1:0] PC
);

    always_ff @ (negedge CLK)
        if (RST) PC <= {PC_WIDTH{1'b0}};
        else PC <= PCNext;

endmodule
