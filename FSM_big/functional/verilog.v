//Verilog HDL for "FA24SP25Analog", "FSM_big" "functional"

// Define state encodings using `parameter`
`define SAMPLE     3'b000  // Set VOUT to "10"
`define BIT0      3'b001  // Set VOUT to "01"
`define BIT1      3'b010  // Set VOUT to "11"
`define BIT2      3'b011
`define BIT3      3'b100

module FSM_big (
    input wire RESET,      // Reset signal
    input wire CLK,         // Clock signal
    input wire VCOMP, 
    output reg [2:0] OUTEN,
    output reg SARRST,
    output reg  LOUT
);

    // State registers
    reg [2:0] current_state, next_state;


    // State update  and output to small FSM logic (Moore)
    always @(*) begin
        case (current_state)
            `SAMPLE: begin next_state = `BIT0; OUTEN = 3'b000; SARRST = 1'b1; end
            `BIT0:   begin next_state = `BIT1; OUTEN = 3'b000; SARRST = 1'b0; end
            `BIT1:   begin next_state = `BIT2; OUTEN = 3'b001; SARRST = 1'b0; end
            `BIT2:   begin next_state = `BIT3; OUTEN = 3'b010; SARRST = 1'b0; end
            `BIT3:   begin next_state = `SAMPLE; OUTEN = 3'b100; SARRST = 1'b0;  end
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
     always @(*) begin
        if (SARRST) begin
            LOUT <= VCOMP;     // When SARRST is high, capture the value of d
        end
    end


endmodule



