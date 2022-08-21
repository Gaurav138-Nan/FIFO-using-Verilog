`timescale 1ps/1ps

module async_fifo (
    input   wr, wclk, wrst_n,
    input   rd, rclk, rrst_n,
  input   [15:0] wdata,
  output  [15:0] rdata,
    output  reg wfull,
    output  reg rempty
);

  reg     [3:0]   wq2_rptr, wq1_rptr, rptr;
  reg     [3:0]   rq2_wptr, rq1_wptr, wptr;
wire    rempty_val;
  wire    [3 : 0] rptr_nxt;
  wire    [2:0] raddr;
  reg     [3:0] rbin;
  wire    [3:0] rbin_nxt;
  wire    [2:0] waddr;
  reg     [3:0] wbin;
  wire    [3:0] wbin_nxt;
  wire    [3 : 0] wptr_nxt;

// synchronizing rptr to wclk
//This module is specifically used for clock domain crossing of rptr into the writing clock domain.
always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
        {wq2_rptr, wq1_rptr} <= 2'b0;
    else
        {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
end

// synchronizing wptr to rclk
//This module is specifically used for clock domain crossing of wptr into the reading clock domain.
always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
        {rq2_wptr, rq1_wptr} <= 2'b0;
    else
        {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
end

  
//-----------Reader Module------------  
// generating rempty condition
//reg     rempty;
assign  rempty_val = (rptr_nxt == rq2_wptr); 

always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
        rempty <= 1'b0;
    else
        rempty <= rempty_val;
end

// generating read address for fifomem
  assign rbin_nxt = rbin + (rd & ~rempty);

always @ (posedge rclk or negedge rrst_n) 
    if (!rrst_n)
        rbin <= 0;
    else 
        rbin <= rbin_nxt;
  assign raddr = rbin[2:0]; 

// generating rptr to send to wclk domain
// convert from binary to gray
assign rptr_nxt = rbin_nxt ^ (rbin_nxt>>1);

always @ (posedge rclk or negedge rrst_n)
    if (!rrst_n)
        rptr <= 0;
    else 
        rptr <= rptr_nxt;
  
  
//----------------Writer Module--------------
// generating write address for fifomem
assign wbin_nxt = wbin + (wr & !wfull);

always @ (posedge wclk or negedge wrst_n)
    if(!wrst_n)
        wbin <= 0;
    else
        wbin <= wbin_nxt;

  assign waddr = wbin [2:0];

// generating wptr to send to rclk domain
// convert from binary to gray
assign wptr_nxt = (wbin_nxt>>1) ^ wbin_nxt; 

always @ (posedge wclk or negedge wrst_n)
    if(!wrst_n)
        wptr <= 0;
    else
        wptr <= wptr_nxt;

// generate wfull condition
wire wfull_val;
  assign wfull_val = (wq2_rptr == {~wptr[3 : 2],wptr[1 : 0]});

always @ (posedge wclk or negedge wrst_n)
    if (!wrst_n)
        wfull <= 0;
    else 
        wfull <= wfull_val;

  
//---------------------THE FIFO RAM----------------------  
// fifomem
// Using Verilog memory model
 
  reg [15 : 0] mem [0:7];

assign rdata = mem[raddr];

always @ (posedge wclk)
    if (wr & !wfull) mem[waddr] <= wdata;

endmodule