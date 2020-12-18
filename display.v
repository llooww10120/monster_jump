module display(up,C,R_o,clk,b_clock,col,rst,led1_c,led2_c,led3_c,led4_c,bain_clk,vv_clk);
input clk,up,b_clock,rst,bain_clk,vv_clk;

output reg[7:0]C=8'b10000000;
output reg[7:0]R_o;
reg[7:0]R[7:0];
reg[2:0]R_s=3'b000;
wire[7:0]icon[2:0];

integer i=0;
assign icon[2]=8'b00110000;
assign icon[1]=8'b00100000;
assign icon[0]=8'b01100000;
parameter b= 40'b0000_0000_0001_0000_1100_0000_1110_0000_1111_0000;
reg [39:0]barrier_out = b;
wire rand_num;
output [0:7]led1_c,led2_c,led3_c,led4_c;
output reg col=0;
reg co;
reg [7:0]next_barrier=8'b11110000;
reg[3:0]temp=4'b1111;
reg[2:0]da=3'b000;
reg[2:0]tt;
always@(posedge clk)begin
	if(!col)begin
		R_s=R_s+1'b1;
		case(R_s)
			3'b000:R_o=R[7];
			3'b001:R_o=R[6];
			3'b010:R_o=R[5];
			3'b011:R_o=R[4];
			3'b100:R_o=R[3];
			3'b101:R_o=R[2];
			3'b110:R_o=R[1]|barrier_out[39:32];
			3'b111:R_o=R[0]|barrier_out[39:32];
		endcase
		if(C==8'b00000001)C=8'b10000000;
		else begin
			C=C>>1;
		end
	end
	else begin
		R_o=8'b00000000;
		R_s=3'b000;
		C=8'b10000000;
	end
end
always@(up)begin

	if(up)begin
		R[7]=8'o0;
		R[6]=8'o0;
		R[5]=icon[2];
		R[4]=icon[1];
		R[3]=icon[0];
		R[2]=8'o0;
		R[1]=8'o0;
		R[0]=8'o0;
	end
	else begin
		R[7]=8'o0;
		R[6]=8'o0;
		R[5]=8'o0;
		R[4]=8'o0;
		R[3]=8'o0;
		R[2]=icon[2];
		R[1]=icon[1];
		R[0]=icon[0];
	end
	col=barrier_out[37]&R[0][5];

end

dp d1(clk,barrier_out[31:24],led1_c,col);
dp d2(clk,barrier_out[23:16],led2_c,col);
dp d3(clk,barrier_out[15:8],led3_c,col);
dp d4(clk,barrier_out[7:0],led4_c,col);

always@(posedge b_clock,negedge rst)begin
	if(!rst)barrier_out=b;
	else if(col) begin
		barrier_out=b;
	end
	else begin 
		barrier_out={barrier_out[38:0],next_barrier[da]};
		if(da==3'b111)da=3'b000;
		else da=da+1'b1;
	end
end

always@(posedge bain_clk,negedge rst)begin
	if(!rst)next_barrier=8'b0;
	next_barrier={4'b0000,temp};
end

always@(posedge vv_clk,negedge rst)begin
	if(!rst)tt=3'b000;
	else tt=tt+3'b001;
end
always@(tt)begin
	case(tt)
		3'b000:temp=4'b0100;
		3'b001:temp=4'b1100;
		3'b010:temp=4'b0111;
		3'b011:temp=4'b1111;
		3'b101:temp=4'b1000;
		3'b110:temp=4'b0010;
		3'b111:temp=4'b1100;
	endcase
end
endmodule

module dp(clk,barrier,R_o,col);
input clk,col;
input [7:0]barrier;
output reg[7:0]R_o;
reg [2:0]R_s=3'b000;
always@(posedge clk)begin
if(!col)begin
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
end
else begin
	R_o=8'b00000000;
	R_s=3'b000;
end
end
endmodule
