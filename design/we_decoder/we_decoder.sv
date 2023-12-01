module we_decoder #()
(
    input  logic [2:0]               funct3,
    output logic                        WE0,
    output logic                        WE1,
    output logic                        WE2,
    output logic                        WE3,
);

always_comb
    case (funct3[1:0])
        //store byte (sb)
        2'b00:  {WE3, WE2, WE1, WE0} = {0 , 0 , 0 , 1};

        //store half (sh)
        2'b01: {WE3, WE2, WE1, WE0} = {0 , 0 , 1 , 1}; 

        //store word (sw)
        2'b10:  {WE3, WE2, WE1, WE0} = {1 , 1 , 1 , 1};

        // default: don't write to show that something is wrong
        // in the instruction
        default: {WE3, WE2, WE1, WE0} = {0 , 0 , 0 , 0};
    endcase
endmodule