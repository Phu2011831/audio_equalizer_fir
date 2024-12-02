library verilog;
use verilog.vl_types.all;
entity audio_equalizer is
    generic(
        ORDER_FIR       : integer := 64;
        COEFF_WIDTH     : integer := 32;
        GAIN_BAND_1     : integer := 9;
        GAIN_BAND_2     : integer := 8;
        GAIN_BAND_3     : integer := 7;
        GAIN_BAND_4     : integer := 6;
        GAIN_BAND_5     : integer := 5;
        GAIN_WIDTH      : integer := 4;
        INPUT_WIDTH     : integer := 24;
        OUTPUT_WIDTH    : vl_notype;
        NUMBER_BANDS    : integer := 4
    );
    port(
        i_clk           : in     vl_logic;
        i_reset_n       : in     vl_logic;
        i_data_audio    : in     vl_logic_vector;
        o_data_audio    : out    vl_logic_vector;
        o_data_single_band: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ORDER_FIR : constant is 1;
    attribute mti_svvh_generic_type of COEFF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of GAIN_BAND_1 : constant is 1;
    attribute mti_svvh_generic_type of GAIN_BAND_2 : constant is 1;
    attribute mti_svvh_generic_type of GAIN_BAND_3 : constant is 1;
    attribute mti_svvh_generic_type of GAIN_BAND_4 : constant is 1;
    attribute mti_svvh_generic_type of GAIN_BAND_5 : constant is 1;
    attribute mti_svvh_generic_type of GAIN_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of INPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of NUMBER_BANDS : constant is 1;
end audio_equalizer;
