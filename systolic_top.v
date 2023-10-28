module systolic_top #(
    parameter ROW = 9,
    parameter COL = 64,
    parameter W_DATA = 8,
    parameter W_ADDR = 8,
    parameter RAM_DEPTH = (1 << W_ADDR),
    parameter TOTAL_BYTES = (ROW * COL)
)(
 input in_clk, 
    input in_sel,   //when sel = 1, weights will be loaded , otherwise data will be given as input into the systolic array
    input [(COL * 32) - 1:0] in_north,  //32 bit weight partial sum input 
    input [(ROW * 9) - 1:0] in_west,    //8 bit data input
    output [COL-1:0] out_sel, 
    output [(ROW * 9) - 1:0] out_east,  //32 bit output from last row
    output [(COL * 32) - 1:0] out_south,    //8 bit data output from the last column
    output [1:0] last_row_i_data_valid 
);

wire w_RX_DV;
wire [W_DATA-1 : 0] w_RX_Byte;

//clk = 100MHz, baud rate = 115200

wire select1;
wire select2;

wire [(COL * 32)-1:0] out_south_data;
wire [(ROW * 9)-1:0] out_east_data;

//data valid signal of last row's input into the systolic array used as write enable signal
//for fifo array which stores systolic array's 32 bit output
wire col_wren_dv;

wire select;
wire [(COL * 32)-1 :0] sa_weights;
wire [(ROW * 9)-1 :0] sa_data;



wire [(COL*32)-1:0] o_south_data;
wire [(ROW*9)-1:0] o_east_data;
wire [COL-1:0] sel_out;

wire [(COL * 32)-1 : 0] i_sa_north_data;

reg [(COL * 32)-1 : 0] north_w_p_sum= 0;




//systolic array design
systolic_array #(
    .ROW(9), 
    .COL(32), 
    .TOTAL_BYTES(288)
) systolic_array_star (
    .in_clk (in_clk), 
    .in_sel (in_sel), 
    .in_north (in_north[1023:0]), 
    .in_west (in_west), 
    .out_sel (out_sel[31:0]), 
    .out_east (temp), 
    .out_south (out_south[1023:0]),
    .last_row_i_data_valid(last_row_i_data_valid[0])
);

wire [80:0] temp;
systolic_array_vedic #(
    .ROW(9), 
    .COL(32), 
    .TOTAL_BYTES(288)
) systolic_array_custom (
    .in_clk (in_clk), 
    .in_sel (in_sel), 
    .in_north (in_north[2047:1024]), 
    .in_west (temp), 
    .out_sel (out_sel[63:32]), 
    .out_east (out_east), 
    .out_south (out_south[2047:1024]),
    .last_row_i_data_valid(last_row_i_data_valid[1])
);


wire column_dv;
wire row_dv;
wire [W_DATA-1:0] col_data_out;
wire [W_DATA-1:0] row_data_out;   





endmodule
