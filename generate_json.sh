#!/bin/bash

# Output JSON file
output="files.json"

# Placeholder for assignment information
assignment_info="SEER
Society for Electronics Engineering and Research
Digital Assignment

There is a system with a master-slave relation between 2 chips—A and B wherein A acts as the
master, B acts as the slave, and both share the same clock. Your task is to design a pipelined RTL
Model of B.

A sends 2 4-bit-wide signals encoding 2 64-bit numbers from MSB to LSB and a start signal indicating
data is valid or not, i.e., if the control signal is 1, B should start storing the encoded 64 bit numbers.

B employs a 64*64 multiplier to compute the product of the data received.
The 64×64-bit multiplier employed uses the Karatsuba multiplication algorithm to compute the output
The Karatsuba algorithm works by breaking down a large multiplication into smaller
multiplications, which helps in optimizing the hardware area.
In this design, a dual-layer Karatsuba multiplier should be used. This means that the large
multiplication is first divided into smaller multiplications, and then those smaller multiplications are
further divided again using the same Karatsuba approach.
Only one small multiplier is available in the design for area optimization. This multiplier should be
reused to compute all the partial products.
The control logic for sequencing these operations and combining the partial products into the final
64×64 result must be implemented using a finite state machine (FSM).
The clock latency of the multiplier designed must not be greater than the clock latency of the input
cycle for maximised efficiency.
Hint: Read the algorithm carefully and determine the most optimal multiplier that can be used.

A Reads/ B Writes

Note

Sample Module Header For B

Deliverables
A has a single 8-bit-wide signal to read the data. A sends a T_Ready control signal and only
reads when this signal is logic HIGH. The T_Ready signal can be logic LOW for a maximum
of 96 clock cycles, and all the data must be sent to A in order of its execution from LSB to
MSB. Set up a buffer to ensure no data is overwritten.

If B has no data left and the T_Ready signal is HIGH, B shall parse 1111.
The A Writes/B Reads and the Execution stages must be independent and pipelined ie a
new input can be taken during the execution of the previous cycle.
First input data comes with start = 1.
Ensure the Karatsuba 64*64 bit Multiplier can multiply for all possible combinations of the
inputs.

module B(
input clk,
input rst,
input t_ready,
input start,
input [3:0] Data_in1,
input [3:0] Data_in2,
output [7:0] Data_out
);

Verilog Code for the Design.
Testbench and simulation result for the created design.
Synthesis and Implementation Report for the created design. Include LUT, FF, and DSP
count for ZedBoard ZYNQ 7000.
STA Analysis—Give the maximum clock cycle achievable by the design, report the WNS
and WHS at this clock speed
NOTE: Each deliverable carries separate points

"

# List of files to include
files=("karatsuba34.sv" "karatsuba64.sv" "tb_B.sv" "B.sv" "mult18.sv")

# Start JSON
echo "{" > "$output"
echo "  \"assignment_info\": \"$assignment_info\"," >> "$output"
echo "  \"files\": [" >> "$output"

# Loop over files and add content
for f in "${files[@]}"; do
    if [[ -f "$f" ]]; then
        echo "    {" >> "$output"
        echo "      \"filename\": \"$f\"," >> "$output"
        # Read file content, escape quotes and backslashes
        content=$(sed 's/\\/\\\\/g; s/"/\\"/g' "$f" | awk '{printf "%s\\n", $0}')
        echo "      \"content\": \"$content\"" >> "$output"
        echo "    }," >> "$output"
    else
        echo "Warning: $f not found"
    fi
done

# Remove the last comma (for valid JSON)
sed -i '$ s/},$/}/' "$output"

# Close JSON
echo "  ]" >> "$output"
echo "}" >> "$output"

echo "JSON file '$output' created successfully."
