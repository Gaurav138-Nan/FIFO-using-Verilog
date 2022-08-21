// Code your design here

//------------TOP MODULE--------------------
`timescale 1ps/ 1ps 
module sync_fifo(input [15:0] data_in,input rst_n,input wr,input rd,input clk,output fifo_full,output fifo_empty,output fifo_overflow,output fifo_underflow,output [15:0] data_out);
    
  
  wire[3:0] wptr,rptr;
  
  wire fifo_we,fifo_rd;
   
  wr_pointer top1(wr,clk,rst_n,fifo_full,wptr,fifo_we);  
  rd_pointer top2(rd,clk,rst_n,fifo_empty,rptr,fifo_rd);  
  fifo_memory top3(clk, rptr, wptr,data_in,data_out,fifo_we);  
  status top4(wr, rd, fifo_we, fifo_rd, clk, rst_n, wptr, rptr, fifo_empty, fifo_full,fifo_underflow,fifo_overflow);

endmodule 


//------------THE FIFO BUFFER-----------------------

module fifo_memory(input clk,input [3:0] rptr,input [3:0] wptr,input [15:0] din,output wire [15:0] dout,input fifo_we);
  reg [15:0] temp[7:0];
 
  
  always @(posedge clk)
    begin
      if(fifo_we)//if write_enable is made active
        temp[wptr[2:0]]<=din;//if fifo_we is enabled,we write data into the memory.
     end

  assign dout=temp[rptr[2:0]];//This operation is for reading the data from the memory

endmodule
   

//-----------------THE READ POINTER MODULE----------------------------

module rd_pointer(input rd,input clk,input rst_n,input empty,output reg [3:0] rptr,output fifo_rd);
 
 assign fifo_rd=(rd & ~empty);


  always @(posedge clk or negedge rst_n)
     begin
       if(~rst_n)
          rptr<={4{1'b0}};
       else if(fifo_rd)
          rptr<=rptr+ 4'b0001;
       else
          rptr<=rptr;
     end 

endmodule 


//-------------------------THE WRITE POINTER MODULE-------------------------
module wr_pointer(input wr,input clk,input rst_n,input full,output reg [3:0] wptr,output fifo_we);
 
 
 assign fifo_we=(wr & ~full);


  always @(posedge clk or negedge rst_n)
     begin
       if(~rst_n)
          wptr<={4{1'b0}};
       else if(fifo_we)
          wptr<=wptr+ 4'b0001;
       else
          wptr<=wptr;
     end 

endmodule 

//----------------STATUS MODULE-----------------------
//This module is specifically made to implement the status signals like 
//empty,full etc.

module status(input wr,input rd,input fifo_we,input fifo_rd,input clk,input rst_n,input [3:0] wptr,input [3:0] rptr,output empty,output full,output reg underflow,output reg overflow);
 
 assign empty=(wptr==rptr);// here we are comparing the extra bit at the MSB to determine
 assign full =({~wptr[3],wptr[2:0]}==rptr[3:0]); //whether the fifo is empty or full.

 wire over,under;

 assign over = wr & full;// setting condition for overflow
 assign under =empty & rd; //and underflow

 always @(posedge clk or negedge rst_n)//This block identifies the various scenarios in which based on the previous condition we can set the 
                                       // overflow bit as high or low. 
    begin
    if(~rst_n)
      overflow<=0;
    else if(over && ~fifo_rd)
      overflow<=1;
    else if(fifo_rd)
      overflow<=0;
    else
       overflow<=overflow;

    end 
always @(posedge clk or negedge rst_n)//This block does the same for underflow.
    begin
    if(~rst_n)
      underflow<=0;
    else if(under && ~fifo_we)
      underflow<=1;
    else if(fifo_we)
      underflow<=0;
    else
       underflow<=underflow;

    end 

endmodule 
