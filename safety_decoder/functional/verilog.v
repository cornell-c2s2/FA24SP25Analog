//Verilog HDL for "FA24SP25Analog", "safety_decoder" "functional"


module safety_decoder (
	input [1:0] IN,
	output reg [2:0] OUT
);

always @(*) begin
	case(IN)
      2'b01    : OUT = 3'b001;
      2'b10    : OUT = 3'b010;
	  2'b11    : OUT = 3'b100;
      default  : OUT = 3'b000;
    endcase
end

endmodule
