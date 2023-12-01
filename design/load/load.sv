module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter BYTE_WIDTH = 8,
    parameter ADDRESS_WIDTH = 9

)(
    input  logic [DATA_WIDTH-1:0]        RD,
    input  logic [2:0]               funct3,
    output logic [DATA_WIDTH-1:0]      RDout
);

always_comb begin
    case (funct3)
        3'b000: begin // Load byte (lb)
            RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{RD[7]}};
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[7]}};
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[7]}};
        end
                      
        3'b001: begin // Load Half (lh)
            RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{RD[15]}};
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{RD[15]}};   
        end       

        3'b010: begin // Load word (lw) 
            RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = RD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = RD[4*BYTE_WIDTH-1:3*BYTE_WIDTH];
        end

        3'b100: begin// Load byte unsigned (lbu)
            RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
        end
                
        3'b101: begin // Load half unsigned (lhu)
            RDout[BYTE_WIDTH-1:0] = RD[BYTE_WIDTH-1:0];
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = RD[2*BYTE_WIDTH-1:BYTE_WIDTH];
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};   
        end

        default: begin
            RDout[BYTE_WIDTH-1:0] = {8{1'b0}};
            RDout[2*BYTE_WIDTH-1:BYTE_WIDTH] = {8{1'b0}};
            RDout[3*BYTE_WIDTH-1:2*BYTE_WIDTH] = {8{1'b0}};
            RDout[4*BYTE_WIDTH-1:3*BYTE_WIDTH] = {8{1'b0}};
            end
    endcase
end

endmodule
