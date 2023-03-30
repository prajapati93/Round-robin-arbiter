//Round-robin arbiter
module rr_arbiter (clk,rstn,request_sig,grant);

//Port declaration
input clk,rstn;
input [3:0]request_sig;
output [3:0]grant;

//Internals
reg  [1:0] rotate_ptr;
reg  [3:0] shift_request;
reg  [3:0] shift_grant;
reg  [3:0] grant_comb;
reg  [3:0] grant;

//Shift request to current priority
always @(*) 
begin
    case (rotate_ptr[1:0])
     2'b00: shift_request[3:0] = request_sig[3:0];
	 2'b01: shift_request[3:0] = {request_sig[0],request_sig[3:1]};
	 2'b10: shift_request[3:0] = {request_sig[1:0],request_sig[3:2]};
	 2'b11: shift_request[3:0] = {request_sig[2:0],request_sig[3]};
	endcase
end

//Priority arbiter
always @(*)
begin
   shift_grant[3:0] = 4'b0;
	if (shift_request[0])
	   shift_grant[0] = 1'b1;
	else if (shift_request[1])
	   shift_grant[1] = 1'b1;
    else if (shift_request[2])
	   shift_grant[2] = 1'b1;
	else if (shift_request[3])
	   shift_grant[3] = 1'b1;
end

//Grant signal
always @(*)
begin
  case (rotate_ptr[1:0])
     2'b00: grant_comb[3:0] = shift_grant[3:0];
	 2'b01: grant_comb[3:0] = {shift_grant[2:0],shift_grant[3]};
	 2'b10: grant_comb[3:0] = {shift_grant[1:0],shift_grant[3:2]};
	 2'b11: grant_comb[3:0] = {shift_grant[0],shift_grant[3:1]};
	endcase
end
//logic Implementation
always@ (posedge clk or negedge rstn)
begin
 if(!rstn)
   grant[3:0] <= 4'b0;
 else
   grant[3:0] = grant_comb[3:0] & ~grant[3:0];
end

//Updating rotate_ptr
always @ (posedge clk or negedge rstn)   
begin
 if(!rstn)
   rotate_ptr[1:0] <= 0;
 else
   case (1'b1)
     grant[0]: rotate_ptr[1:0] <= 2'b01;
	 grant[1]: rotate_ptr[1:0] <= 2'b10;
	 grant[2]: rotate_ptr[1:0] <= 2'b11;
	 grant[3]: rotate_ptr[1:0] <= 2'b00;
   endcase
end
endmodule
