
module tb_B;

    reg clk;
    reg rst;
    reg start;
    reg [3:0] Data_in1;
    reg [3:0] Data_in2;
    wire [127:0] Data_out;

    // Instantiate the B module
    B uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .Data_in1(Data_in1),
        .Data_in2(Data_in2),
        .Data_out(Data_out)
    );
    initial begin
        $dumpfile("wave.vcd");   // Name of VCD file
        $dumpvars(0, tb_B);
    end

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

        task send_64bit(input [63:0] num1, input [63:0] num2);
            integer i;
            begin
                for (i = 15; i >= 0; i = i - 1) begin
                    Data_in1 = num1[i*4 +: 4]; 
                    Data_in2 = num2[i*4 +: 4];
                    start = (i==15); // only first nibble pulses 'start'
                    @(posedge clk);
                end
                Data_in1 = 0;
                Data_in2 = 0;
                start = 0;
            end
        endtask


        initial begin
            rst = 1; start = 0; Data_in1 = 0; Data_in2 = 0;
            #10;            // 10ns reset pulse
            rst = 0;
        end

    initial begin
        // Initialize signals
        rst = 1; start = 0; Data_in1 = 0; Data_in2 = 0;
        @(posedge clk);
        rst = 0;
         send_64bit(64'h0000000000000001, 64'h0000000000000001); // 1 × 1 = 1

        send_64bit(64'h0000000000000002, 64'h0000000000000003); // 2 × 3 = 6

        // Send first numbers
        // Small test pairs for easy verification
        // send_64bit(64'h0000000000000010, 64'h0000000000000010); // 16 × 16 = 256
        // send_64bit(64'h0000000000000100, 64'h0000000000000100); // 256 × 256 = 65536
        // send_64bit(64'h0000000000001234, 64'h0000000000000010); // 4660 × 16 = 74560
        // send_64bit(64'h00000000000000FF, 64'h00000000000000FF); // 255 × 255 = 65025

        // Wait a few clocks to observe output
        repeat(50) @(posedge clk);

        $finish;
    end

    // Optional: monitor Data_out in the console
    initial begin
        $monitor("Time=%0t, Data_out=%h", $time, Data_out);
    end

endmodule

