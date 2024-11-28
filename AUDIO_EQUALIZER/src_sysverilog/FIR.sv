`timescale 1ns / 1ps
module FIR (
    input logic clk,                       
    input logic reset_n,                     
    input logic signed [23:0] data_in,     
    output logic signed [23:0] data_out,
	 input logic signed [31 : 0] gain [0 : 64-1]
);
  
	 parameter N = 64 ;
	 integer i;
    logic signed [23:0] buff[0:N-1];
    logic signed [55:0] acc;
	 
	 //assign gain = coeff;
	 
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin	
            data_out <= 24'd0;
            acc <= 55'd0;
            for ( i = 0; i <= N-1; i=i+1) begin
                buff[i] <= 24'd0;
            end
        end else begin
            buff[0] <= data_in;
            for ( i = 1; i <= N-1; i=i+1) begin
                buff[i] <= buff[i-1];
            end
            acc = 55'd0;

            for ( i = 0; i <= N-1;i= i+1) begin
                acc += buff[i] * gain[i];
            end
            data_out <= acc[55:24];  
        end
    end
endmodule