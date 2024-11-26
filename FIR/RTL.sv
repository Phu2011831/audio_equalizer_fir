module RTL (
    input logic clk, reset_n,
    input logic signed [23:0] data_in,
    output logic signed [23:0] data_out
);
// RTL FIR basic 3 tap
/*
logic signed [23:0] delay1, delay2, delay3;
logic signed [23:0] acc;
logic signed [23:0] gain1 = 1;
logic signed [23:0] gain2 = 2;
logic signed [23:0] gain3 = 3;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        data_out <= 0;
        delay1 <= 0;
        delay2 <= 0;
        delay3 <= 0;
        acc <= 0;
    end else begin
        // Cập nhật các giá trị delay
        delay1 <= data_in;
        delay2 <= delay1;
        delay3 <= delay2;

        // Tính toán acc dựa trên các giá trị delay và gain
        acc <= delay1 * gain1 + delay2 * gain2 + delay3 * gain3;
        data_out <= acc;
    end
end
*/

//RTL FIR pipelining 3 tap
logic signed [23:0] areg1, areg2, areg3;
logic signed [23:0] mreg1, mreg2, mreg3;
logic signed [23:0] preg1, preg2;
logic signed [23:0] coeff1 = 1;
logic signed [23:0] coeff2 = 2;
logic signed [23:0] coeff3 = 3;
logic signed [23:0] mul1,mul2,mul3;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        areg1 <= 0;
        areg2 <= 0;
        areg3 <= 0;
    end else begin      
        areg1 <= data_in;
        areg2 <= areg1;
        areg3 <= areg2;
		  mul1 = areg1 * coeff1;
		  mul2 = areg2 * coeff2;
		  mul3 = areg3 * coeff3;
    end
end
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        mreg1 <= 0;
        mreg2 <= 0;
        mreg3 <= 0;
    end else begin
		  mreg1=mul1;
		  mreg2=mul2;
		  mreg3=mul3;
    end
end
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        preg1 <= 0;
        preg2 <= 0;
    end else begin
		  preg1=mreg1;
		  preg2=preg1 + mreg2;
		  data_out = preg2 + mreg3;
    end
end
endmodule
