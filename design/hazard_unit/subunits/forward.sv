module forward #(
    parameter ADDRESS_WIDTH = 5,
    parameter FORWARD_WIDTH = 2
) (
    input logic [ADDRESS_WIDTH-1:0] RdM,
    input logic [ADDRESS_WIDTH-1:0] RsE,
    input logic [ADDRESS_WIDTH-1:0] RdW,
    input logic                     RegWriteM,
    input logic                     RegWriteW,
    output logic [FORWARD_WIDTH-1:0] ForwardE
);
always_comb begin
    if ((RsE == RdM) & (RegWriteM) & (RsE != 0)) begin
        ForwardE = 2'b10;
    end else if (((RsE == RdW) & RegWriteW) & (RsE != 0)) begin
        ForwardE = 2'b01;
    end else begin
        ForwardE = 2'b00;
    end
end


endmodule


