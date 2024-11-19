`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 20:23:16
// Design Name: 
// Module Name: majority
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module majority(input [127:0] a, b, c, output [127:0] out);
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin
            assign out[i] = (a[i] & b[i]) | (b[i] & c[i]) | (c[i] & a[i]);
        end
    endgenerate
endmodule
