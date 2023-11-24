`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/16 20:38:33
// Design Name: 
// Module Name: camera_control
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


module camera_control(
    input PL_UART_TX,
    input CL_SerTFG,
    output PL_UART_RX,
    output CL_SerTC
    );
    
assign CL_SerTC = PL_UART_TX;
assign PL_UART_RX = CL_SerTFG;

endmodule
