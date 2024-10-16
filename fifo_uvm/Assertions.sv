module Assertions (fifo_if if_t);
    	always_comb begin 
		if(!if_t.rst_n) begin
			rst_check:assert final(dut.wr_ptr==0 && dut.rd_ptr==0 && dut.count==0 && if_t.empty &&  !if_t.full && !if_t.almostfull && !if_t.almostempty );
		end
		if(dut.count==if_t.FIFO_DEPTH )begin
			full_check:assert final(if_t.full);
		end

		if(dut.count==if_t.FIFO_DEPTH -1)begin
			almost_full_check:assert final(if_t.almostfull);
		end
		if(dut.count==0)begin
			empty_check:assert final(if_t.empty);
		end

		if(dut.count==1)begin
			almost_empty_check:assert final(if_t.almostempty);
		end
	end


property overflow_check;
@(posedge if_t.clk)  disable iff(!if_t.rst_n) (dut.count == if_t.FIFO_DEPTH && if_t.wr_en ) |=> (if_t.overflow) ;
endproperty

property underflow_check;
@(posedge if_t.clk)  disable iff(!if_t.rst_n) (dut.count == 0  && if_t.rd_en) |=> (if_t.underflow);
endproperty

property WrAck_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.wr_en && dut.count != if_t.FIFO_DEPTH) |=> (if_t.wr_ack);
endproperty

property internal_WR_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.wr_en && !if_t.rd_en && dut.count < if_t.FIFO_DEPTH) |=> ( ( dut.count == $past(dut.count) + 1'b1) && ( dut.wr_ptr==$past(dut.wr_ptr) + 1'b1) );
endproperty

property internal_RE_check;
@(posedge if_t.clk) disable iff(!if_t.rst_n) (if_t.rd_en && !if_t.wr_en && dut.count > 0) |=> ( ( dut.count == $past(dut.count) - 1'b1) && ( dut.rd_ptr==$past(dut.rd_ptr) + 1'b1) );
endproperty

property internal_WR_RE_full;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && if_t.full)  |=>  ( dut.count == $past(dut.count) -1'b1 && (dut.rd_ptr==$past(dut.rd_ptr) + 1'b1) );
endproperty

property internal_WR_RE_empty;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && if_t.empty)  |=>  ( dut.count == $past(dut.count) + 1'b1 && (dut.wr_ptr==$past(dut.wr_ptr) + 1'b1) );
endproperty

property internal_WR_RE;
@(posedge if_t.clk) disable iff(!if_t.rst_n) ( if_t.rd_en && if_t.wr_en && !if_t.full && !if_t.empty )  |=>  ( dut.count == $past(dut.count) && (dut.rd_ptr==$past(dut.rd_ptr) + 1'b1) && ( dut.wr_ptr==$past(dut.wr_ptr) + 1'b1) );
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

endmodule