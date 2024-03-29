module controll(up,clk,con_up);
input up,clk;
output reg con_up=1'b0;
reg up_b=1'b0;
reg[15:0]up_counter;//count for divider
//divider
always@(posedge clk)begin
	if(up&&!up_b)begin up_b=1'b1;end
	if(up_b) begin
		if(up_counter>=16'd1100)begin
			up_counter=1'b0;
			up_b=1'b0;
			con_up=1'b0;
		end
		else if(up_counter<16'd1100&&up_counter>15'b0)begin 
			con_up=1'b1;
		end 
		up_counter=up_counter+1'b1;
	
	end
	else begin
		up_counter=1'b0;
		up_b=1'b0;
		con_up=1'b0;
	end
end
endmodule
