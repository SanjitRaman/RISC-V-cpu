module cache #(
    parameter DATA_WIDTH = 32,
    parameter TAG_WIDTH = 27,
    parameter SET_ADDRESS_WIDTH = 3, 
    parameter BYTE_WIDTH = 8

) (
    input logic CLK,
    input logic RST, 
    input logic WE0,
    input logic WE1,
    input logic WE2,
    input logic WE3,
    input logic MemRead,
    input logic MemWrite, 
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

    int CACHE_WIDTH = (2 + TAG_WIDTH + DATA_WIDTH);

    logic [CACHE_WIDTH-1:0] cache_array [2**SET_ADDRESS_WIDTH-1:0];
    logic [SET_ADDRESS_WIDTH-1:0] set;
    logic V;
    logic D;
    logic [TAG_WIDTH-1:0] tag;
    logic [TAG_WIDTH-1:0] tagc;
    logic [CACHE_WIDTH-1:0] CIN;

assign tag = A[DATA_WIDTH-1:5]
assign set = A[4:2]; // 8 sets (3 bits)


always_ff @(posedge RST) begin
    hit <= 0;
    WE0Cache <= 0;
    WE1Cache <= 0;
    WE2Cache <= 0;
    WE3Cache <= 0;
    ACache <= 0;
    WDCache <= 0;
    RD <= 0;
end

always_ff @(posedge CLK) begin
    tagc = cache_array[set][DATA_WIDTH+TAG_WIDTH-1:DATA_WIDTH];

    if(MemRead) begin
        RD <= cache_array[set][DATA_WIDTH-1:0];
        hit <= (cache_array[set][CACHE_WIDTH-1] && (tag == tagc));
    end
    
     if(MemWrite) begin
        V = cache_array[set][CACHE_WIDTH-2]
        D = cache_array[set][CACHE_WIDTH-1]
        if(~V) begin
            // Cache - {Dirty, Valid, Tag, Write data}
            cache_array[set] <= {2'b11, tag, ({BYTE_WIDTH{WE3}} & WD[31:24]), ({BYTE_WIDTH{WE2}} & WD[23:16]), ({BYTE_WIDTH{WE1}} & WD[15:8]), ({BYTE_WIDTH{WE0}} & WD[7:0])};
            WE0Cache <= 0;
            WE1Cache <= 0;
            WE2Cache <= 0;
            WE3Cache <= 0;
        end
        else begin
            WDCache <= cache_array[set][DATA_WIDTH-1:0];
            ACache  <= {cache_array[set][tagc], set, 2'b00};
            WE0Cache <= 1;
            WE1Cache <= 1;
            WE2Cache <= 1;
            WE3Cache <= 1;
            cache_array[set] <= {2'b11, tag, ({BYTE_WIDTH{WE3}} & WD[31:24]), ({BYTE_WIDTH{WE2}} & WD[23:16]), ({BYTE_WIDTH{WE1}} & WD[15:8]), ({BYTE_WIDTH{WE0}} & WD[7:0])};
        end
    end
end

always_ff @(negedge CLK) begin
    if(MemRead) begin
        A[set] <= {2'b01, tag, ({BYTE_WIDTH{WE3}} & WD[31:24]), ({BYTE_WIDTH{WE2}} & WD[23:16]), ({BYTE_WIDTH{WE1}} & WD[15:8]), ({BYTE_WIDTH{WE0}} & WD[7:0])};
    end
end

endmodule
