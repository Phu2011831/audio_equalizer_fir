`timescale 1ns/1ps

module FIR #(
    parameter   WIDTH_data =  24,
                WIDTH_coeff = 32,
                WIDTH_reg =   WIDTH_data + WIDTH_coeff,
                TAP =         64
) 
    (
    input logic                           clk,
    input logic                           reset_n,
    input logic signed [WIDTH_data-1:0]   data_in,
    output logic signed [WIDTH_data-1:0]  data_out,
	 input logic signed [WIDTH_coeff-1:0]  h         [TAP-1:0]

); 

// Araays --- 31 taps

logic signed [WIDTH_data-1:0]   reg_in    [TAP-1:0]; // array for data_in delay 
logic signed [WIDTH_reg-1:0]    mul       [TAP-1:0]; // array for result multiply 
logic signed [WIDTH_reg-1:0]    add_out   [0:TAP-1]; // array for result addition



assign reg_in[0] = data_in; // no delay value

// Data in through delay 

genvar i; 
 generate

     for (i = 0; i < TAP - 1; i = i + 1) begin: delayfirst 
        my_DFF ff (
            .clk(clk),
            .rst_n(reset_n),
            .d_in(reg_in[i]),
            .q_out(reg_in[i+1])
        );
     end
 endgenerate

 // multi result 

 genvar k; 
 generate
     for (k = 0; k < TAP; k = k +1) begin: multi_coeff
        multi mult (
            .a(reg_in[k]),
            .b(h[k]),
            .out(mul[k])
        );
	end
 endgenerate

 // add result 

 genvar j; 
  generate
    for (j = 0; j < TAP; j = j + 1) begin: add_result 
        if (j<TAP-1) begin 
        assign add_out[j] = mul[j] + add_out[j+1];
		end
        else begin 
            assign add_out[j] = mul[j];
        end
    end
  endgenerate

  // output result
  assign data_out = add_out[0][WIDTH_reg-1:WIDTH_reg-24]; 
  
endmodule : FIR

module multi #(
    parameter    a_width = 24 ,
                 b_width = 32 ,
                 out_width = a_width + b_width 
) 

    (
    input logic signed [a_width-1:0] a,
    input logic signed [b_width-1:0] b,
    output logic signed [out_width-1:0] out
); 

assign out = a * b; 

endmodule: multi

module my_DFF #(
    parameter WIDTH_data =  24
) 
    (
    input logic                          clk , 
    input logic                          rst_n,
    input logic signed  [WIDTH_data-1:0] d_in,
    output logic signed [WIDTH_data-1:0] q_out
);

always_ff@(posedge clk) begin 
    if (!rst_n) begin 
        q_out <= 0;
    end
    else begin 
        q_out <= d_in; 
    end
end

endmodule: my_DFF