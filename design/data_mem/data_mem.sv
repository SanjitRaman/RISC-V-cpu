module data_mem #(
    parameter ADDRESS_WIDTH = 9,
    parameter BYTE_WIDTH    = 8,
    parameter DATA_WIDTH    = 32

)(
    input  logic                     CLK,
    input  logic                     WE,
    input  logic [ADDRESS_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0]    WD,
    input  logic [2:0]               funct3,
    output logic [DATA_WIDTH-1:0]    RD
);

logic [BYTE_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram.");
    $readmemh("sineram.mem", ram_array);
end;

always_ff @(posedge CLK)
    if (WE == 1'b1) begin
        ram_array[A] <= WD[BYTE_WIDTH-1:0];
        ram_array[A+1] <= WD[2*BYTE_WIDTH-1:BYTE_WIDTH];
        ram_array[A+2] <= WD[3*BYTE_WIDTH-1:2*BYTE_WIDTH];
        ram_array[A+3] <= WD[4*BYTE_WIDTH-1:3*BYTE_WIDTH]; // this will be a problem for sw: individual bytes are not written to.
    end

always_comb begin
        case (funct3)
            3'b000: // Load byte (lb)
                begin
                    RD = {{24{1'bA[31]}}, ram_array[A]};
                end
            3'b001: // Load Half (lh)
                begin
                    RD = {{16{1'bA[31]}}, ram_array[A+1], ram_array[A]};
                end
            3'b010: // Load word (lw) 
                begin
                    RD = {ram_array[A+3], ram_array[A+2], ram_array[A+1], ram_array[A]};
                end
            3'b100: // Load byte unsigned (lbu)
                begin
                    RD = {{24{1'b0}}, ram_array[A]};
                end
            3'b101: // Load half unsigned (lhu)
                begin
                    RD = {{16{1'b0}}, ram_array[A+1], ram_array[A]};
                end
            default:
                begin
                    RD = {32{1'b0}};
                end
        endcase
    end
endmodule
