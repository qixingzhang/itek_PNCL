`timescale 1 ns / 1 ps

	module CameraLinkRX_v2_0_M00_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 64,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
        input [27:0] CL_BASE,
        input [27:0] CL_MEDIUM,
        input [27:0] CL_FULL,
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
    
    wire base_valid, medium_valid, full_valid, cl_valid;
    wire [7:0] portA, portB, portC, portD, portE, portF, portG, portH;
    wire [C_M_AXIS_TDATA_WIDTH-1:0] tx_data;
    reg [C_M_AXIS_TDATA_WIDTH-1:0] axis_tdata, axis_tdata_delay;
    reg axis_tuser, axis_tuser_delay;

	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid_delay;
	assign M_AXIS_TDATA	= axis_tdata_delay;
	assign M_AXIS_TLAST	= axis_tlast;
	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
	assign M_AXIS_TUSER = axis_tuser_delay;

    assign portA = {CL_BASE[5], CL_BASE[27], CL_BASE[6], CL_BASE[4], CL_BASE[3], CL_BASE[2], CL_BASE[1], CL_BASE[0]};
    assign portB = {CL_BASE[11], CL_BASE[10], CL_BASE[14], CL_BASE[13], CL_BASE[12], CL_BASE[9], CL_BASE[8], CL_BASE[7]};
    assign portC = {CL_BASE[17], CL_BASE[16], CL_BASE[22], CL_BASE[21], CL_BASE[20], CL_BASE[19], CL_BASE[18], CL_BASE[15]};
    assign portD = {CL_MEDIUM[5], CL_MEDIUM[27], CL_MEDIUM[6], CL_MEDIUM[4], CL_MEDIUM[3], CL_MEDIUM[2], CL_MEDIUM[1], CL_MEDIUM[0]};
    assign portE = {CL_MEDIUM[11], CL_MEDIUM[10], CL_MEDIUM[14], CL_MEDIUM[13], CL_MEDIUM[12], CL_MEDIUM[9], CL_MEDIUM[8], CL_MEDIUM[7]};
    assign portF = {CL_MEDIUM[17], CL_MEDIUM[16], CL_MEDIUM[22], CL_MEDIUM[21], CL_MEDIUM[20], CL_MEDIUM[19], CL_MEDIUM[18], CL_MEDIUM[15]};
    assign portG = {CL_FULL[5], CL_FULL[27], CL_FULL[6], CL_FULL[4], CL_FULL[3], CL_FULL[2], CL_FULL[1], CL_FULL[0]};
    assign portH = {CL_FULL[11], CL_FULL[10], CL_FULL[14], CL_FULL[13], CL_FULL[12], CL_FULL[9], CL_FULL[8], CL_FULL[7]};
    
    assign base_valid = CL_BASE[24] & CL_BASE[25] & CL_BASE[26];
    assign medium_valid = CL_MEDIUM[24] & CL_MEDIUM[25] & CL_MEDIUM[26];
    assign full_valid = CL_FULL[24] & CL_FULL[25] & CL_FULL[26];
    assign cl_valid = base_valid;
    
    assign tx_data	= {portH, portG, portF, portE, portD, portC, portB, portA};
            
    reg cl_valid_delay;
    always@(posedge M_AXIS_ACLK) begin
        if (!M_AXIS_ARESETN) begin
            axis_tdata <= 0;
            axis_tvalid <= 0;
        end
        else begin
            if (cl_valid & M_AXIS_TREADY) begin
                axis_tdata <= tx_data;
                axis_tvalid <= 1;
            end
            else begin
                axis_tdata <= 0;
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
