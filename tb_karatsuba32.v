module tb_karatsuba32;
    logic clk, rst, start;
    logic [31:0] A, B;
    logic valid_out;
    logic [63:0] P;

    karatsuba32 uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B),
        .valid_out(valid_out),
        .P(P)
    );

    always #5 clk = ~clk;  // 100MHz-like

    // Task to feed inputs and wait for output
    task test_mul(input [31:0] a_val, input [31:0] b_val);
        begin
            A = a_val;
            B = b_val;
            start = 1;
            #10 start = 0;        // single-cycle pulse
            wait(valid_out);      // wait until the multiplier says output is ready
            #1;                   // small delay to latch result
            $display("Time %0t | %0d * %0d = %0d | Got = %0d", 
                     $time, a_val, b_val, a_val*b_val, P);
        end
    endtask

    initial begin
        clk = 0; rst = 1; start = 0; A = 0; B = 0;
        #10 rst = 0;

        // Feed inputs one by one
        test_mul(32'd12345, 32'd6789);
        test_mul(32'd1000, 32'd2000);
        test_mul(32'd500, 32'd600);
        test_mul(32'd123, 32'd456);

        #20 $finish;
    end
endmodule
