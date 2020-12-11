module barrier_pro(rst,clk,barrier);
input rst,clk;
output reg[7:0]barrier;
reg [39:0]barrier_out = 40'b1000_1000_0000_0000_0000_0000_0100_1000_1001_0000;
wire rand_num;
LFSR LFSR1(rst,clk,rand_num);
always@(posedge clk,negedge rst)begin
	if(!rst)barrier_out<=0;
	else begin 
		barrier_out<={barrier_out[38:0],1'b1};
		barrier = barrier_out[39:32];
	end
end
endmodule



module LFSR(rst_n,clk,rand_num);
input rst_n,clk;     
output reg rand_num;
reg [2:0]Y_t=3'b000;
reg [8:1]Y = 8'b1001_0001;
parameter [8:1]Tap_Coefficient=8'b101110001; 
parameter [7:1]initial_state = 8'b1001_0001;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        Y   <=initial_state;
    else
        begin
			Y[1] <= Y[8];
			Y[2] <= Tap_Coefficient[7] ? Y[1] ^ Y[8] : Y[1];
			Y[3] <= Tap_Coefficient[6] ? Y[2] ^ Y[8] : Y[2];
			Y[4] <= Tap_Coefficient[5] ? Y[3] ^ Y[8] : Y[3];
			Y[5] <= Tap_Coefficient[4] ? Y[4] ^ Y[8] : Y[4];
			Y[6] <= Tap_Coefficient[3] ? Y[5] ^ Y[8] : Y[5];
			Y[7] <= Tap_Coefficient[2] ? Y[6] ^ Y[8] : Y[6];
			Y[8] <= Tap_Coefficient[1] ? Y[7] ^ Y[8] : Y[7];
			Y_t[2]<=Y[8];
			Y_t[1]<=Y_t[2];
			Y_t[0]<=Y_t[1];
		 if(Y_t>=6)begin
			rand_num<=1'b0;
			Y_t[2]<=0;
		end
		else
			rand_num<=Y_t[2];
        end
end

endmodule
