module dp(clk,barrier,C,R_o);
input clk;
input [7:0]barrier;
output reg[7:0]C,R_o;
reg [2:0]R_s;
always@(posedge clk)begin
	
	R_s=R_s+1'b1;
	case(R_s)
		3'b000:R_o=8'b00000000;
		3'b001:R_o=8'b00000000;
		3'b010:R_o=8'b00000000;
		3'b011:R_o=8'b00000000;
		3'b100:R_o=8'b00000000;
		3'b101:R_o=8'b00000000;
		3'b110:R_o=barrier;
		3'b111:R_o=barrier;
	endcase
	if(C==8'b00000001)C=8'b10000000;
	else begin
		C=C>>1;
	end
end
endmodule
