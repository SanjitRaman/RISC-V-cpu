module cache #(
    parameter ADDRESS_WIDTH = 17,
    parameter DATA_WIDTH = 32,
    parameter BLOCK_WIDTH = 45,
    parameter SET_ADDRESS_WIDTH = 3,
    parameter TAG_WIDTH = 12
)(
    input logic CLK,
    input logic WE0, WE1, WE2, WE3,
    input logic [ADDRESS_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] WD,
    input logic [DATA_WIDTH-1:0] FoundData,
    

    output logic                 hit_o,
    output logic [DATA_WIDTH-1:0] RD
);

    logic [BLOCK_WIDTH-1:0] cache_array [2**SET_ADDRESS_WIDTH-1:0];
    logic                  hit;
    logic [TAG_WIDTH-1:0 ] A_tag;
    logic [SET_ADDRESS_WIDTH-1:0] A_set;
    logic valid;
    logic [DATA_WIDTH-1:0] cache_existing_data;

    always_comb begin
        A_tag = A[ADDRESS_WIDTH-1:SET_ADDRESS_WIDTH+2]; //2 for the byte offset
        A_set = A[1+SET_ADDRESS_WIDTH:2];
        valid = cache_array[A_set][BLOCK_WIDTH-1];
        hit = (A_tag == cache_array[A_set][BLOCK_WIDTH-2:DATA_WIDTH]) & valid; //May not need to be asynch
        hit_o = hit;
        cache_existing_data = cache_array[A_set][DATA_WIDTH-1:0];
        if (hit) begin
            //Read from cache
            RD = cache_array[A_set][DATA_WIDTH-1:0];
        end
        else begin
            RD = 0;
        end
    end
    always_ff @ (posedge CLK, negedge CLK) begin
        if (hit & CLK) begin
            //Write to cache
            cache_array[A_set] <= {1'b1, A_tag, WE3 ? WD[31:24] : cache_existing_data[31:24],
                                               WE2 ? WD[23:16] : cache_existing_data[23:16], 
                                               WE1 ? WD[15:8] : cache_existing_data[15:8], 
                                               WE0 ? WD[7:0] : cache_existing_data[7:0]};
        end
        else if (!CLK & !hit) begin
            //Write and not in cache then bypass cache
            //Don't care about WE3, WE2, WE1, WE0

            //Write the read data from data memory into cache
            if ({WE3, WE2, WE1, WE0} == 4'b0) begin
                cache_array[A_set] <= {1'b1, A_tag, FoundData};
            end
        end
        //Write to cache
    end
endmodule
