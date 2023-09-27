module vga_avalon(input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] vga_red, output logic [7:0] vga_grn, output logic [7:0] vga_blu,
                  output logic vga_hsync, output logic vga_vsync, output logic vga_clk);

    
    // your Avalon slave implementation goes here
    logic [7:0] VGA_X;
    logic [6:0] VGA_Y;
    logic [8:0] VGA_COLOUR;

    logic [9:0] VGA_R_10;
    logic [9:0] VGA_B_10;
    logic [9:0] VGA_G_10;

    assign VGA_Y = readdata[30:24];
    assign VGA_X = readdata[23:16];
    assign VGA_COLOUR = readdata[7:0];

    assign vga_red = VGA_R_10[9:2];
    assign vga_grn = VGA_G_10[9:2];
    assign vga_blu = VGA_B_10[9:2];

    assign vga_clk = clk;

    vga_adapter #( .RESOLUTION("160x120"), .MONOCHROME("TRUE"), .BITS_PER_COLOUR_CHANNEL(8) )
	vga(.resetn(reset_n), .clock(clk), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(write),//inputs
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), //outputs
                                            .VGA_HS(vga_hsync), .VGA_VS(vga_vsync),
                                            .VGA_CLK(vga_clk));

    // NOTE: We will ignore the VGA_SYNC and VGA_BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the upper 8 bits of the VGA module outputs.

endmodule: vga_avalon
