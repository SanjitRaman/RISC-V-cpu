module main_decoder #(
    
) (
    input logic [6:0] op,
    output logic branch,
    output logic result_src,
    output logic mem_write,
    output logic alu_src,
    output logic [1:0] alu_op,
    output logic [1:0] imm_src,
    output logic reg_write
);

    // from table in lecture 7 slide 18
    always_comb begin
        case(op):
            7'b0000011: // lw
            begin
                reg_write = 1'b1;;
                imm_src = 2'b00;
                alu_src = 1'b1;
                mem_write = 1'b0;
                result_src = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
            end

            7'b0100011: // sw
            begin
                reg_write = 1'b0;
                imm_src = 2'b01;
                alu_src = 1'b1;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
            end
            
            7'b0110011: // R-type
            begin
                reg_write = 1;

            end
        endcase
            
    end
endmodule