module ram #(parameter Width=16,Depth=1024)(
input	clk,
input   wrEn, //Should become high when you want to write to the memory
input [$clog2(Depth)-1:0]   wrAddr, //address for writing
input [Width-1:0]   wrData, //Data to be written
input [$clog2(Depth)-1:0]   rdAddr,
output reg [Width-1:0]  rdData
);


reg [Width-1:0]mem[Depth-1:0];

//Writing to memory logic

always @(posedge clk)
begin
     if(wrEn)
          mem[wrAddr] <= wrData;
end

//Read logic
always @(posedge clk)
    rdData <= mem[rdAddr];



endmodule