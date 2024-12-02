`timescale 1ns/1ns

module audio_equalizer_tb();
	localparam FILE_PATH = "C:/Users/phung/OneDrive/Documents/output_file.hex";

	localparam OUT_PATH = "C:/Users/phung/OneDrive/Documents/out.hex";
	localparam FREQ = 100_000_000;
	
	localparam WD_IN       = 24                ; // Data width
	localparam WD_OUT      = 24                ;
	localparam WD_GAIN     = 4		;
	localparam PERIOD      = 1_000_000_000/FREQ;
	localparam HALF_PERIOD = PERIOD/2          ;

	// Testbench signals
	reg               clk, reset_n;
	reg  [ WD_IN-1:0] data_in ;
	wire [WD_OUT+4-1:0] data_out;
	wire [WD_OUT-1:0] data_single_out;
	
	integer file, status, outfile;

	real analog_in, analog_out;
	assign analog_in  = $itor($signed(data_in));
	assign analog_out = $itor($signed(data_out));

	audio_equalizer dut (
		.i_clk     (clk     ),
		.i_reset_n (reset_n ),
		.i_data_audio (data_in ),
		.o_data_audio(data_out),
		.o_data_single_band (data_single_out)
	);

	// Clock generation
	always #HALF_PERIOD clk = ~clk;

	// Test procedure
	initial begin
		// Initialize inputs
		clk     = 0;
		reset_n = 0;
		data_in = 0;

		// Apply reset
		#PERIOD reset_n = 1;  // Deassert reset after a period

		// Read hex file
		file = $fopen(FILE_PATH,"r");
		outfile = $fopen(OUT_PATH, "w");
		if (file == 0)    $error("Hex file not opened");
		if (outfile == 0) $error("Output file not opened");
		do begin
			status = $fscanf(file, "%h", data_in);
			@(posedge clk);
			$fdisplay(outfile, "%h", data_out);
		end while (status != -1);

		// Wait for a while to observe output
		#1000000 $finish;  // Stop simulation after 100 time units
		$fclose(file);
		$fclose(outfile);
	end

	// Monitor signals for debugging
	initial begin
		$monitor("Time = %0t | Reset = %b | Data In = %h | Data Out = %h | Data FIR LOW PASS = %h",
      $time, reset_n, data_in, data_out, data_single_out);
	  
	end

endmodule 
