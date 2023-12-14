module lwstall #(
    parameter ADDRESS_WIDTH = 5
) (
    input logic [ADDRESS_WIDTH-1:0] RdE,
    input logic [ADDRESS_WIDTH-1:0] Rs1D,
    input logic [ADDRESS_WIDTH-1:0] Rs2D,
    input logic                     ResultSrcE0,
    output logic                    lwstall
);
assign lwstall = ResultSrcE0 & ((RdE == Rs1D) | (RdE == Rs2D));

endmodule
