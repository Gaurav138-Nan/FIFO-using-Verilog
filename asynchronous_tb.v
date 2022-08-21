`timescale 1ps/1ps

module async_fifo_tb ();


parameter WCLK_PERIOD = 10;
parameter RCLK_PERIOD = 40;

reg wreq, wclk, wrst_n, rreq, rclk, rrst_n;
  reg [15:0] wdata;
  wire [15:0] rdata;
wire wfull, rempty;

// Instance
async_fifo tb_model
(
    .wr (wreq), .wrst_n(wrst_n), .wclk(wclk),
    .rd(rreq), .rclk(rclk), .rrst_n(rrst_n),
    .wdata(wdata), .rdata(rdata), .wfull(wfull), .rempty(rempty)
);

initial begin
    wrst_n = 0;
    wclk = 0;
    wreq = 0;
    wdata = 0;
    repeat (2) #(WCLK_PERIOD/2) wclk = ~wclk;
    wrst_n = 1;
    forever #(WCLK_PERIOD/2) wclk = ~wclk;
end

initial begin
    rrst_n = 0;
    rclk = 0;
    rreq = 0;
    repeat (2) #(RCLK_PERIOD/2) rclk = ~rclk;
    rrst_n = 1;
    forever  #(RCLK_PERIOD/2) rclk = ~rclk;
end

initial 
  begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
end  


initial begin
    repeat (4) @ (posedge wclk);
  @(negedge wclk); wreq = 1;wdata = 16'd1;
  @(negedge wclk); wreq = 1;wdata = 16'd2;
  @(negedge wclk); wreq = 1;wdata = 16'd3;
  @(negedge wclk); wreq = 1;wdata = 16'd4;
  @(negedge wclk); wreq = 1;wdata = 16'd5;
  @(negedge wclk); wreq = 1;wdata = 16'd6;
  @(negedge wclk); wreq = 1;wdata = 16'd7;
  @(negedge wclk); wreq = 1;wdata = 16'd8;
    
     @(negedge wclk); wreq = 0;

     @(negedge rclk); rreq = 1;
     repeat (17) @(posedge rclk);
     rreq=0;

     #100;
     $finish;
end

endmodule