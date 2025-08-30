module mult16(
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [15:0] A,
    input  logic [15:0] B,
    output logic        done,
    output logic [31:0] P
);

    logic busy;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            P    <= 32'b0;
            done <= 0;
            busy <= 0;
        end else begin
            if (start && !busy) begin
                // Perform multiplication
                P    <= A * B;
                done <= 1;    // Keep 'done' high until next start
                busy <= 1;
            end else if (!start) begin
                // Reset handshake when start goes low
                done <= 0;
                busy <= 0;
            end
        end
    end
endmodule
