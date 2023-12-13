module reg_file_d #(
    parameter ADDRESS_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input  logic                            CLK,
    input  logic                            CLR, 
    input  logic                            EN,
    input  logic [DATA_WIDTH-1:0]           RD,
    input  logic [DATA_WIDTH-1:0]           PCF,
    input  logic [DATA_WIDTH-1:0]           PCPlus4F,
    
    output  logic [DATA_WIDTH-1:0]          InstrD,
    output  logic [DATA_WIDTH-1:0]          PCD, 
    output  logic [DATA_WIDTH-1:0]          PCPlus4D
);

always_ff @(posedge CLK) begin
    if(CLR)  begin
        // Flush
        InstrD <= 32'b0;
        PCD <= 32'b0;
        PCPlus4D <= 32'b0;
    end
    else if(!EN) begin
        InstrD <= RD;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end
end
endmodule
