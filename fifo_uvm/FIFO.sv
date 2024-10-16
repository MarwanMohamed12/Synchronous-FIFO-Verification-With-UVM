////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////



module FIFO(fifo_if if_t);

reg [if_t.FIFO_WIDTH-1:0] mem [if_t.FIFO_DEPTH-1:0];

reg [if_t.max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [if_t.max_fifo_addr:0] count;

always @(posedge if_t.clk or negedge if_t.rst_n) begin
	if (!if_t.rst_n) begin
		wr_ptr <= 0;
		if_t.overflow <= 0; // we need to assign zero to this var because if it was high in cycle so in next cycle if rst it should be low but it still high
		if_t.wr_ack   <= 0; // we need to assign zero to this var because if it was high in cycle so in next cycle if rst it should be low but it still high
	end
	else if (if_t.wr_en  && count < if_t.FIFO_DEPTH) begin
		mem[wr_ptr] <= if_t.data_in;
		if_t.wr_ack <= 1;
		if_t.overflow <= 0;
		wr_ptr <= wr_ptr + 1;
	end
	else begin
		if_t.wr_ack <= 0;
		if(if_t.full && if_t.wr_en ) begin 
		//  we should handle if there is read also
			if_t.overflow <= 1;
		end
		else begin
			if_t.overflow <= 0;
		end
	end
end

always @(posedge if_t.clk or negedge if_t.rst_n) begin
	if (!if_t.rst_n) begin
		rd_ptr <= 0;
		if_t.underflow <= 0; // we need to assign zero to this var because if it was high in cycle so in next cycle if rst it should be low but it still high
	end
	else if (if_t.rd_en && count != 0) begin
		if_t.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		if_t.underflow <= 0;
	end
	else begin
		if(if_t.empty && if_t.rd_en )
			if_t.underflow <= 1;
		else
			if_t.underflow <= 0;
	end
end

always @(posedge if_t.clk or negedge if_t.rst_n) begin
	if (!if_t.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({if_t.wr_en, if_t.rd_en} == 2'b10) && !if_t.full) 
			count <= count + 1;
		else if ( ({if_t.wr_en, if_t.rd_en} == 2'b01) && !if_t.empty)
			count <= count - 1;
		else if ( ({if_t.wr_en, if_t.rd_en} == 2'b11) && if_t.full)//we need to handle counter in write and read when full
			count <= count - 1;
		else if ( ({if_t.wr_en, if_t.rd_en} == 2'b11) && if_t.empty)//we need to handle counter in write and read when empty
			count <= count + 1;
	end
end

assign if_t.full = (count == if_t.FIFO_DEPTH)? 1 : 0;
assign if_t.empty = (count == 0)? 1 : 0;
assign if_t.almostfull = (count == if_t.FIFO_DEPTH-1)? 1 : 0; // here it should be 1 not 2
assign if_t.almostempty = (count == 1)? 1 : 0;

endmodule