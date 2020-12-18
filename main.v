module main(clk,rst,up,led_c,led_r,col,led1_r,led2_r,led3_r,led4_r);
input clk,up,rst;
output col;
output [0:7]led_c,led_r,led1_r,led2_r,led3_r,led4_r;
wire barrier_clock;
wire con_up;
divider divider_barrier(clk,barrier_clock,rst,16'd250);
divider divider_bain(clk,bain_clock,rst,16'd2000);
divider divider_vv(clk,vv_clk,rst,16'd1234);
controll(up,clk,con_up);
display dp1(con_up,led_r,led_c,clk,barrier_clock,col,rst,led1_r,led2_r,led3_r,led4_r,bain_clk,vv_clk);

endmodule
