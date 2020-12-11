module display(up,down,C,R_o,clk,b_clock,col,rst,barrier_out,led1_c,led2_c,led3_c,led4_c);
input clk,up,down,b_clock,rst;

output reg[7:0]C=8'b10000000;
output reg[7:0]R_o;
reg[7:0]R[7:0];
reg[2:0]R_s=3'b000;
wire[7:0]icon[2:0];

integer i=0;
assign icon[2]=8'b00110000;
assign icon[1]=8'b00100000;
assign icon[0]=8'b01100000;
output reg [39:0]barrier_out = 40'b0000_0000_0000_0000_0000_0000_0100_1000_1001_0000;
wire rand_num;
output [0:7]led1_c,led2_c,led3_c,led4_c;
output reg col=0;
reg co;
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
always@(up,down)begin

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
	else if(down)begin
		R[7]=8'o0;
		R[6]=8'o0;
		R[5]=8'o0;
		R[4]=8'o0;
		R[3]=8'o0;
		R[2]=8'o0;
		R[1]=icon[2];
		R[0]=icon[0];
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


LFSR LFSR1(rst,clk,rand_num);

always@(posedge b_clock,negedge rst)begin
	if(!rst)barrier_out=0;
	else if(col) begin
		barrier_out=40'b0000_0000_0000_0000_0000_0000_1000_0100_0001_0000;
	end
	else begin 
		barrier_out={barrier_out[38:0],rand_num};
		//led1_c=barrier_out[31:24];
		//led2_c=barrier_out[23:16];
		//led3_c=barrier_out[15:8];
		//led4_c=barrier_out[7:0];
	end
end
	
endmodule

module LFSR(rst_n,clk,rand_num);
input rst_n,clk;     
output reg rand_num;
reg [8:1]Y = 8'b1001_0001;
reg[2:0]state,next_state;
parameter [8:1]Tap_Coefficient=8'b101110001; 
parameter [7:1]initial_state = 8'b1001_0001;
parameter s0=3'b000,s1=3'b001,s10=3'b010,s101=3'b011,s100=3'b100,s1001=3'b101,s11=3'b110,s111=3'b111;
reg yy;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        Y   <=initial_state;
    else
        begin
			state<=next_state;
			Y[1] <= Y[8];
			Y[2] <= Tap_Coefficient[7] ? Y[1] ^ Y[8] : Y[1];
			Y[3] <= Tap_Coefficient[6] ? Y[2] ^ Y[8] : Y[2];
			Y[4] <= Tap_Coefficient[5] ? Y[3] ^ Y[8] : Y[3];
			Y[5] <= Tap_Coefficient[4] ? Y[4] ^ Y[8] : Y[4];
			Y[6] <= Tap_Coefficient[3] ? Y[5] ^ Y[8] : Y[5];
			Y[7] <= Tap_Coefficient[2] ? Y[6] ^ Y[8] : Y[6];
			Y[8] <= Tap_Coefficient[1] ? Y[7] ^ Y[8] : Y[7];
		end
	
end
always@(state)begin
	case(state)
		s0:begin
			rand_num=Y[8];
			if(Y[8])next_state=s1;
			else next_state=s0;
		end
		s1:begin
			rand_num=Y[8];
			if(Y[8])next_state=s11;
			else next_state=s10;
		end
		s10:begin
			rand_num=Y[8];
			if(Y[8])next_state=s101;
			else next_state=s100;
		end
		s101:begin
			rand_num=1'b0;
			next_state=s100;
		end
		s100:begin
			rand_num=Y[8];
			if(Y[8])next_state=s1001;
			else next_state=s0;
		end
		s1001:begin
			rand_num=1'b0;
			next_state=s0;
		end
		s11:begin
			rand_num=Y[8];
			if(Y[8])next_state=s111;
			else next_state=s0;
		end
		s111:begin
			next_state=s10;
			rand_num=1'b0;
		end
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
