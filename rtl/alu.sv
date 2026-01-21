module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  op,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        // default to avoid latches
        result = 32'd0;

        case (op)
            3'b000: result = a + b; // ADD
            3'b001: result = a - b; // SUB
            3'b010: result = a & b; // AND
            3'b011: result = a | b; // OR
            3'b100: result = a ^ b; // XOR
            3'b101: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (signed)
            default: result = 32'd0;
        endcase
    end

    // zero flag
    always_comb begin
        zero = (result == 32'd0);
    end

endmodule
