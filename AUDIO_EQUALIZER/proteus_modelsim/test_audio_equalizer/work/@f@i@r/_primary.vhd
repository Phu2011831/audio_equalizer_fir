library verilog;
use verilog.vl_types.all;
entity FIR is
    generic(
        WIDTH_data      : integer := 24;
        WIDTH_coeff     : integer := 32;
        WIDTH_reg       : vl_notype;
        TAP             : integer := 64
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector;
        h               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH_data : constant is 1;
    attribute mti_svvh_generic_type of WIDTH_coeff : constant is 1;
    attribute mti_svvh_generic_type of WIDTH_reg : constant is 3;
    attribute mti_svvh_generic_type of TAP : constant is 1;
end FIR;
