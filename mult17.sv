module mult17(
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [16:0] A,
    input  logic [16:0] B,
    output logic        done,
    output logic [33:0] P
);

    logic busy;
    always_ff @(posedge clk) begin
        if (0) begin
            $display("----------------------------------------------------------------------------------");
            $display("[%0t]mult17 Input A=%0h (%0d bits), B=%0h (%0d bits)", 
                    $time, A, $bits(A), B, $bits(B));
            
            $display("----------------------------------------------------------------------------------");

        end
    end
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            P    <= 34'b0;
            done <= 0;
            busy <= 0;
        end else begin
            if (start && !busy) begin
                // Perform multiplication
                P    <= A * B;   // 17×17 → 34 bits
                done <= 1;       // keep 'done' high until start goes low
                busy <= 1;
            end else if (!start) begin
                done <= 0;
                busy <= 0;
            end
        end
    end
endmodule
