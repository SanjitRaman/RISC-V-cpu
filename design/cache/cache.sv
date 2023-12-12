module cache #(
    parameter DATA_WIDTH = 32,
    parameter SET_ADDRESS_WIDTH = 2, 
    parameter BYTE_WIDTH = 8,
    TAG_WIDTH = DATA_WIDTH - SET_ADDRESS_WIDTH - 2,
    WAYS = 2,
    CACHE_WIDTH = (2 + TAG_WIDTH + DATA_WIDTH) * WAYS
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
    output logic WECache, // merge into one signal that is used for all of them 
    output logic WE0Cache, 
    output logic WE1Cache,
    output logic WE2Cache,
    output logic WE3Cache,
    output logic [DATA_WIDTH-1:0] ACache,
    output logic [DATA_WIDTH-1:0] WDCache,
    output logic [DATA_WIDTH-1:0] RD

);

    logic [SET_ADDRESS_WIDTH-1:0] set;
    logic [TAG_WIDTH-1:0] tag;
    assign tag = A[DATA_WIDTH-1:SET_ADDRESS_WIDTH+2];
    assign set = A[SET_ADDRESS_WIDTH+1:2]; // 4 sets (2 bits)

    logic [CACHE_WIDTH-1:0] cache_array [2**SET_ADDRESS_WIDTH-1:0];
    logic V0;
    logic D0;
    logic V1;
    logic D1;
    logic [TAG_WIDTH-1:0] tag0;
    logic [TAG_WIDTH-1:0] tag1;

    logic hit0;
    logic hit1;


always_ff @(posedge RST) begin
    hit <= 0;
    WECache <= 0;
    WE0Cache <= 0;
    WE1Cache <= 0;
    WE2Cache <= 0;
    WE3Cache <= 0;
    ACache <= 0;
    WDCache <= 0;
    RD <= 0;
end

always_ff @(posedge CLK) begin
    tag0 = cache_array[set][CACHE_WIDTH-3:CACHE_WIDTH-3-(TAG_WIDTH-1)];
    tag1 = cache_array[set][DATA_WIDTH+TAG_WIDTH-1:DATA_WIDTH];
    
    if(MemRead) begin
        hit0 = (cache_array[set][CACHE_WIDTH-2] && (tag == tag0));
        hit1 = (cache_array[set][(CACHE_WIDTH/2)-2] && (tag == tag0));
        RD <= hit1 ? cache_array[set][(CACHE_WIDTH/2)+(DATA_WIDTH-1):CACHE_WIDTH/2] : cache_array[set][DATA_WIDTH-1:0];
        hit <= hit0 | hit1;
    end

end

always_ff @(negedge CLK) begin
    tag0 = cache_array[set][CACHE_WIDTH-3:CACHE_WIDTH-3-(TAG_WIDTH-1)];
    tag1 = cache_array[set][DATA_WIDTH+TAG_WIDTH-1:DATA_WIDTH];
    D1 = cache_array[set][(CACHE_WIDTH/2)-1];

    if(MemRead & ~hit) begin
        WDCache <= cache_array[set][DATA_WIDTH-1:0];
        ACache  <= {cache_array[set][tag1], set, 2'b00};
        WECache <= D1;
        cache_array[set] <= ({2'b01, tag, 
                                ({BYTE_WIDTH{WE3}} & WD[31:24]), 
                                ({BYTE_WIDTH{WE2}} & WD[23:16]), 
                                ({BYTE_WIDTH{WE1}} & WD[15:8]), 
                                ({BYTE_WIDTH{WE0}} & WD[7:0]), 
                                {(CACHE_WIDTH/2){1'b0}}
                                }) 
                                | (cache_array[set]>>(CACHE_WIDTH/WAYS));
        
    end

    if(MemWrite) begin
        V0 = cache_array[set][CACHE_WIDTH-2];
        if(~V0) begin
            // Cache - {Dirty, Valid, Tag, Write data}
            cache_array[set] <= {2'b11, tag, 
            ({BYTE_WIDTH{WE3}} & WD[31:24]), 
            ({BYTE_WIDTH{WE2}} & WD[23:16]), 
            ({BYTE_WIDTH{WE1}} & WD[15:8]), 
            ({BYTE_WIDTH{WE0}} & WD[7:0]),
            {(CACHE_WIDTH/2){1'b0}}
            };
            WECache <= 0;
        end
        else begin
            WDCache <= cache_array[set][DATA_WIDTH-1:0];
            ACache  <= {cache_array[set][tag1], set, 2'b00};
            WECache <= D1;

            cache_array[set] <= ({2'b11, tag, 
                                ({BYTE_WIDTH{WE3}} & WD[31:24]), 
                                ({BYTE_WIDTH{WE2}} & WD[23:16]), 
                                ({BYTE_WIDTH{WE1}} & WD[15:8]), 
                                ({BYTE_WIDTH{WE0}} & WD[7:0]), 
                                {(CACHE_WIDTH/2){1'b0}}
                                }) 
                                | (cache_array[set]>>(CACHE_WIDTH/WAYS));

        end
    end

end

endmodule
