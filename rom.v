module rom #(parameter Width=16,Depth=1024)(
input	clk,
input [$clog2(Depth)-1:0]   rdAddr,
output reg [Width-1:0]  rdData
);


reg [Width-1:0]mem[Depth-1:0];

initial
begin
     $readmemb("initData.mif",mem);
end

//Read logic
always @(posedge clk)
    rdData <= mem[rdAddr];



endmodule