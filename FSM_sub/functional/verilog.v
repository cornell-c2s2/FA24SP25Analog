//Verilog HDL for "FA24SP25Analog", "FSM_sub" "functional"

// Define state encodings using `parameter`
`define COMP_HIGH  2'b01  // Set VOUT to "10"
`define COMP_LOW   2'b10  // Set VOUT to "01"
`define RESET      2'b11  // Set VOUT to "11"
module FSM_sub (
    input wire VCOMP,       // Input to determine VOUT value
    input wire VRESET,      // Reset signal
    input wire VENABLE,     // Enable signal
    input wire CLK,         // Clock signal
    output reg [2:0] VOUT,  // 3-bit output signal
	output reg BITOUT	  // Stores the output for that bit
);

    // State registers
    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            `RESET: begin
                if (VRESET)
                    next_state = `RESET;
                else if (VENABLE)
                    next_state = (VCOMP) ? `COMP_HIGH : `COMP_LOW;
                else
                    next_state = `RESET;
            end
            `COMP_HIGH: begin
                if (VRESET)
                    next_state = `RESET;
                else if (!VENABLE)
                    next_state = `COMP_HIGH;
                else if (!VCOMP)
                    next_state = `COMP_LOW;
                else
                    next_state = `COMP_HIGH;
            end
            `COMP_LOW: begin
                if (VRESET)
                    next_state = `RESET;
                else if (!VENABLE)
                    next_state = `COMP_LOW;
                else if (VCOMP)
                    next_state = `COMP_HIGH;
                else
                    next_state = `COMP_LOW;
            end
            default: next_state = `RESET; // Default state
        endcase
    end

    // State update logic (sequential)
    always @(posedge CLK or posedge VRESET) begin
        if (VRESET)
            current_state <= `RESET; // Go to RESET state
        else
            current_state <= next_state; // Update state
    end

    always @(posedge CLK) begin
        case (current_state)
            `RESET:     begin BITOUT <= BITOUT; end // Set VOUT to "100" in RESET, inferred latch, but we want it. FIX FOR GOOD CODING CONVENTION
            `COMP_HIGH: begin BITOUT <= 1'b1; end // Set VOUT to "10"
            `COMP_LOW:  begin BITOUT <= 1'b0; end // Set VOUT to "01"
            default:    begin BITOUT <= 1'b0; end // Default to "11"
        endcase
    end


    // Output logic (Mealy: depends on state and inputs)
    always @(*) begin
        case (current_state)
            `RESET:     begin VOUT = 3'b100; end // Set VOUT to "100" in RESET, inferred latch, but we want it. FIX FOR GOOD CODING CONVENTION
            `COMP_HIGH: begin VOUT = 3'b001; end // Set VOUT to "10"
            `COMP_LOW:  begin VOUT = 3'b010; end // Set VOUT to "01"
            default:    begin VOUT = 3'b100; end // Default to "11"
        endcase
    end

endmodule