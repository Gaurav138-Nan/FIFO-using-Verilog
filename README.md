# FIFO-using-Verilog

Here we are implementing synchronous as well as asynchronous FIFO using Verilog.

**ASYNCHRONOUS FIFO:**
An asynchronous FIFO refers to a FIFO design in which the FIFO buffer is accessed while reading and writing 
using two different clock domains.That is unlike synchronous FIFO ,the speed of writing and reading are 
asynchronous to one another.


**Design:**
The design that we are going to do in verilog is based on the below diagram.
Our FIFO has a depth of 8 and has a word size of 16 bits.

The below design consists of a reader module,writer module and a fifo buffer.
These are the main components of any fifo.

But here as we are operating with two
clock domains, inorder to generate empty and full conditions of the buffer we need
the reader pointer and the writer pointer in both clock domains.

Thus the final main component of an asynchronous fifo is a 2 FF synchronizer used for 
CDC (clock domain crossing).








![image](https://user-images.githubusercontent.com/75901646/185785233-116cb225-d53b-4390-ae91-9874c086dacd.png)







**Simulation WaveForm:
**

![image](https://user-images.githubusercontent.com/75901646/185785278-a03772c8-80a5-4a98-bb2a-fdf56a52efec.png)







**Observations**:
The above waveform was plotted in EDA PLAYGROUND.

The above waveform shows that as long as the write enable signal was high,write pointer was incremented and data was 
inserted into the fifo buffer.On insertion of the final level's data we were given a high signal in the output of the FULL
status signal implying that the buffer was full.

As long as the fifo is not empty ,applying read_enable signal allowed the output of data from the buffer and when it reached the 
final level ,the empty status signal became high signifying that the buffer has become empty.


