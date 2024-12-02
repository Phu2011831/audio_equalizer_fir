/***********************************************************************************************************************
 * Author: Phu040902                                                                         	  				 			  *
 * Module:       audio_equalizer.sv                                   		  											 			  *
 * Description: 9-band EQUALIZER USING FIR FILTER                                                       		 	        *
 * |-----------|----------|----------|----------|-----------|----------|----------|----------|-----------|-----------|  * 	
 * | Name      |  LOWBAND |  BAND2   |   BAND3  |  BAND4    |  BAND5x  |  BAND6x  |  BAND7 x |  BAND8x   |  HIGHBAND |  *
 * |-----------|----------|----------|----------|-----------|----------|----------|----------|-----------|-----------|  * 		
 * | BAND 	   |0-310	  |310-3500	 |3500-10000|10000-14000|  |1000-3000 |3000-6000	|6000-12000|12000-|14000-20000|  *																				  								 *
 * |-----------|----------|----------|----------|-----------|----------|----------|----------|-----------|-----------|  *															                                              *
 * | GAIN		|	9		  |   8      |   7      |   6       |   5      |   4      |   3      |   2       |   1       |  *
 * |----------------------------------------------------------------------------------------------------------------|  *
 *                                                                          											 			  *
 **********************************************************************************************************************/
 
module audio_equalizer #(
				parameter  ORDER_FIR 		= 64,
							  COEFF_WIDTH     = 32,
				
							  GAIN_BAND_1		= 9,
							  GAIN_BAND_2		= 8,
							  GAIN_BAND_3		= 7,
							  GAIN_BAND_4		= 6,
							  GAIN_BAND_5		= 5,
								
							  GAIN_WIDTH		= 4,
							  
							  INPUT_WIDTH		= 24,
							  OUTPUT_WIDTH		= INPUT_WIDTH ,
							  
							  NUMBER_BANDS		= 4
) (
  input logic i_clk,
  input logic i_reset_n,
  input logic signed  [INPUT_WIDTH-1  : 0] i_data_audio,
  output logic signed [OUTPUT_WIDTH+GAIN_WIDTH-1+3 : 0] o_data_audio,
  output logic signed [OUTPUT_WIDTH + GAIN_WIDTH-1 : 0] o_data_single_band   // for check output single band
);

  logic signed [COEFF_WIDTH-1 : 0] coeff1[ORDER_FIR-1 : 0];
  
  logic signed [COEFF_WIDTH-1 : 0] coeff2[ORDER_FIR-1 : 0];

  logic signed [COEFF_WIDTH-1 : 0] coeff3[ORDER_FIR-1 : 0];

  logic signed [COEFF_WIDTH-1 : 0] coeff4[ORDER_FIR-1 : 0];
  
  logic signed [COEFF_WIDTH-1 : 0] coeff5[ORDER_FIR-1 : 0];

  logic signed [OUTPUT_WIDTH+GAIN_WIDTH-1 : 0] o_data_buffer;

  logic signed [INPUT_WIDTH-1  : 0] i_data_1;
  logic signed [OUTPUT_WIDTH-1 : 0] o_data_1;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_2;
  logic signed [OUTPUT_WIDTH-1 : 0] o_data_2;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_3;
  logic signed [OUTPUT_WIDTH-1 : 0] o_data_3;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_4;
  logic signed [OUTPUT_WIDTH-1 : 0] o_data_4;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_5;
  logic signed [OUTPUT_WIDTH-1 : 0] o_data_5;
  
  
  //logic [4:0] gain_band [NUMBER_BANDS-1 : 0];
  
  initial begin 
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients1_hex.txt", coeff1);
	 $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients2_hex.txt", coeff2);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients3_hex.txt", coeff3);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients4_hex.txt", coeff4);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients5_hex.txt", coeff5);

  end 
  
  FIR fir_low (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_1),
					 .h (coeff1)
	);
	
  FIR fir_band2 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_2),
					 .h (coeff2)

	);
	
	 FIR fir_band3 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_3),
					 .h (coeff3)
	);
	
	FIR fir_band4 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_4),
					 .h (coeff4)
	);
	
	FIR fir_highband (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_5),
					 .h (coeff5)

	);
	
	assign o_data_single_band = o_data_1 * GAIN_BAND_1;
	
	/*assign o_data_audio = 	  o_data_1 * GAIN_BAND_1
									+ o_data_2 * GAIN_BAND_2
									+ o_data_3 * GAIN_BAND_3
									+ o_data_4 * GAIN_BAND_4 ;
	*/
	always @ (posedge i_clk or negedge i_reset_n)
		begin: Output_cal
			if (!i_reset_n) begin 
				o_data_audio <= 0;
				o_data_buffer <= 0;
			end
			else begin
				if (i_clk == 1'b1) begin 
					o_data_buffer <= o_data_1 * GAIN_BAND_1
									  + o_data_2 * GAIN_BAND_2
									  + o_data_3 * GAIN_BAND_3
									  + o_data_4 * GAIN_BAND_4 
									  + o_data_5 * GAIN_BAND_5;
									  
				end
			end
		end
		
		assign o_data_out = o_data_buffer;
endmodule
	
	