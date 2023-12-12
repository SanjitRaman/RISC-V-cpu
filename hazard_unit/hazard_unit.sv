module hazard_unit #(
    parameter ADDRESS_WIDTH = 5,
    parameter FORWARD_WIDTH = 2
) (
    // reminder: stallF and stallD are active low.
    input logic [ADDRESS_WIDTH-1:0] Rs1D,
    input logic [ADDRESS_WIDTH-1:0] Rs2D,
    input logic [ADDRESS_WIDTH-1:0] RdE,
    input logic [ADDRESS_WIDTH-1:0] Rs1E,
    input logic [ADDRESS_WIDTH-1:0] Rs2E,
    input logic                     PCSrcE,
    input logic                     ResultSrcE0,
    input logic [ADDRESS_WIDTH-1:0] RdM,
    input logic                     RegWriteM,
    input logic [ADDRESS_WIDTH-1:0] RdW,
    input logic                     RegWriteW,
    output logic                    StallF, StallD,
    output logic                    FlushD,
    output logic                    FlushE,
    output logic [FORWARD_WIDTH-1:0] ForwardAE,
    output logic [FORWARD_WIDTH-1:0] ForwardBE
);

    logic lwstall;

    lwstall # (
        .ADDRESS_WIDTH (ADDRESS_WIDTH)
    )
    riscHazardLwstall (
        .RdE (RdE),
        .Rs1D (Rs1D),
        .Rs2D (Rs2D),
        .ResultSrcE0 (ResultSrcE0),
        .lwstall (lwstall)
    );

    forward # (
        .ADDRESS_WIDTH (ADDRESS_WIDTH),
        .FORWARD_WIDTH (FORWARD_WIDTH)
    )
    forwarda (
        .RdM (RdM),
        .RsE (Rs1E),
        .RdW (RdW),
        .RegWriteM (RegWriteM),
        .RegWriteW (RegWriteW),
        .ForwardE (ForwardAE)
    );

    forward # (
        .ADDRESS_WIDTH (ADDRESS_WIDTH),
        .FORWARD_WIDTH (FORWARD_WIDTH)
    )
    forwardb (
        .RdM (RdM),
        .RsE (Rs2E),
        .RdW (RdW),
        .RegWriteM (RegWriteM),
        .RegWriteW (RegWriteW),
        .ForwardE (ForwardBE)
    );

assign FlushD = PCSrcE;
assign FlushE = PCSrcE | lwstall;
assign StallF = lwstall;
assign StallD = lwstall;

endmodule
