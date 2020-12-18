module divider(clk,d_clock,rst,div_f);
input clk,rst;
output reg d_clock;//clock after divider
reg[10:0]divide_counter;//count for divider
input [7:0]div_f;//what frequency you want to divide
//divider
always@(posedge clk,negedge rst)
	if(!rst)divide_counter<=0;
	else if(divide_counter==div_f)divide_counter<=0;
	else divide_counter<=divide_counter+1;
always@(negedge clk,negedge rst)
	if(!rst)d_clock<=0;
	else if(divide_counter<(div_f/2+1))d_clock<=0;
	else d_clock<=1;
endmodule
