module alu_tb;

    logic [31:0] a, b;
    logic [2:0]  op;
    logic [31:0] result;
    logic        zero;

    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    task automatic check(input logic [31:0] exp, input string name);
        begin
            #1;
            if (result !== exp) begin
                $display("FAIL %-20s  op=%b a=%0d b=%0d  got=%0d exp=%0d",
                         name, op, $signed(a), $signed(b), $signed(result), $signed(exp));
                $finish;
            end else begin
                $display("PASS %-20s  got=%0d", name, $signed(result));
            end
        end
    endtask

    initial begin
        // ADD
        a=32'd5; b=32'd3; op=3'b000; check(32'd8, "ADD 5+3");

        // SUB
        a=32'd5; b=32'd9; op=3'b001; check(32'hFFFFFFFC, "SUB 5-9"); // -4

        // AND/OR/XOR
        a=32'h0F0F0F0F; b=32'h00FF00FF; op=3'b010; check(32'h000F000F, "AND");
        op=3'b011; check(32'h0FFF0FFF, "OR");
        op=3'b100; check(32'h0FF00FF0, "XOR");

        // SLT signed cases
        a=32'hFFFFFFFF; b=32'd1; op=3'b101; check(32'd1, "SLT -1 < 1");
        a=32'd1; b=32'hFFFFFFFF; op=3'b101; check(32'd0, "SLT 1 < -1");
        a=32'hFFFFFFFB; b=32'hFFFFFFFD; op=3'b101; check(32'd1, "SLT -5 < -3");
        a=32'hFFFFFFFD; b=32'hFFFFFFFB; op=3'b101; check(32'd0, "SLT -3 < -5");

        // zero flag spot check
        a=32'd2; b=32'd2; op=3'b001; #1;
        if (zero !== 1'b1) begin
            $display("FAIL zero flag expected 1, got %b", zero);
            $finish;
        end else $display("PASS zero flag");

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
