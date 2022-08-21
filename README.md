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

Another important component of the above design is the usage of binarytogray and graytobinary
converter specifically because gray codes are less prone to metastability changes inside 
the synchronizer.








**THE FIGURE:

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























**SYNCHRONOUS FIFO:**
A Synchronous FIFO is a First-In-First-Out queue in which there is a single clock pulse for both data write and data read. In Synchronous FIFO the read and write operations are performed at the same rate. The number of rows is called depth or number of words of FIFO and number of bits in each row is called as width or word length of FIFO. This kind of FIFO is termed as Synchronous because the rate of read and write operations are same.




**DESIGN**:
Here we have designed a 16 bit synchronous FIFO with a FIFO having a depth of 8.
We have first designed the FIFO using Verilog in EDA PLAYGROUND and then tested the design using a testbench created in the same environment.
The final waves associated with the testbench has been plotted to observe the working of the designed system.



**FIFO STRUCTURE:**
![image](https://user-images.githubusercontent.com/75901646/185786080-d90f24cc-1662-4af0-ad77-a08f3d8167b7.png)



**SIMULATION WAVEFORM:**
![image](https://user-images.githubusercontent.com/75901646/185786709-ad7bd49c-1e47-44d3-af20-303455e7e5b8.png)





**OBSERVATIONS**:
The above the waveforms function very similarly to their asynchronous counterparts with the only variation of the usage of a single
clock.The only addition in our waveform is the implementation of underflow and overflow logic.





