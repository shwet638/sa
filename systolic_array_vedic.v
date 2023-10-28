module systolic_array_vedic #(
    parameter ROW = 9, 
    parameter COL = 32, 
    parameter TOTAL_BYTES = ROW * COL
)(  input in_clk, 
    input in_sel,   //when sel = 1, weights will be loaded , otherwise data will be given as input into the systolic array
    input [(COL * 32) - 1:0] in_north,  //32 bit weight partial sum input 
    input [(ROW * 9) - 1:0] in_west,    //8 bit data input
    output [COL-1:0] out_sel, 
    output [(ROW * 9) - 1:0] out_east,  //32 bit output from last row
    output [(COL * 32) - 1:0] out_south,    //8 bit data output from the last column
    output last_row_i_data_valid    //shows the validity of input 8 bit data which is going into the last row of systolic array
);

wire [(ROW* 9) - 1 : 0] data_to_be_passed;  //8 bit input data to being fetched from registers goes as input into the first column of systolic array

assign last_row_i_data_valid = data_to_be_passed[8];

pe_grid_vedic #(.ROWS (ROW),
    .COLS (COL)
) top_instance (.i_clk (in_clk),
    .i_sel (in_sel), 
    .i_west_data (data_to_be_passed), 
    .i_north_data (in_north), 
    .o_sel (out_sel),  
    .o_data_32 (out_south),
    .o_data_8 (out_east)
);

//registers for providing row wise delay to the input data
reg_module_vedic #(
    .ROW (ROW)
) delay_reg (
    .in_clk (in_clk), 
    .in_west (in_west) ,
    .data_to_be_passed (data_to_be_passed)
);

endmodule

/* Multiple registers are generated by this module for each row t provide delay 
to the inputs coming into rows of the systolic array */
module reg_module_vedic #(
    parameter ROW = 9
)(  input in_clk, 
    input [(ROW * 9) - 1 : 0] in_west,
    output [(ROW * 9) - 1 : 0] data_to_be_passed
);

assign data_to_be_passed [80:72] = in_west[80:72];

genvar i , j;
    generate
    for (i = 0; i < ROW; i = i + 1) begin: FOR_ROW
        for (j = 0; j < i; j = j + 1) begin: FC_IN
        wire [8:0] data_out_reg;
            if (j == 0 && j == i - 1) begin
                data_reg_vedic dr (
                    .clk(in_clk),
                    .o_data(data_to_be_passed[(ROW - i) * 9 - 1 -: 9]),
                    .i_data(in_west[(ROW - i) * 9 - 1 -: 9])
                );
            end else if (j == 0) begin
                data_reg_vedic dr (
                    .clk(in_clk),
                    .o_data(data_out_reg),
                    .i_data(in_west[(ROW - i) * 9 - 1 -: 9])
                );
            end else if (j == i - 1) begin
                data_reg_vedic dr (
                    .clk(in_clk),
                    .o_data(data_to_be_passed[(ROW - i) * 9 - 1 -: 9]),
                    .i_data(FOR_ROW[i].FC_IN[j-1].data_out_reg)
                );
            end else begin
                data_reg_vedic dr (
                    .clk(in_clk),
                    .o_data(data_out_reg),
                    .i_data(FOR_ROW[i].FC_IN[j-1].data_out_reg)
                );
            end
        end
    end
endgenerate

endmodule    

//Delay is provided to the inputs of rows in systolic array by storing it into this register
module data_reg_vedic(
    input clk, 
    input [8:0] i_data, 
    output reg [8:0] o_data= 0
); 
always @(posedge clk) begin 
    o_data <= i_data; 
end 

endmodule