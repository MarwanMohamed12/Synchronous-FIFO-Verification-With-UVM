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
		wr_ptr <= wr_ptr + 1;
	end
	else begin
		if_t.wr_ack <= 0;
		if(if_t.full && if_t.wr_en && ! if_t.rd_en ) begin 
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
	end
	else begin
		if(if_t.empty && !if_t.wr_en && if_t.rd_en )
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


`ifdef SIM 
	always_comb begin 
		if(!if_t.rst_n) begin
			rst_check:assert final(wr_ptr==0 && rd_ptr==0 && count==0 && if_t.empty &&  !if_t.full && !if_t.almostfull && !if_t.almostempty );
		end
		if(count==if_t.FIFO_DEPTH )begin
			full_check:assert final(if_t.full);
		end

		if(count==if_t.FIFO_DEPTH -1)begin
			almost_full_check:assert final(if_t.almostfull);
		end
		if(count==0)begin
			empty_check:assert final(if_t.empty);
		end

		if(count==1)begin
			almost_empty_check:assert final(if_t.almostempty);
		end
	end


property overflow_check;
@(posedge if_t.clk)  disable iff(!if_t.rst_n) (count == if_t.FIFO_DEPTH && if_t.wr_en && ! if_t.rd_en) |=> (if_t.overflow) ;
endproperty

property underflow_check;
@(posedge if_t.clk)  disable iff(!if_t.rst_n) (count == 0 && ! if_t.wr_en && if_t.rd_en) |=> (if_t.underflow);
endproperty

property WrAck_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.wr_en && count != if_t.FIFO_DEPTH) |=> (if_t.wr_ack);
endproperty

property internal_WR_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.wr_en && !if_t.rd_en && count < if_t.FIFO_DEPTH) |=> ( ( count == $past(count) + 1'b1) && ( wr_ptr==$past(wr_ptr) + 1'b1) );
endproperty

property internal_RE_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.rd_en && !if_t.wr_en && count > 0) |=> ( ( count == $past(count) - 1'b1) && ( rd_ptr==$past(rd_ptr) + 1'b1) );
endproperty

property internal_WR_RE_full;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && if_t.full)  |=>  ( count == $past(count) -1'b1 && (rd_ptr==$past(rd_ptr) + 1'b1) );
endproperty

property internal_WR_RE_empty;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && if_t.empty)  |=>  ( count == $past(count) + 1'b1 && (wr_ptr==$past(wr_ptr) + 1'b1) );
endproperty

property internal_WR_RE;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && !if_t.full && !if_t.empty )  |=>  ( count == $past(count) && (rd_ptr==$past(rd_ptr) + 1'b1) && ( wr_ptr==$past(wr_ptr) + 1'b1) );
endproperty

OF_check:assert property(overflow_check);
UF_check:assert property(underflow_check);
ACK_check:assert property(WrAck_check);
intWr_check:assert property(internal_WR_check);
intRD_check:assert property(internal_RE_check);
intWR_RD_WR:assert property(internal_WR_RE);
intWR_RD_WR_full:assert property(internal_WR_RE_full);
intWR_RD_WR_empty:assert property(internal_WR_RE_empty);

OF_cover:cover property(overflow_check);
UF_cover:cover property(underflow_check);
ACK_cover:cover property(WrAck_check);
intWr_cover:cover property(internal_WR_check);
intRD_cover:cover property(internal_RE_check);
intRD_WR_cover:cover property(internal_WR_RE);
intWR_RD_WR_empty_cover:cover property(internal_WR_RE_empty);
intWR_RD_WR_full_cover:cover property(internal_WR_RE_full);

`endif
endmodule