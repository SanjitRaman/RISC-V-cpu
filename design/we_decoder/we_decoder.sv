module we_decoder #(
    parameter OP_WIDTH = 7
)
(
    input  logic [2:0]               funct3,
    input  logic [OP_WIDTH-1:0]      op,
    input  logic                     MemWrite, MemRead,
    output logic                     WE0,
    output logic                     WE1,
    output logic                     WE2,
    output logic                     WE3
);

logic EN;
assign EN = MemWrite | MemRead;

always_comb
    if (EN && (op == 7'd35)) begin
        case (funct3)
            //store byte (sb)
            3'b000:
                begin
                    WE3 = 1'b0;
                    WE2 = 1'b0;
                    WE1 = 1'b0;
                    WE0 = 1'b1;
                end
            //store half (sh)
            3'b001: 
                begin
                    WE3 = 1'b0;
                    WE2 = 1'b0;
                    WE1 = 1'b1;
                    WE0 = 1'b1;
                end

            //store word (sw)
            3'b010: 
                begin
                    WE3 = 1'b1;
                    WE2 = 1'b1;
                    WE1 = 1'b1;
                    WE0 = 1'b1;
                end

            // default: don't write to show that something is wrong
            // in the instruction
            default:
                begin
                    WE3 = 1'b0;
                    WE2 = 1'b0;
                    WE1 = 1'b0;
                    WE0 = 1'b0;
                end
        endcase
    end
    else if (EN && (op == 7'd3)) begin
        WE3 = 1'b1;
        WE2 = 1'b1;
        WE1 = 1'b1;
        WE0 = 1'b1;
    end
    else begin
        WE3 = 1'b0;
        WE2 = 1'b0;
        WE1 = 1'b0;
        WE0 = 1'b0;
    end
    

endmodule

