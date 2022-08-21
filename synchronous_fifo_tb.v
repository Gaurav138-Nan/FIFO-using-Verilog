`timescale 1ps/ 1ps   

 module tb;  
  
 parameter ENDTIME=2000;  
 
 reg clk;  
 reg rst_n;  
 reg wr;  
 reg rd;  
 reg [15:0] data_in;  
 
 wire [15:0] data_out;  
 wire fifo_empty;  
 wire fifo_full;  
 wire fifo_threshold;  
 wire fifo_overflow;  
 wire fifo_underflow;  
 integer i;  
 
 sync_fifo tb(data_in,rst_n,wr,rd,clk,fifo_full,fifo_empty,fifo_overflow,fifo_underflow,data_out);
   
 
  
 initial  
      begin  
           clk = 1'b0;  
           rst_n = 1'b0;  
           wr = 1'b0;  
           rd = 1'b0;  
           data_in = 16'd0;  
      end  
 
 initial  
      begin  
           main;  
      end  
initial 
  begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
end  

 task main;
      fork  
           clock_generator;  
           reset_generator;  
           operation_process;  
           monitor_fifo;  
           finish;  
      join  
 endtask  


 task clock_generator;  
      begin  
           forever #10 clk = ~clk;  
      end  
 endtask  


 task reset_generator;  
      begin  
        #20  
           rst_n = 1'b1;  
        #7.9  
           rst_n = 1'b0;  
        #7.9  
           rst_n = 1'b1;  
      end  
 endtask 

 
 task operation_process;  
      begin  
        for (i = 0; i <9; i = i + 1) begin: WRE  
                #50
                wr = 1'b1;  
                data_in = data_in + 16'd1;  
                #20  
                wr = 1'b0;  
           end  
           #10  
        for (i = 0; i <9; i = i + 1) begin: RDE  
                #20  
                rd = 1'b1;  
                #20 
                rd = 1'b0;  
           end  
      end  
 endtask  
  
 task monitor_fifo;  
      begin  
           
           $monitor("TIME = %d, wr = %b, rd = %b, data_in = %h",$time, wr, rd, data_in);  
      end  
 endtask  
 
 task finish;  
      begin  
           #ENDTIME  
           $display("-------------- THE SIMUALTION FINISHED ------------");  
           $finish;  
      end  
 endtask  
 endmodule 