//Verilog HDL for "FA24SP25Analog", "DDS" "functional"
module DDS (
    input wire clk,                        // 50 MHz clock input
    input wire reset,                      // Synchronous reset
    input wire [9:0] freq_ctrl,            // 10-bit frequency control input
    output reg [5:0] ramp_out,             // 6-bit ramp wave output
    output reg square_out                  // 1-bit square wave output
);

    // Internal signal for phase accumulator
    reg [17:0] phase_acc;                  // 18-bit phase accumulator (6 MSBs used for output)

    // Phase accumulator process
    always @(posedge clk or posedge reset) begin
        if (reset) 
            phase_acc <= 18'd0;            // Reset phase accumulator
        else 
            phase_acc <= phase_acc + {6'd0, 2'b00, freq_ctrl}; // Accumulate frequency control
    end

    // Ramp wave and square wave generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ramp_out <= 6'd0;
            square_out <= 1'b0;
        end else begin
            ramp_out <= phase_acc[17:12];  // Ramp wave output (6 MSBs)
            square_out <= phase_acc[17];   // Square wave output (MSB)
        end
    end
endmodule
