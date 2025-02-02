//Verilog HDL for "FA24SP25Analog", "FSM_big" "functional"

// Define state encodings using `parameter`
`define SAMPLE    4'b0000
`define BIT7      4'b0001
`define BIT6      4'b0010
`define BIT5      4'b0011
`define BIT4      4'b0100
`define BIT3      4'b0101
`define BIT2      4'b0110
`define BIT1      4'b0111
`define BIT0      4'b1000

module FSM_big (
    input wire RESET,          // Reset signal
    input wire CLK,            // Clock signal
    input wire VCOMP, 		 // Comparator Output
    output reg [6:0] OUTEN,	 // Enables the smaller FSMs
    output reg SAR_RESET,		 // SAR Reset signal
    output reg LSBOUT			 // Captures the LSB Value as it's not stored elsewhere
);

    // State registers
    reg [3:0] current_state, next_state;


    // State update  and output to small FSM logic (Moore)
    always @(*) begin
        case (current_state)
            `SAMPLE: begin next_state = `BIT7;   OUTEN = 7'b0000000; SAR_RESET = 1'b1; end
            `BIT7:   begin next_state = `BIT6;   OUTEN = 7'b1000000; SAR_RESET = 1'b0; end
            `BIT6:   begin next_state = `BIT5;   OUTEN = 7'b0100000; SAR_RESET = 1'b0; end
            `BIT5:   begin next_state = `BIT4;   OUTEN = 7'b0010000; SAR_RESET = 1'b0; end
            `BIT4:   begin next_state = `BIT3;   OUTEN = 7'b0001000; SAR_RESET = 1'b0; end
            `BIT3:   begin next_state = `BIT2;   OUTEN = 7'b0000100; SAR_RESET = 1'b0; end
            `BIT2:   begin next_state = `BIT1;   OUTEN = 7'b0000010; SAR_RESET = 1'b0; end
            `BIT1:   begin next_state = `BIT0;   OUTEN = 7'b0000001; SAR_RESET = 1'b0; end
            `BIT0:   begin next_state = `SAMPLE; OUTEN = 7'b0000000; SAR_RESET = 1'b0; end
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



