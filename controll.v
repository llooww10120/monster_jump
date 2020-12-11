module controll(up,down,clk,con_up,con_down);
input up,down,clk;
output reg con_up,con_down;
reg[4:0]up_counter;//count for divider
//divider
always@(posedge clk,posedge up)
	if(up) begin
		if(up_counter==200)up_counter=0;
		up_counter=up_counter+1;
	end
	else up_counter=0;
always@(negedge clk,posedge up)
	if(up)begin
		if(up_counter<100)con_up=1;
		else con_up=0;
	end
	else 
		con_up=0;
endmodule
