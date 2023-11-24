module pc #(
    parameter PC_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic [PC_WIDTH-1:0] next_PC,
    output logic [PC_WIDTH-1:0] PC
);

    always_ff @ (posedge clk)
        if (rst) PC <= {PC_WIDTH{1'b0}};
        else PC <= next_PC;

endmodule
