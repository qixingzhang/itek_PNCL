`timescale 1ns / 1ps


module CL_AXIS_tb();
parameter integer C_M_AXIS_TDATA_WIDTH	= 32;
parameter integer C_M_START_COUNT	= 32;

reg [27:0] CL_DATA;
reg M_AXIS_ACLK;
reg M_AXIS_ARESETN;
reg M_AXIS_TREADY;
wire M_AXIS_TVALID;
wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA;
wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB;
wire M_AXIS_TLAST;
wire M_AXIS_TUSER;



CameraLinkRX_v2_0_M00_AXIS CameraLinkRX_v2_0_M00_AXIS(
    .CL_DATA(CL_DATA),
    .M_AXIS_ACLK(M_AXIS_ACLK),
    .M_AXIS_ARESETN(M_AXIS_ARESETN),
    .M_AXIS_TREADY(M_AXIS_TREADY),
    .M_AXIS_TVALID(M_AXIS_TVALID),
    .M_AXIS_TDATA(M_AXIS_TDATA),
    .M_AXIS_TSTRB(M_AXIS_TSTRB),
    .M_AXIS_TLAST(M_AXIS_TLAST),
    .M_AXIS_TUSER(M_AXIS_TUSER)
);

always #5 M_AXIS_ACLK <= ~M_AXIS_ACLK;

initial begin
    M_AXIS_ACLK <= 0;
    M_AXIS_ARESETN <= 0;
    M_AXIS_TREADY <= 0;
    CL_DATA <= 28'h0;
    #20;
    M_AXIS_ARESETN <= 1;
    M_AXIS_TREADY <= 1;
    CL_DATA <= {4'b0111, 24'h0};
    #10;
    CL_DATA <= {4'b0111, 24'h1};
    #10;
    CL_DATA <= {4'b0111, 24'h2};
    #10;
    CL_DATA <= {4'b0111, 24'h3};
    #10;
    CL_DATA <= {4'b0111, 24'h4};
    #10;
    CL_DATA <= {4'b0111, 24'h5};
    #10;
    CL_DATA <= {4'b0111, 24'h6};
    #10;
    CL_DATA <= {4'b0111, 24'h7};
    #10;
    CL_DATA <= {4'b0111, 24'h8};
    #10;
    CL_DATA <= {4'b0111, 24'h9};
    #10;
    CL_DATA <= {4'b0110, 24'h10};
    #100;

end

endmodule
