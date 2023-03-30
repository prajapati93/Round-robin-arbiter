
module rr_arbiter_tb();

//variable declaration

reg clk, rstn;
reg request_sig0,request_sig1,request_sig2,request_sig3;

//Instantiation
rr_arbiter DUT 
        (.clk(clk),.rstn(rstn),
		 .request_sig({request_sig3,request_sig2,request_sig1,request_sig0}),
		 .grant({grant3,grant2,grant1,grant0})
		);

//Clock generator
always #5 clk = ~clk;

//Stimulus
initial begin
  clk = 0;
  request_sig3 = 0;
  request_sig2 = 0;
  request_sig1 = 0;
  request_sig0 = 0;
  rstn = 1'b1;
  #10 rstn = 1'b0;
  #10 rstn = 1'b1;
  repeat (1) @ (posedge clk);
  request_sig0 <= 1;
  repeat (1) @ (posedge clk);
  request_sig0 <= 0;
  repeat (1) @ (posedge clk);
  request_sig0 <= 1;
  request_sig1 <= 1;
  repeat (1) @ (posedge clk);
  request_sig2 <= 1;
  request_sig1 <= 0;
  repeat (1) @ (posedge clk);
  request_sig3 <= 1;
  request_sig2 <= 0;
  repeat (1) @ (posedge clk);
  request_sig3 <= 0;
  repeat (1) @ (posedge clk);
  request_sig0 <= 1;
  repeat (1) @ (posedge clk);
  #10 $finish;
  
end
endmodule