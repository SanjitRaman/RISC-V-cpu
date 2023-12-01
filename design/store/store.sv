module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter ADDRESS_WIDTH = 9

)(
    input  logic [DATA_WIDTH-1:0]        RD,
    input  logic [2:0]               funct3,
    input  logic [DATA_WIDTH-1:0]       rs2,
    input  logic [ADDRESS_WIDTH-1:0]      A,
    output logic [DATA_WIDTH-1:0]        WD
);

logic [1:0] bytepos;
logic       halfpos;
assign bytepos = A % 4;
assign halfpos = A % 2;

always_comb
    case (funct3)
        3'b000: begin //store byte (sb)
            case (bytepos)
                2'b00: begin
                    WD[BYTE_WIDTH-1:0] = rs2[BYTE_WIDTH-1:0];
                    WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
          
            2'b01: begin
                    WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= rs2[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
          
            2'b10: begin
                    WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= rs2[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
          
            2'b11: begin
                    WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= rs2[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
          
            default: begin
                    WD[BYTE_WIDTH-1:0] = rs2[BYTE_WIDTH-1:0];
                    WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
            endcase
        end
      
        3'b001: begin //store half (sh)
            if(halfpos) begin
                WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= rs2[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= rs2[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
            end
            else begin
                WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= rs2[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= rs2[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
            end
        end
      
        3'b010: begin //store word (sw)
            WD[BYTE_WIDTH-1:0] = rs2[BYTE_WIDTH-1:0];
            WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= rs2[2*BYTE_WIDTH-1:BYTE_WIDTH];
            WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= rs2[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
            WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= rs2[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
        end
      
        default: begin
            WD[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            WD[2*BYTE_WIDTH-1:BYTE_WIDTH] <= RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
            WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH] <= RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
            WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH] <= RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
        end
endmodule
