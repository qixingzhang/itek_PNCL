`timescale 1 ns / 1 ps

	module CameraLinkRX_v2_0_M00_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
        input [27:0] CL_DATA,
//        output reg [31:0] 
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY,
		output wire M_AXIS_TUSER
	);                                                                                                             

	reg axis_tvalid, axis_tvalid_delay;
	reg axis_tlast;
    
    wire cl_valid;
    wire [7:0] portA, portB, portC;
    wire [31:0] tx_data;
    reg [C_M_AXIS_TDATA_WIDTH-1:0] axis_tdata, axis_tdata_delay;
    reg axis_tuser, axis_tuser_delay;

	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid_delay;
	assign M_AXIS_TDATA	= axis_tdata_delay;
	assign M_AXIS_TLAST	= axis_tlast;
	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
	assign M_AXIS_TUSER = axis_tuser_delay;

    assign portA = {CL_DATA[5], CL_DATA[27], CL_DATA[6], CL_DATA[4], CL_DATA[3], CL_DATA[2], CL_DATA[1], CL_DATA[0]};
    assign portB = {CL_DATA[11], CL_DATA[10], CL_DATA[14], CL_DATA[13], CL_DATA[12], CL_DATA[9], CL_DATA[8], CL_DATA[7]};
    assign portC = {CL_DATA[17], CL_DATA[16], CL_DATA[22], CL_DATA[21], CL_DATA[20], CL_DATA[19], CL_DATA[18], CL_DATA[15]};
    assign tx_data	= {8'h00, portC, portB, portA};
    assign cl_valid = CL_DATA[24] & CL_DATA[25] & CL_DATA[26];
    
    reg cl_valid_delay;
    always@(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN) begin
            axis_tdata <= 32'hffffffff;
            axis_tvalid <= 0;
        end
        else begin
            if (cl_valid & M_AXIS_TREADY) begin
                axis_tdata <= tx_data;
                axis_tvalid <= 1;
            end
            else begin
                axis_tdata <= 32'hffffffff;
                axis_tvalid <= 0;
            end
        end
    end
    
    always@(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN) begin
            cl_valid_delay <= 0;
            axis_tlast <= 0;
            axis_tuser <= 0;
        end
        else begin
            cl_valid_delay <= cl_valid;
            if (cl_valid_delay & (~cl_valid)) begin
                axis_tlast <= 1;
            end
            else begin
                axis_tlast <= 0;
            end
            if (cl_valid & (~cl_valid_delay)) begin
                axis_tuser <= 1;
            end
            else begin
                axis_tuser <= 0;
            end
        end
    end
    
    always@(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN) begin
            axis_tdata_delay <= 0;
            axis_tvalid_delay <= 0;
            axis_tuser_delay <= axis_tuser;
        end
        else begin
            axis_tdata_delay <= axis_tdata;
            axis_tvalid_delay <= axis_tvalid;
            axis_tuser_delay <= axis_tuser;
        end
    end
    
	endmodule
