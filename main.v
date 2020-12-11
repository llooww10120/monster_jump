module main(clk,rst,start,up,down,led_c,led_r,col,led1_r,led2_r,led3_r,led4_r);
input clk,up,down,start,rst;
output col;
output [0:7]led_c,led_r,led1_r,led2_r,led3_r,led4_r;
wire [39:0]barrier;
wire barrier_clock,controll_clock;
divider divider_barrier(clk,barrier_clock,rst,8'd500);
divider divider_controll(clk,controll_clock,rst,8'd1000);

//barrier_pro p1(rst,barrier_clock,barrier);
controll(up,down,clk,con_up,con_down);
display dp1(con_up,con_down,led_r,led_c,clk,barrier_clock,col,rst,barrier,led1_r,led2_r,led3_r,led4_r);
/**
dp d1(barrier_clock,8'b0000_1000,led1_c);
dp d2(barrier_clock,8'b0000_1000,led2_c);
dp d3(barrier_clock,8'b0000_1000,led3_c);
dp d4(barrier_clock,8'b0000_1000,led4_c);
**/
endmodule
