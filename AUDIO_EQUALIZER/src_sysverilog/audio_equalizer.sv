/***********************************************************************************************************************
 * Author: Phu040902                                                                         	  				 			  *
 * Module:       audio_equalizer.sv                                   		  											 			  *
 * Description: 9-band EQUALIZER USING FIR FILTER                                                       		 	        *
 * |-----------|----------|----------|----------|----------|----------|----------|----------|-----------|-----------|  * 	
 * | Name      |  LOWBAND |  BAND2   |   BAND3  |  BAND4   |  BAND5   |  BAND6   |  BAND7   |  BAND8    |  HIGHBAND |  *
 * |-----------|----------|----------|----------|----------|----------|----------|----------|-----------|-----------|  * 		
 * | BAND 	   |0-170	  |170-310	 |310-600   |600-1000  |1000-3000 |3000-6000	|6000-12000|12000-14000|14000-20000|  *																				  								 *
 * |-----------|----------|----------|----------|----------|----------|----------|----------|-----------|-----------|  *															                                              *
 * | GAIN		|	9		  |   8      |   7      |   6      |   5      |   4      |   3      |   2       |   1       |  *
 * |----------------------------------------------------------------------------------------------------------------|  *
 *                                                                          											 			  *
 **********************************************************************************************************************/
`timescale 1ns / 1ps
 
module audio_equalizer #(
				parameter  ORDER_FIR 		= 64,
							  COEFF_WIDTH     = 32,
				
							  GAIN_BAND_1		= 9,
							  GAIN_BAND_2		= 8,
							  GAIN_BAND_3		= 7,
							  GAIN_BAND_4		= 6,
							  GAIN_BAND_5		= 5,
							  GAIN_BAND_6		= 4,
							  GAIN_BAND_7		= 3,
							  GAIN_BAND_8		= 2,
							  GAIN_BAND_9		= 1,
							  
							  INPUT_WIDTH		= 24,
							  OUTPUT_WIDTH		= 24,
							  
							  NUMBER_BANDS		= 9
) (
  input logic i_clk,
  input logic i_reset_n,
  input logic signed  [INPUT_WIDTH-1  : 0] i_data_audio,
  output logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_audio,
  input logic [4:0] gain_band [NUMBER_BANDS-1 : 0],
  output logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_single_band   // for check output single band
);

	logic signed [COEFF_WIDTH-1 : 0] coeff1[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff2[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff3[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff4[0 : ORDER_FIR-1];
	
	logic signed [COEFF_WIDTH-1 : 0] coeff5[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff6[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff7[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff8[0 : ORDER_FIR-1];

	logic signed [COEFF_WIDTH-1 : 0] coeff9[0 : ORDER_FIR-1];

  logic signed [INPUT_WIDTH-1  : 0] i_data_1;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_1;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_2;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_2;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_3;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_3;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_4;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_4;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_5;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_5;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_6;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_6;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_7;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_7;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_8;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_8;
  
  logic signed [INPUT_WIDTH-1  : 0] i_data_9;
  logic signed [OUTPUT_WIDTH*2-1 : 0] o_data_9;
  
  //logic [4:0] gain_band [NUMBER_BANDS-1 : 0];
  
  initial begin 
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients1_hex.txt", coeff1);
	 $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients2_hex.txt", coeff2);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients3_hex.txt", coeff3);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients4_hex.txt", coeff4);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients5_hex.txt", coeff5);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients6_hex.txt", coeff6);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients7_hex.txt", coeff7);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients8_hex.txt", coeff8);
    $readmemh ("C:/GITHUB_PROJECT/GUI-based-6-band-Audio-Equalizer-in-MATLAB/fir_coefficients9_hex.txt", coeff9);
  end 
  
  FIR fir_low (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_1),
					 .gain (coeff1)
	);
	
  FIR fir_band2 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_2),
					 .gain (coeff2)

	);
	
	 FIR fir_band3 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_3),
					 .gain (coeff3)
	);
	
	 FIR fir_band4 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_4),
					 .gain (coeff4)

	);
	
	 FIR fir_band5 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_5),
					 .gain (coeff5)

	);
	
	 FIR fir_band6 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_6),
					 .gain (coeff6)
	);
	
	 FIR fir_band7 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_7),
					 .gain (coeff7)
	);
	
	 FIR fir_band8 (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_8),
					 .gain (coeff8)

	);
	
	 FIR fir_highband (
					 .clk (i_clk),
					 .reset_n (i_reset_n),
					 .data_in (i_data_audio),
					 .data_out (o_data_9),
					 .gain (coeff9)

	);
	
	assign o_data_single_band = o_data_1 * GAIN_BAND_1;
	
	assign o_data_audio = 	  o_data_1 * GAIN_BAND_1
									+ o_data_2 * GAIN_BAND_2
									+ o_data_3 * GAIN_BAND_3
									+ o_data_4 * GAIN_BAND_4
									+ o_data_5 * GAIN_BAND_5
									+ o_data_6 * GAIN_BAND_6
									+ o_data_7 * GAIN_BAND_7
									+ o_data_8 * GAIN_BAND_8
									+ o_data_9 * GAIN_BAND_9 ;
endmodule
	
	