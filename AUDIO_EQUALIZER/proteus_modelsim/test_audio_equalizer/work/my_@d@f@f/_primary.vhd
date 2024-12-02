library verilog;
use verilog.vl_types.all;
entity my_DFF is
    generic(
        WIDTH_data      : integer := 24
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        d_in            : in     vl_logic_vector;
        q_out           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH_data : constant is 1;
end my_DFF;
