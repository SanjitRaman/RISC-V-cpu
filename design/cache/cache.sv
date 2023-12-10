module cache #(

) (
    input logic CLK,
    input logic RST, // TODO: implement reset set valid bit to 0 for everything.
    input logic WE0,
    input logic WE1,
    input logic WE2,
    input logic WE3,
    
    input logic [DATA_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] WD,
    
    output logic hit,

    output logic WE0Cache,
    output logic WE1Cache,
    output logic WE2Cache,
    output logic WE3Cache,
    output logic [DATA_WIDTH-1:0] ACache,
    output logic [DATA_WIDTH-1:0] WDCache,
    output logic [DATA_WIDTH-1:0] RD,



);

endmodule
