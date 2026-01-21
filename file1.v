

module test #(parameter depth=316,width=30)
  (input clk,rst,w_en,r_en,[width-1:0]datain ,output reg [width-1:0]dataout, full,empty);
  
 // input clk,rst,w_en,r_en,[width-1:0]datain;
 // output [width-1:0]dataout,full,empty;
  
  reg[2:0]w_ptr,r_ptr;
  
  reg[width-1:0]fifo[depth-1:0];
  
  always@(posedge clk)begin
    if(rst)
      begin
      w_ptr<=0;
      r_ptr<=0;
      dataout<=0;
      end
  end
  
  always@(posedge clk)begin
    if(w_en && !full)
      begin
        fifo[w_ptr]<=datain;
        w_ptr<=w_ptr+1;
      end
  end
  
    
  always@(posedge clk)begin
    if(r_en && !empty)
      begin
        dataout<=fifo[r_ptr];
        r_ptr<=r_ptr+1;
      end
  end
  
  
  assign full  = ((w_ptr - r_ptr)==1);
  assign empty = (w_ptr==r_ptr);
  
endmodule







// Testbench for FIFO

module tb;
  parameter depth = 16;
  parameter width = 16;

  reg clk, rst, w_en, r_en;
  reg [width-1:0] datain;


  wire [width-1:0] dataout;
  wire full, empty;

  // Instantiate the DUT
  test #(depth, width) dut (
    .clk(clk),
    .rst(rst),
    .w_en(w_en),
    .r_en(r_en),
    .datain(datain),
    .dataout(dataout),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    
     $dumpfile("dump.vcd");
    $dumpvars(1);

    clk = 0;
    rst = 1;
    w_en = 0;
    r_en = 0;
    datain = 0;

    // Apply reset
    #10 rst = 0;

    // Write data into FIFO
    repeat (5) begin
      @(negedge clk);
      w_en = 1;
      datain = $random % 256;
    end
    @(negedge clk);
    w_en = 0;

    // Read data from FIFO
    repeat (5) begin
      @(negedge clk);
      r_en = 1;
    end
    @(negedge clk);
    r_en = 0;

    // Finish simulation
    #20 $finish;
  end

  // Monitor output
  initial begin
    $monitor("Time=%0t | w_en=%b r_en=%b | datain=%0d dataout=%0d | full=%b empty=%b | w_ptr_r_ptr_diff=%0d",
             $time, w_en, r_en, datain, dataout, full, empty, dut.w_ptr - dut.r_ptr);
  end

endmodule
