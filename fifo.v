module fifo #(parameter FIFO_WIDTH=8, FIFO_DEPTH=8)(
input	clk,
input	reset,
input	fifoWrEn,
input	[FIFO_WIDTH-1:0] fifoWrData,
output	fifoFull,
input	fifoRdEn,
output  [FIFO_WIDTH-1:0] fifoRdData,
output  fifoEmpty,
output  [$clog2(FIFO_DEPTH):0] fifoDataCount
);

reg wrEnInt;
reg [FIFO_WIDTH-1:0] fifoWrDatap;
reg [$clog2(FIFO_DEPTH):0] dataCounter;
reg [$clog2(FIFO_DEPTH)-1:0] wrPointer;
reg [$clog2(FIFO_DEPTH)-1:0] rdPointer;

assign validFifoWr = fifoWrEn & !fifoFull;
assign validFifoRd = fifoRdEn & !fifoEmpty;
assign fifoDataCount = dataCounter;
assign fifoFull = (dataCounter==FIFO_DEPTH)? 1'b1 : 1'b0;
assign fifoEmpty = (dataCounter==0)? 1'b1 : 1'b0;

//pipeline for aligning with ram wr en
always @(posedge clk)
    fifoWrDatap <= fifoWrData;

//Fifo write logic
always @(posedge clk)
begin
    if(reset)
       wrEnInt <= 1'b0;
    else if(validFifoWr)
       wrEnInt <= 1'b1;
    else
       wrEnInt <= 1'b0;
end

always @(posedge clk)
begin
    if(reset)
        dataCounter <= 0;
    else if(validFifoWr & !validFifoRd)
        dataCounter <= dataCounter+1'b1;
    else if(validFifoRd & !validFifoWr)
        dataCounter <= dataCounter-1'b1;
end

always @(posedge clk)
begin
    if(reset)
        wrPointer <= 0;
    else if(wrEnInt)
	wrPointer <= wrPointer+1'b1;
end


always @(posedge clk)
begin
    if(reset)
        rdPointer <= 0;
    else if(validFifoRd)
	rdPointer <= rdPointer+1'b1;
end
 


ram #(.Width(FIFO_WIDTH),.Depth(FIFO_DEPTH))rm(
.clk(clk),
.wrEn(wrEnInt), //Should become high when you want to write to the memory
.wrAddr(wrPointer), //address for writing
.wrData(fifoWrDatap), //Data to be written
.rdAddr(rdPointer),
.rdData(fifoRdData)
);


endmodule