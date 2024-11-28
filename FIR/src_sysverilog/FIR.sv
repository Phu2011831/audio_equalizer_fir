module FIR (
    input logic clk,                       
    input logic reset_n,                     
    input logic signed [23:0] data_in,     
    output logic signed [23:0] data_out    
);
  
  parameter N = 64 ;
  logic signed [23:0] gain[0:N-1] = '{
//he so sine/ecg
 24'h027CA
,24'h03556
,24'h0452A
,24'h05760
,24'h06C10
,24'h08346
,24'h09D06
,24'h0B94C
,24'h0D808
,24'h0F91F
,24'h11C6F
,24'h141C6
,24'h168EC
,24'h1919C
,24'h1BB89
,24'h1E65C
,24'h211B9
,24'h23D3A
,24'h26876
,24'h29301
,24'h2BC6B
,24'h2E445
,24'h30A20
,24'h32D92
,24'h34E35
,24'h36BA9
,24'h38597
,24'h39BB0
,24'h3ADB1
,24'h3BB64
,24'h3C49D
,24'h3C941
,24'h3C941
,24'h3C49D
,24'h3BB64
,24'h3ADB1
,24'h39BB0
,24'h38597
,24'h36BA9
,24'h34E35
,24'h32D92
,24'h30A20
,24'h2E445
,24'h2BC6B
,24'h29301
,24'h26876
,24'h23D3A
,24'h211B9
,24'h1E65C
,24'h1BB89
,24'h1919C
,24'h168EC
,24'h141C6
,24'h11C6F
,24'h0F91F
,24'h0D808
,24'h0B94C
,24'h09D06
,24'h08346
,24'h06C10
,24'h05760
,24'h0452A
,24'h03556
,24'h027CA

//he so audio
/*24'hFFE37E,
24'hFFDA1A,
24'hFFD519,
24'hFFD7E3,
24'hFFE549,
24'hFFFEBC,
24'h002387,
24'h00505E,
24'h007F41,
24'h00A7ED,
24'h00C0CD,
24'h00C068,
24'h009F21,
24'h0058FF,
24'hFFEF44,
24'hFF697B,
24'hFED5B9,
24'hFE47F3,
24'hFDD84F,
24'hFDA097,
24'hFDB914,
24'hFE3525,
24'hFF2012,
24'h007A97,
24'h023980,
24'h0445A5,
24'h067D70,
24'h08B7B7,
24'h0AC7C0,
24'h0C81DE,
24'h0DC02B,
24'h0E66B8,
24'h0E66B8,
24'h0DC02B,
24'h0C81DE,
24'h0AC7C0,
24'h08B7B7,
24'h067D70,
24'h0445A5,
24'h023980,
24'h007A97,
24'hFF2012,
24'hFE3525,
24'hFDB914,
24'hFDA097,
24'hFDD84F,
24'hFE47F3,
24'hFED5B9,
24'hFF697B,
24'hFFEF44,
24'h0058FF,
24'h009F21,
24'h00C068,
24'h00C0CD,
24'h00A7ED,
24'h007F41,
24'h00505E,
24'h002387,
24'hFFFEBC,
24'hFFE549,
24'hFFD7E3,
24'hFFD519,
24'hFFDA1A,
24'hFFE37E*/
};
	 integer i;
    logic signed [23:0] buff[0:N-1];
    logic signed [47:0] acc;
 
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin	
            data_out <= 24'd0;
            acc <= 48'd0;
            for ( i = 0; i <= N-1; i=i+1) begin
                buff[i] <= 24'd0;
            end
        end else begin
            buff[0] <= data_in;
            for ( i = 1; i <= N-1; i=i+1) begin
                buff[i] <= buff[i-1];
            end
            acc = 48'd0;

            for ( i = 0; i <= N-1;i= i+1) begin
                acc += buff[i] * gain[i];
            end
            data_out <= acc[47:24];  
        end
    end
endmodule