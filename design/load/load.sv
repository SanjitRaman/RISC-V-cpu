module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter ADDRESS_WIDTH = 9

)(
    input  logic [DATA_WIDTH-1:0]        RD,
    input  logic [2:0]               funct3,
    input  logic [ADDRESS_WIDTH-q:0]      A,
    output logic [DATA_WIDTH-1:0]      RDout
);

logic [1:0] bytepos;
logic       halfpos;
assign bytepos = A % 4;
assign halfpos = A % 2;

always_comb begin
    case (funct3)
        3'b000: begin // Load byte (lb)
            case (bytepos)
                2'b00: begin
                    RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{RD[7]}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[7]}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[7]}};
                end
                2'b01: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[15]}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[15]}};
                end
                2'b10: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[23]}};
                end
                2'b11: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
                default: begin
                    RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{RD[7]}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[7]}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[7]}};
                end
            endcase
        end
                      
        3'b001: begin // Load Half (lh)
            if(halfpos) begin
                RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];    
            end
            else begin
                RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[15]}};
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[15]}};   
            end       
        end

        3'b010: begin // Load word (lw) 
                RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
        end

        3'b100: begin// Load byte unsigned (lbu)
            case (bytepos)
                2'b00: begin
                    RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
                end
                2'b01: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
                end
                2'b10: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
                end
                2'b11: begin
                    RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
                end
                default: begin
                    RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                    RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                    RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                    RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
                end
            endcase
        end

        3'b101: begin // Load half unsigned (lhu)
            if(halfpos) begin
                RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];    
            end
            else begin
                RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};   
            end  
        end

        default:
            begin
                RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
                RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
                RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
                RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
            end
    endcase
end

endmodule
