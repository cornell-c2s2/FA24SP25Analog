//Verilog HDL for "FA24SP25Analog", "FSM_big" "functional"

// Define state encodings using `parameter`
`define SAMPLE    3'b000
`define BIT5      3'b001
`define BIT4      3'b010
`define BIT3      3'b011
`define BIT2      3'b100
`define BIT1      3'b101
`define BIT0      3'b110

module FSM_big (
    input wire RESET,          // Reset signal
    input wire CLK,            // Clock signal
    input wire VCOMP, 		 // Comparator Output
    output reg [4:0] OUTEN,	 // Enables the smaller FSMs
    output reg SAR_RESET,		 // SAR Reset signal
    output reg LSBOUT			 // Captures the LSB Value as it's not stored elsewhere
);

    // State registers
    reg [2:0] current_state, next_state;


    // State update  and output to small FSM logic (Moore)
    always @(*) begin
        case (current_state)
            `SAMPLE: begin next_state = `BIT5;   OUTEN = 5'b00000; SAR_RESET = 1'b1; end
            `BIT5:   begin next_state = `BIT4;   OUTEN = 5'b10000; SAR_RESET = 1'b0; end
            `BIT4:   begin next_state = `BIT3;   OUTEN = 5'b01000; SAR_RESET = 1'b0; end
            `BIT3:   begin next_state = `BIT2;   OUTEN = 5'b00100; SAR_RESET = 1'b0; end
            `BIT2:   begin next_state = `BIT1;   OUTEN = 5'b00010; SAR_RESET = 1'b0; end
            `BIT1:   begin next_state = `BIT0;   OUTEN = 5'b00001; SAR_RESET = 1'b0; end
            `BIT0:   begin next_state = `SAMPLE; OUTEN = 5'b00000; SAR_RESET = 1'b0; end
            default :  next_state = `SAMPLE;
        endcase
    end


    // State transtion register
    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            current_state <= `SAMPLE; // Go to RESET state
        else
            current_state <= next_state; // Update state
    end

    //FIX:  Grab last output for LSB (this needs to be combinational, make this SR latch?)
// CURSED verilog
     always @(*) begin
            LSBOUT <= VCOMP;     // When SARRST is high, capture the value of VCOMP
    end



endmodule



