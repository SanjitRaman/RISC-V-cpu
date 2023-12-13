module pc #(
    parameter DATA_WIDTH = 32
) (
    input  logic                  CLK,
    input  logic                  RST,
    input  logic                  EN,
    input  logic [DATA_WIDTH-1:0] PCNext,
    output logic [DATA_WIDTH-1:0] PC
);

    always_ff @ (posedge CLK, negedge RST) begin
        if (RST) PC <= 32'h0;
        else if (!EN) PC <= PCNext;
    end
endmodule