-- vhd file for CTL
-- modifications made by Sanjana Sekhar
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.ctp7_utils_pkg.all;


library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity ctp7_top is
  generic (
    C_DATE_CODE      : std_logic_vector (31 downto 0) := x"00000000";
    C_GITHASH_CODE   : std_logic_vector (31 downto 0) := x"00000000";
    C_GIT_REPO_DIRTY : std_logic                      := '0'
    );
  Port (
  
      clk_200_diff_in_clk_p : in std_logic;
      clk_200_diff_in_clk_n : in std_logic;
    
      LEDs : out std_logic_vector (1 downto 0);
    
      LED_GREEN_o : out std_logic;
      LED_RED_o   : out std_logic;
      LED_BLUE_o  : out std_logic;
    
      axi_c2c_v7_to_zynq_data        : out std_logic_vector (16 downto 0);
      axi_c2c_v7_to_zynq_clk         : out std_logic;
      axi_c2c_zynq_to_v7_clk         : in  std_logic;
      axi_c2c_zynq_to_v7_data        : in  std_logic_vector (16 downto 0);
      axi_c2c_v7_to_zynq_link_status : out std_logic;
      axi_c2c_zynq_to_v7_reset       : in  std_logic
   );
end ctp7_top;

architecture ctp7_top_arch of ctp7_top is

  component v7_bd is
  port (

    clk_200_diff_in_clk_n : in STD_LOGIC;
    clk_200_diff_in_clk_p : in STD_LOGIC;
    
    axi_c2c_zynq_to_v7_clk : in STD_LOGIC;
    axi_c2c_zynq_to_v7_data : in STD_LOGIC_VECTOR ( 16 downto 0 );
    axi_c2c_v7_to_zynq_link_status : out STD_LOGIC;
    axi_c2c_v7_to_zynq_clk : out STD_LOGIC;
    axi_c2c_v7_to_zynq_data : out STD_LOGIC_VECTOR ( 16 downto 0 );
    axi_c2c_zynq_to_v7_reset : in STD_LOGIC;

    BRAM_CTRL_REG_FILE_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_REG_FILE_clk : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_en : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_rst : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );

    BRAM_CTRL_INPUT_RAM_0_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_INPUT_RAM_0_clk : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_0_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_0_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_0_en : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_0_rst : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_0_we : out STD_LOGIC_VECTOR ( 3 downto 0 );

    BRAM_CTRL_INPUT_RAM_1_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_INPUT_RAM_1_clk : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_1_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_1_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_1_en : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_1_rst : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_1_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    
    BRAM_CTRL_INPUT_RAM_2_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_INPUT_RAM_2_clk : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_2_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_2_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_INPUT_RAM_2_en : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_2_rst : out STD_LOGIC;
    BRAM_CTRL_INPUT_RAM_2_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    
    BRAM_CTRL_OUTPUT_RAM_0_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_0_clk : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_0_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_0_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_0_en : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_0_rst : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_0_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    
    BRAM_CTRL_OUTPUT_RAM_1_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_1_clk : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_1_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_1_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_OUTPUT_RAM_1_en : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_1_rst : out STD_LOGIC;
    BRAM_CTRL_OUTPUT_RAM_1_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    
    clk_50mhz : out STD_LOGIC;
    clk_240mhz : out STD_LOGIC    
    
  );
  end component v7_bd;
  
COMPONENT ila_hls
       
       PORT (
           clk : IN STD_LOGIC;
       
       
       
           probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
           probe6 : IN STD_LOGIC_VECTOR(191 DOWNTO 0);
           probe7 : IN STD_LOGIC_VECTOR(191 DOWNTO 0)
       );
       END COMPONENT  ;
  

  signal s_clk_50  : std_logic;
  signal s_clk_240        : std_logic;

  signal BRAM_CTRL_REG_FILE_en   : std_logic;
  signal BRAM_CTRL_REG_FILE_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_REG_FILE_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_REG_FILE_we   : std_logic_vector (3 downto 0);
  signal BRAM_CTRL_REG_FILE_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_REG_FILE_clk  : std_logic;
  signal BRAM_CTRL_REG_FILE_rst  : std_logic;

  signal BRAM_CTRL_INPUT_RAM_0_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_INPUT_RAM_0_clk  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_0_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_0_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_0_en   : std_logic;
  signal BRAM_CTRL_INPUT_RAM_0_rst  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_0_we   : std_logic_vector (3 downto 0);

  signal BRAM_CTRL_INPUT_RAM_1_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_INPUT_RAM_1_clk  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_1_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_1_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_1_en   : std_logic;
  signal BRAM_CTRL_INPUT_RAM_1_rst  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_1_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_CTRL_INPUT_RAM_2_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_INPUT_RAM_2_clk  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_2_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_2_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_INPUT_RAM_2_en   : std_logic;
  signal BRAM_CTRL_INPUT_RAM_2_rst  : std_logic;
  signal BRAM_CTRL_INPUT_RAM_2_we   : std_logic_vector (3 downto 0);

  signal BRAM_CTRL_OUTPUT_RAM_0_addr : std_logic_vector (16 downto 0); 
  signal BRAM_CTRL_OUTPUT_RAM_0_clk  : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_0_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_OUTPUT_RAM_0_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_OUTPUT_RAM_0_en   : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_0_rst  : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_0_we   : std_logic_vector (3 downto 0);

  signal BRAM_CTRL_OUTPUT_RAM_1_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_OUTPUT_RAM_1_clk  : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_1_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_OUTPUT_RAM_1_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_OUTPUT_RAM_1_en   : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_1_rst  : std_logic;
  signal BRAM_CTRL_OUTPUT_RAM_1_we   : std_logic_vector (3 downto 0);

  signal s_LED_FP : std_logic_vector(31 downto 0);
  
  signal s_pattern_start_request: std_logic;
  signal s_algo_latency :  std_logic_vector ( 15 downto 0 );
  
  signal s_pattern_start, s_pattern_start_s1, s_pattern_start_s2:  std_logic;
  
  signal s_INPUT_RAM_start:  std_logic;
  signal s_OUTPUT_RAM_start:  std_logic;
  
  signal s_INPUT_link_arr :  t_slv_arr_192(66 downto 0) := (others => (others => '0'));
  signal s_OUTPUT_link_arr:   t_slv_arr_192(47 downto 0) := (others => (others => '0'));
  signal s_cfg_reg : t_slv_arr_32(31 downto 0);

-----------------------------------------------------------------------------
-- Begin User_Code
-----------------------------------------------------------------------------
 COMPONENT getClusterTrackLinker_0
    PORT (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      ap_start : IN STD_LOGIC;
      ap_done : OUT STD_LOGIC;
      ap_idle : OUT STD_LOGIC;
      ap_ready : OUT STD_LOGIC;
peakEta_0_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_0_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_0_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_0_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_1_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_1_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_1_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_1_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_2_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_2_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_2_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_2_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_3_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_3_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_3_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_3_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_4_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_4_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_4_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_4_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_5_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_5_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_5_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_5_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_6_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_6_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_6_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_6_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_7_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_7_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_7_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_7_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_8_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_8_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_8_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_8_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_9_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_9_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_9_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_9_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_10_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_10_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_10_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_10_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_11_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_11_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_11_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_11_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_12_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_12_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_12_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_12_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_13_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_13_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_13_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_13_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_14_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_14_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_14_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_14_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_15_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_15_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_15_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_15_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_16_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_16_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_16_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakEta_16_3 : IN STD_LOGIC_VECTOR (15 downto 0);
    
peakPhi_0_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_0_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_0_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_0_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_1_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_1_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_1_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_1_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_2_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_2_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_2_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_2_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_3_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_3_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_3_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_3_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_4_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_4_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_4_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_4_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_5_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_5_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_5_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_5_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_6_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_6_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_6_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_6_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_7_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_7_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_7_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_7_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_8_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_8_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_8_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_8_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_9_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_9_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_9_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_9_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_10_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_10_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_10_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_10_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_11_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_11_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_11_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_11_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_12_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_12_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_12_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_12_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_13_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_13_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_13_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_13_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_14_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_14_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_14_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_14_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_15_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_15_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_15_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_15_3 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_16_0 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_16_1 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_16_2 : IN STD_LOGIC_VECTOR (15 downto 0);
peakPhi_16_3 : IN STD_LOGIC_VECTOR (15 downto 0);

smallClusterET_0_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_0_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_0_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_0_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_1_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_1_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_1_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_1_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_2_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_2_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_2_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_2_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_3_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_3_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_3_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_3_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_4_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_4_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_4_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_4_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_5_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_5_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_5_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_5_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_6_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_6_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_6_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_6_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_7_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_7_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_7_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_7_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_8_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_8_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_8_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_8_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_9_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_9_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_9_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_9_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_10_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_10_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_10_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_10_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_11_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_11_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_11_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_11_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_12_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_12_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_12_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_12_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_13_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_13_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_13_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_13_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_14_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_14_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_14_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_14_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_15_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_15_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_15_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_15_3 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_16_0 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_16_1 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_16_2 : IN STD_LOGIC_VECTOR (15 downto 0);
smallClusterET_16_3 : IN STD_LOGIC_VECTOR (15 downto 0);

trackPT_0 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_1 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_2 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_3 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_4 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_5 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_6 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_7 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_8 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_9 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_10 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_11 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_12 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_13 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_14 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_15 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_16 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_17 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_18 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPT_19 : IN STD_LOGIC_VECTOR (15 downto 0);

trackEta_0 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_1 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_2 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_3 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_4 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_5 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_6 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_7 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_8 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_9 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_10 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_11 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_12 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_13 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_14 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_15 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_16 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_17 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_18 : IN STD_LOGIC_VECTOR (15 downto 0);
trackEta_19 : IN STD_LOGIC_VECTOR (15 downto 0);

trackPhi_0 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_1 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_2 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_3 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_4 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_5 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_6 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_7 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_8 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_9 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_10 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_11 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_12 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_13 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_14 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_15 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_16 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_17 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_18 : IN STD_LOGIC_VECTOR (15 downto 0);
trackPhi_19 : IN STD_LOGIC_VECTOR (15 downto 0);

linkedTrackPT_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPT_19 : OUT STD_LOGIC_VECTOR (15 downto 0);

linkedTrackEta_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackEta_19 : OUT STD_LOGIC_VECTOR (15 downto 0);

linkedTrackPhi_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackPhi_19 : OUT STD_LOGIC_VECTOR (15 downto 0);

linkedTrackQuality_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
linkedTrackQuality_19 : OUT STD_LOGIC_VECTOR (15 downto 0);

neutralClusterET_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_19 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_20 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_21 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_22 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_23 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_24 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_25 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_26 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_27 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_28 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_29 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_30 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_31 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_32 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_33 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_34 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_35 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_36 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_37 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_38 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_39 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_40 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_41 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_42 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_43 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_44 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_45 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_46 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_47 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_48 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_49 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_50 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_51 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_52 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_53 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_54 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_55 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_56 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_57 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_58 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_59 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_60 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_61 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_62 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_63 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_64 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_65 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_66 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterET_67 : OUT STD_LOGIC_VECTOR (15 downto 0);

neutralClusterEta_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_19 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_20 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_21 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_22 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_23 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_24 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_25 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_26 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_27 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_28 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_29 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_30 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_31 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_32 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_33 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_34 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_35 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_36 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_37 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_38 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_39 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_40 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_41 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_42 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_43 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_44 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_45 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_46 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_47 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_48 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_49 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_50 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_51 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_52 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_53 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_54 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_55 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_56 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_57 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_58 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_59 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_60 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_61 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_62 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_63 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_64 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_65 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_66 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterEta_67 : OUT STD_LOGIC_VECTOR (15 downto 0);

neutralClusterPhi_0 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_1 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_2 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_3 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_4 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_5 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_6 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_7 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_8 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_9 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_10 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_11 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_12 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_13 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_14 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_15 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_16 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_17 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_18 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_19 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_20 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_21 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_22 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_23 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_24 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_25 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_26 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_27 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_28 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_29 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_30 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_31 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_32 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_33 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_34 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_35 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_36 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_37 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_38 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_39 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_40 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_41 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_42 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_43 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_44 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_45 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_46 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_47 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_48 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_49 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_50 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_51 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_52 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_53 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_54 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_55 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_56 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_57 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_58 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_59 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_60 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_61 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_62 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_63 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_64 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_65 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_66 : OUT STD_LOGIC_VECTOR (15 downto 0);
neutralClusterPhi_67 : OUT STD_LOGIC_VECTOR (15 downto 0)
);
  END COMPONENT;  

-- HLS Algo Control/Handshake Interface
      signal ap_clk :  STD_LOGIC;
      signal ap_rst :  STD_LOGIC;
      signal ap_start :  STD_LOGIC;
      signal ap_done :  STD_LOGIC;
      signal ap_idle :  STD_LOGIC;
      signal ap_ready :  STD_LOGIC;

signal peakEta_0_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_0_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_0_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_0_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_1_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_1_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_1_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_1_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_2_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_2_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_2_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_2_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_3_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_3_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_3_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_3_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_4_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_4_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_4_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_4_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_5_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_5_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_5_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_5_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_6_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_6_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_6_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_6_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_7_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_7_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_7_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_7_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_8_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_8_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_8_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_8_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_9_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_9_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_9_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_9_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_10_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_10_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_10_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_10_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_11_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_11_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_11_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_11_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_12_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_12_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_12_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_12_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_13_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_13_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_13_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_13_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_14_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_14_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_14_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_14_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_15_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_15_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_15_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_15_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_16_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_16_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_16_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakEta_16_3 : STD_LOGIC_VECTOR (15 downto 0);

signal peakPhi_0_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_0_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_0_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_0_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_1_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_1_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_1_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_1_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_2_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_2_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_2_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_2_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_3_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_3_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_3_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_3_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_4_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_4_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_4_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_4_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_5_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_5_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_5_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_5_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_6_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_6_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_6_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_6_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_7_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_7_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_7_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_7_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_8_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_8_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_8_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_8_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_9_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_9_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_9_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_9_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_10_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_10_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_10_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_10_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_11_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_11_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_11_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_11_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_12_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_12_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_12_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_12_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_13_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_13_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_13_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_13_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_14_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_14_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_14_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_14_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_15_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_15_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_15_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_15_3 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_16_0 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_16_1 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_16_2 : STD_LOGIC_VECTOR (15 downto 0);
signal peakPhi_16_3 : STD_LOGIC_VECTOR (15 downto 0);

signal smallClusterET_0_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_0_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_0_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_0_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_1_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_1_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_1_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_1_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_2_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_2_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_2_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_2_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_3_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_3_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_3_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_3_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_4_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_4_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_4_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_4_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_5_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_5_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_5_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_5_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_6_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_6_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_6_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_6_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_7_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_7_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_7_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_7_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_8_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_8_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_8_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_8_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_9_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_9_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_9_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_9_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_10_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_10_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_10_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_10_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_11_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_11_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_11_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_11_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_12_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_12_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_12_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_12_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_13_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_13_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_13_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_13_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_14_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_14_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_14_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_14_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_15_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_15_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_15_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_15_3 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_16_0 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_16_1 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_16_2 : STD_LOGIC_VECTOR (15 downto 0);
signal smallClusterET_16_3 : STD_LOGIC_VECTOR (15 downto 0);

signal trackPT_0 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_1 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_2 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_3 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_4 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_5 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_6 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_7 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_8 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_9 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_10 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_11 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_12 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_13 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_14 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_15 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_16 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_17 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_18 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPT_19 : STD_LOGIC_VECTOR (15 downto 0);

signal trackEta_0 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_1 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_2 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_3 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_4 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_5 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_6 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_7 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_8 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_9 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_10 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_11 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_12 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_13 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_14 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_15 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_16 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_17 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_18 : STD_LOGIC_VECTOR (15 downto 0);
signal trackEta_19 : STD_LOGIC_VECTOR (15 downto 0);

signal trackPhi_0 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_1 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_2 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_3 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_4 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_5 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_6 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_7 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_8 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_9 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_10 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_11 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_12 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_13 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_14 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_15 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_16 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_17 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_18 : STD_LOGIC_VECTOR (15 downto 0);
signal trackPhi_19 : STD_LOGIC_VECTOR (15 downto 0);

signal linkedTrackPT_0 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_1 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_2 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_3 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_4 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_5 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_6 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_7 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_8 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_9 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_10 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_11 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_12 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_13 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_14 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_15 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_16 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_17 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_18 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPT_19 : STD_LOGIC_VECTOR (15 downto 0);

signal linkedTrackEta_0 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_1 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_2 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_3 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_4 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_5 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_6 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_7 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_8 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_9 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_10 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_11 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_12 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_13 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_14 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_15 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_16 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_17 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_18 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackEta_19 : STD_LOGIC_VECTOR (15 downto 0);

signal linkedTrackPhi_0 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_1 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_2 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_3 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_4 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_5 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_6 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_7 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_8 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_9 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_10 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_11 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_12 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_13 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_14 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_15 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_16 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_17 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_18 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackPhi_19 : STD_LOGIC_VECTOR (15 downto 0);

signal linkedTrackQuality_0 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_1 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_2 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_3 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_4 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_5 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_6 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_7 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_8 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_9 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_10 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_11 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_12 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_13 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_14 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_15 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_16 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_17 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_18 : STD_LOGIC_VECTOR (15 downto 0);
signal linkedTrackQuality_19 : STD_LOGIC_VECTOR (15 downto 0);

signal neutralClusterET_0 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_1 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_2 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_3 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_4 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_5 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_6 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_7 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_8 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_9 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_10 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_11 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_12 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_13 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_14 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_15 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_16 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_17 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_18 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_19 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_20 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_21 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_22 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_23 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_24 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_25 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_26 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_27 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_28 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_29 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_30 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_31 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_32 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_33 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_34 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_35 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_36 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_37 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_38 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_39 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_40 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_41 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_42 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_43 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_44 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_45 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_46 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_47 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_48 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_49 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_50 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_51 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_52 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_53 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_54 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_55 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_56 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_57 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_58 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_59 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_60 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_61 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_62 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_63 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_64 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_65 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_66 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterET_67 : STD_LOGIC_VECTOR (15 downto 0);

signal neutralClusterEta_0 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_1 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_2 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_3 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_4 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_5 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_6 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_7 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_8 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_9 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_10 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_11 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_12 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_13 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_14 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_15 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_16 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_17 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_18 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_19 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_20 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_21 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_22 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_23 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_24 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_25 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_26 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_27 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_28 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_29 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_30 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_31 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_32 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_33 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_34 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_35 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_36 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_37 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_38 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_39 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_40 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_41 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_42 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_43 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_44 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_45 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_46 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_47 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_48 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_49 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_50 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_51 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_52 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_53 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_54 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_55 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_56 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_57 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_58 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_59 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_60 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_61 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_62 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_63 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_64 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_65 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_66 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterEta_67 : STD_LOGIC_VECTOR (15 downto 0);

signal neutralClusterPhi_0 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_1 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_2 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_3 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_4 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_5 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_6 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_7 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_8 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_9 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_10 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_11 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_12 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_13 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_14 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_15 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_16 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_17 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_18 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_19 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_20 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_21 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_22 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_23 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_24 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_25 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_26 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_27 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_28 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_29 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_30 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_31 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_32 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_33 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_34 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_35 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_36 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_37 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_38 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_39 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_40 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_41 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_42 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_43 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_44 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_45 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_46 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_47 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_48 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_49 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_50 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_51 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_52 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_53 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_54 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_55 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_56 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_57 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_58 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_59 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_60 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_61 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_62 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_63 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_64 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_65 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_66 : STD_LOGIC_VECTOR (15 downto 0);
signal neutralClusterPhi_67 : STD_LOGIC_VECTOR (15 downto 0);
  
 
-----------------------------------------------------------------------------
-- End User_Code
-----------------------------------------------------------------------------
           
begin

    LED_GREEN_o <= s_LED_FP(0);
    LED_RED_o   <= s_LED_FP(1);
    LED_BLUE_o  <= s_LED_FP(2);

  i_v7_bd : v7_bd
    port map (
    
        axi_c2c_v7_to_zynq_clk               => axi_c2c_v7_to_zynq_clk,
        axi_c2c_v7_to_zynq_data(16 downto 0) => axi_c2c_v7_to_zynq_data(16 downto 0),
        axi_c2c_v7_to_zynq_link_status       => axi_c2c_v7_to_zynq_link_status,
        axi_c2c_zynq_to_v7_clk               => axi_c2c_zynq_to_v7_clk,
        axi_c2c_zynq_to_v7_data(16 downto 0) => axi_c2c_zynq_to_v7_data(16 downto 0),
        axi_c2c_zynq_to_v7_reset             => axi_c2c_zynq_to_v7_reset,
    
        clk_200_diff_in_clk_n => clk_200_diff_in_clk_n,
        clk_200_diff_in_clk_p => clk_200_diff_in_clk_p,
        
        BRAM_CTRL_REG_FILE_addr => BRAM_CTRL_REG_FILE_addr,
        BRAM_CTRL_REG_FILE_clk  => BRAM_CTRL_REG_FILE_clk,
        BRAM_CTRL_REG_FILE_din  => BRAM_CTRL_REG_FILE_din,
        BRAM_CTRL_REG_FILE_dout => BRAM_CTRL_REG_FILE_dout,
        BRAM_CTRL_REG_FILE_en   => BRAM_CTRL_REG_FILE_en,
        BRAM_CTRL_REG_FILE_rst  => BRAM_CTRL_REG_FILE_rst,
        BRAM_CTRL_REG_FILE_we   => BRAM_CTRL_REG_FILE_we,

        BRAM_CTRL_INPUT_RAM_0_addr => BRAM_CTRL_INPUT_RAM_0_addr,
        BRAM_CTRL_INPUT_RAM_0_clk  => BRAM_CTRL_INPUT_RAM_0_clk,
        BRAM_CTRL_INPUT_RAM_0_din  => BRAM_CTRL_INPUT_RAM_0_din,
        BRAM_CTRL_INPUT_RAM_0_dout => BRAM_CTRL_INPUT_RAM_0_dout,
        BRAM_CTRL_INPUT_RAM_0_en   => BRAM_CTRL_INPUT_RAM_0_en,
        BRAM_CTRL_INPUT_RAM_0_rst  => BRAM_CTRL_INPUT_RAM_0_rst,
        BRAM_CTRL_INPUT_RAM_0_we   => BRAM_CTRL_INPUT_RAM_0_we,

        BRAM_CTRL_INPUT_RAM_1_addr => BRAM_CTRL_INPUT_RAM_1_addr,
        BRAM_CTRL_INPUT_RAM_1_clk  => BRAM_CTRL_INPUT_RAM_1_clk,
        BRAM_CTRL_INPUT_RAM_1_din  => BRAM_CTRL_INPUT_RAM_1_din,
        BRAM_CTRL_INPUT_RAM_1_dout => BRAM_CTRL_INPUT_RAM_1_dout,
        BRAM_CTRL_INPUT_RAM_1_en   => BRAM_CTRL_INPUT_RAM_1_en,
        BRAM_CTRL_INPUT_RAM_1_rst  => BRAM_CTRL_INPUT_RAM_1_rst,
        BRAM_CTRL_INPUT_RAM_1_we   => BRAM_CTRL_INPUT_RAM_1_we,
        
        BRAM_CTRL_INPUT_RAM_2_addr => BRAM_CTRL_INPUT_RAM_2_addr,
        BRAM_CTRL_INPUT_RAM_2_clk  => BRAM_CTRL_INPUT_RAM_2_clk,
        BRAM_CTRL_INPUT_RAM_2_din  => BRAM_CTRL_INPUT_RAM_2_din,
        BRAM_CTRL_INPUT_RAM_2_dout => BRAM_CTRL_INPUT_RAM_2_dout,
        BRAM_CTRL_INPUT_RAM_2_en   => BRAM_CTRL_INPUT_RAM_2_en,
        BRAM_CTRL_INPUT_RAM_2_rst  => BRAM_CTRL_INPUT_RAM_2_rst,
        BRAM_CTRL_INPUT_RAM_2_we   => BRAM_CTRL_INPUT_RAM_2_we,
        
        BRAM_CTRL_OUTPUT_RAM_0_addr => BRAM_CTRL_OUTPUT_RAM_0_addr,
        BRAM_CTRL_OUTPUT_RAM_0_clk  => BRAM_CTRL_OUTPUT_RAM_0_clk,
        BRAM_CTRL_OUTPUT_RAM_0_din  => BRAM_CTRL_OUTPUT_RAM_0_din,
        BRAM_CTRL_OUTPUT_RAM_0_dout => BRAM_CTRL_OUTPUT_RAM_0_dout,
        BRAM_CTRL_OUTPUT_RAM_0_en   => BRAM_CTRL_OUTPUT_RAM_0_en,
        BRAM_CTRL_OUTPUT_RAM_0_rst  => BRAM_CTRL_OUTPUT_RAM_0_rst,
        BRAM_CTRL_OUTPUT_RAM_0_we   => BRAM_CTRL_OUTPUT_RAM_0_we,
 
        BRAM_CTRL_OUTPUT_RAM_1_addr => BRAM_CTRL_OUTPUT_RAM_1_addr,
        BRAM_CTRL_OUTPUT_RAM_1_clk  => BRAM_CTRL_OUTPUT_RAM_1_clk,
        BRAM_CTRL_OUTPUT_RAM_1_din  => BRAM_CTRL_OUTPUT_RAM_1_din,
        BRAM_CTRL_OUTPUT_RAM_1_dout => BRAM_CTRL_OUTPUT_RAM_1_dout,
        BRAM_CTRL_OUTPUT_RAM_1_en   => BRAM_CTRL_OUTPUT_RAM_1_en,
        BRAM_CTRL_OUTPUT_RAM_1_rst  => BRAM_CTRL_OUTPUT_RAM_1_rst,
        BRAM_CTRL_OUTPUT_RAM_1_we   => BRAM_CTRL_OUTPUT_RAM_1_we,        
        
        clk_50mhz  => s_clk_50,
        clk_240mhz => s_clk_240
      );
      
  i_register_file : entity work.register_file
        generic map(
          C_DATE_CODE      => C_DATE_CODE,
          C_GITHASH_CODE   => C_GITHASH_CODE,
          C_GIT_REPO_DIRTY => C_GIT_REPO_DIRTY
          )
        port map (
    
          LED_FP_o => s_led_FP,
   
          BRAM_CTRL_REG_FILE_addr => BRAM_CTRL_REG_FILE_addr,
          BRAM_CTRL_REG_FILE_clk  => BRAM_CTRL_REG_FILE_clk,
          BRAM_CTRL_REG_FILE_din  => BRAM_CTRL_REG_FILE_din,
          BRAM_CTRL_REG_FILE_dout => BRAM_CTRL_REG_FILE_dout,
          BRAM_CTRL_REG_FILE_en   => BRAM_CTRL_REG_FILE_en,
          BRAM_CTRL_REG_FILE_rst  => BRAM_CTRL_REG_FILE_rst,
          BRAM_CTRL_REG_FILE_we   => BRAM_CTRL_REG_FILE_we,
          
          pattern_start_o => s_pattern_start,
          cfg_reg_o  => s_cfg_reg

          );   
          
s_pattern_start_s1 <= s_pattern_start when rising_edge(s_clk_240);
s_pattern_start_s2 <= s_pattern_start_s1 when rising_edge(s_clk_240);

          
i_pattern_io_engine : entity work.pattern_io_engine 
    Port map( 
    
        clk_240_i => s_clk_240,
        
        pattern_restart_i  => s_pattern_start_s2,
        
        algo_rst_o  => ap_rst,
        algo_start_o  => ap_start,
        algo_done_i  => ap_done,
        
        INPUT_link_arr_o  => s_INPUT_link_arr,
        OUTPUT_link_arr_i => s_OUTPUT_link_arr,
        
        BRAM_CTRL_INPUT_RAM_0_addr => BRAM_CTRL_INPUT_RAM_0_addr,
        BRAM_CTRL_INPUT_RAM_0_clk  => BRAM_CTRL_INPUT_RAM_0_clk,
        BRAM_CTRL_INPUT_RAM_0_din  => BRAM_CTRL_INPUT_RAM_0_din,
        BRAM_CTRL_INPUT_RAM_0_dout => BRAM_CTRL_INPUT_RAM_0_dout,
        BRAM_CTRL_INPUT_RAM_0_en   => BRAM_CTRL_INPUT_RAM_0_en,
        BRAM_CTRL_INPUT_RAM_0_rst  => BRAM_CTRL_INPUT_RAM_0_rst,
        BRAM_CTRL_INPUT_RAM_0_we   => BRAM_CTRL_INPUT_RAM_0_we,

        BRAM_CTRL_INPUT_RAM_1_addr => BRAM_CTRL_INPUT_RAM_1_addr,
        BRAM_CTRL_INPUT_RAM_1_clk  => BRAM_CTRL_INPUT_RAM_1_clk,
        BRAM_CTRL_INPUT_RAM_1_din  => BRAM_CTRL_INPUT_RAM_1_din,
        BRAM_CTRL_INPUT_RAM_1_dout => BRAM_CTRL_INPUT_RAM_1_dout,
        BRAM_CTRL_INPUT_RAM_1_en   => BRAM_CTRL_INPUT_RAM_1_en,
        BRAM_CTRL_INPUT_RAM_1_rst  => BRAM_CTRL_INPUT_RAM_1_rst,
        BRAM_CTRL_INPUT_RAM_1_we   => BRAM_CTRL_INPUT_RAM_1_we,
        
        BRAM_CTRL_INPUT_RAM_2_addr => BRAM_CTRL_INPUT_RAM_2_addr,
        BRAM_CTRL_INPUT_RAM_2_clk  => BRAM_CTRL_INPUT_RAM_2_clk,
        BRAM_CTRL_INPUT_RAM_2_din  => BRAM_CTRL_INPUT_RAM_2_din,
        BRAM_CTRL_INPUT_RAM_2_dout => BRAM_CTRL_INPUT_RAM_2_dout,
        BRAM_CTRL_INPUT_RAM_2_en   => BRAM_CTRL_INPUT_RAM_2_en,
        BRAM_CTRL_INPUT_RAM_2_rst  => BRAM_CTRL_INPUT_RAM_2_rst,
        BRAM_CTRL_INPUT_RAM_2_we   => BRAM_CTRL_INPUT_RAM_2_we,
        
        BRAM_CTRL_OUTPUT_RAM_0_addr => BRAM_CTRL_OUTPUT_RAM_0_addr,
        BRAM_CTRL_OUTPUT_RAM_0_clk  => BRAM_CTRL_OUTPUT_RAM_0_clk,
        BRAM_CTRL_OUTPUT_RAM_0_din  => BRAM_CTRL_OUTPUT_RAM_0_din,
        BRAM_CTRL_OUTPUT_RAM_0_dout => BRAM_CTRL_OUTPUT_RAM_0_dout,
        BRAM_CTRL_OUTPUT_RAM_0_en   => BRAM_CTRL_OUTPUT_RAM_0_en,
        BRAM_CTRL_OUTPUT_RAM_0_rst  => BRAM_CTRL_OUTPUT_RAM_0_rst,
        BRAM_CTRL_OUTPUT_RAM_0_we   => BRAM_CTRL_OUTPUT_RAM_0_we,
 
        BRAM_CTRL_OUTPUT_RAM_1_addr => BRAM_CTRL_OUTPUT_RAM_1_addr,
        BRAM_CTRL_OUTPUT_RAM_1_clk  => BRAM_CTRL_OUTPUT_RAM_1_clk,
        BRAM_CTRL_OUTPUT_RAM_1_din  => BRAM_CTRL_OUTPUT_RAM_1_din,
        BRAM_CTRL_OUTPUT_RAM_1_dout => BRAM_CTRL_OUTPUT_RAM_1_dout,
        BRAM_CTRL_OUTPUT_RAM_1_en   => BRAM_CTRL_OUTPUT_RAM_1_en,
        BRAM_CTRL_OUTPUT_RAM_1_rst  => BRAM_CTRL_OUTPUT_RAM_1_rst,
        BRAM_CTRL_OUTPUT_RAM_1_we   => BRAM_CTRL_OUTPUT_RAM_1_we
     );          
     
     ap_clk <= s_clk_240; 
     
     i_ila_hls : ila_hls
     PORT MAP (
         clk => s_clk_240,     
         probe0(0) => ap_rst, 
         probe1(0) => ap_rst, 
         probe2(0) => ap_start, 
         probe3(0) => ap_done, 
         probe4(0) => ap_idle, 
         probe5(0) => ap_ready, 
         probe6 => s_INPUT_link_arr(0),
         probe7 => s_OUTPUT_link_arr(0)
     );
     
-----------------------------------------------------------------------------
-- Begin User_Code
-----------------------------------------------------------------------------
     
   getClusterTrackLinker_0 : getClusterTrackLinker_0
       PORT MAP (
         ap_clk => ap_clk,
         ap_rst => ap_rst,
         ap_start => ap_start,
         ap_done => ap_done,
         ap_idle => ap_idle,
         ap_ready => ap_ready,

peakEta_0_0 => peakEta_0_0,
peakEta_0_1 => peakEta_0_1,
peakEta_0_2 => peakEta_0_2,
peakEta_0_3 => peakEta_0_3,
peakEta_1_0 => peakEta_1_0,
peakEta_1_1 => peakEta_1_1,
peakEta_1_2 => peakEta_1_2,
peakEta_1_3 => peakEta_1_3,
peakEta_2_0 => peakEta_2_0,
peakEta_2_1 => peakEta_2_1,
peakEta_2_2 => peakEta_2_2,
peakEta_2_3 => peakEta_2_3,
peakEta_3_0 => peakEta_3_0,
peakEta_3_1 => peakEta_3_1,
peakEta_3_2 => peakEta_3_2,
peakEta_3_3 => peakEta_3_3,
peakEta_4_0 => peakEta_4_0,
peakEta_4_1 => peakEta_4_1,
peakEta_4_2 => peakEta_4_2,
peakEta_4_3 => peakEta_4_3,
peakEta_5_0 => peakEta_5_0,
peakEta_5_1 => peakEta_5_1,
peakEta_5_2 => peakEta_5_2,
peakEta_5_3 => peakEta_5_3,
peakEta_6_0 => peakEta_6_0,
peakEta_6_1 => peakEta_6_1,
peakEta_6_2 => peakEta_6_2,
peakEta_6_3 => peakEta_6_3,
peakEta_7_0 => peakEta_7_0,
peakEta_7_1 => peakEta_7_1,
peakEta_7_2 => peakEta_7_2,
peakEta_7_3 => peakEta_7_3,
peakEta_8_0 => peakEta_8_0,
peakEta_8_1 => peakEta_8_1,
peakEta_8_2 => peakEta_8_2,
peakEta_8_3 => peakEta_8_3,
peakEta_9_0 => peakEta_9_0,
peakEta_9_1 => peakEta_9_1,
peakEta_9_2 => peakEta_9_2,
peakEta_9_3 => peakEta_9_3,
peakEta_10_0 => peakEta_10_0,
peakEta_10_1 => peakEta_10_1,
peakEta_10_2 => peakEta_10_2,
peakEta_10_3 => peakEta_10_3,
peakEta_11_0 => peakEta_11_0,
peakEta_11_1 => peakEta_11_1,
peakEta_11_2 => peakEta_11_2,
peakEta_11_3 => peakEta_11_3,
peakEta_12_0 => peakEta_12_0,
peakEta_12_1 => peakEta_12_1,
peakEta_12_2 => peakEta_12_2,
peakEta_12_3 => peakEta_12_3,
peakEta_13_0 => peakEta_13_0,
peakEta_13_1 => peakEta_13_1,
peakEta_13_2 => peakEta_13_2,
peakEta_13_3 => peakEta_13_3,
peakEta_14_0 => peakEta_14_0,
peakEta_14_1 => peakEta_14_1,
peakEta_14_2 => peakEta_14_2,
peakEta_14_3 => peakEta_14_3,
peakEta_15_0 => peakEta_15_0,
peakEta_15_1 => peakEta_15_1,
peakEta_15_2 => peakEta_15_2,
peakEta_15_3 => peakEta_15_3,
peakEta_16_0 => peakEta_16_0,
peakEta_16_1 => peakEta_16_1,
peakEta_16_2 => peakEta_16_2,
peakEta_16_3 => peakEta_16_3,

peakPhi_0_0 => peakPhi_0_0,
peakPhi_0_1 => peakPhi_0_1,
peakPhi_0_2 => peakPhi_0_2,
peakPhi_0_3 => peakPhi_0_3,
peakPhi_1_0 => peakPhi_1_0,
peakPhi_1_1 => peakPhi_1_1,
peakPhi_1_2 => peakPhi_1_2,
peakPhi_1_3 => peakPhi_1_3,
peakPhi_2_0 => peakPhi_2_0,
peakPhi_2_1 => peakPhi_2_1,
peakPhi_2_2 => peakPhi_2_2,
peakPhi_2_3 => peakPhi_2_3,
peakPhi_3_0 => peakPhi_3_0,
peakPhi_3_1 => peakPhi_3_1,
peakPhi_3_2 => peakPhi_3_2,
peakPhi_3_3 => peakPhi_3_3,
peakPhi_4_0 => peakPhi_4_0,
peakPhi_4_1 => peakPhi_4_1,
peakPhi_4_2 => peakPhi_4_2,
peakPhi_4_3 => peakPhi_4_3,
peakPhi_5_0 => peakPhi_5_0,
peakPhi_5_1 => peakPhi_5_1,
peakPhi_5_2 => peakPhi_5_2,
peakPhi_5_3 => peakPhi_5_3,
peakPhi_6_0 => peakPhi_6_0,
peakPhi_6_1 => peakPhi_6_1,
peakPhi_6_2 => peakPhi_6_2,
peakPhi_6_3 => peakPhi_6_3,
peakPhi_7_0 => peakPhi_7_0,
peakPhi_7_1 => peakPhi_7_1,
peakPhi_7_2 => peakPhi_7_2,
peakPhi_7_3 => peakPhi_7_3,
peakPhi_8_0 => peakPhi_8_0,
peakPhi_8_1 => peakPhi_8_1,
peakPhi_8_2 => peakPhi_8_2,
peakPhi_8_3 => peakPhi_8_3,
peakPhi_9_0 => peakPhi_9_0,
peakPhi_9_1 => peakPhi_9_1,
peakPhi_9_2 => peakPhi_9_2,
peakPhi_9_3 => peakPhi_9_3,
peakPhi_10_0 => peakPhi_10_0,
peakPhi_10_1 => peakPhi_10_1,
peakPhi_10_2 => peakPhi_10_2,
peakPhi_10_3 => peakPhi_10_3,
peakPhi_11_0 => peakPhi_11_0,
peakPhi_11_1 => peakPhi_11_1,
peakPhi_11_2 => peakPhi_11_2,
peakPhi_11_3 => peakPhi_11_3,
peakPhi_12_0 => peakPhi_12_0,
peakPhi_12_1 => peakPhi_12_1,
peakPhi_12_2 => peakPhi_12_2,
peakPhi_12_3 => peakPhi_12_3,
peakPhi_13_0 => peakPhi_13_0,
peakPhi_13_1 => peakPhi_13_1,
peakPhi_13_2 => peakPhi_13_2,
peakPhi_13_3 => peakPhi_13_3,
peakPhi_14_0 => peakPhi_14_0,
peakPhi_14_1 => peakPhi_14_1,
peakPhi_14_2 => peakPhi_14_2,
peakPhi_14_3 => peakPhi_14_3,
peakPhi_15_0 => peakPhi_15_0,
peakPhi_15_1 => peakPhi_15_1,
peakPhi_15_2 => peakPhi_15_2,
peakPhi_15_3 => peakPhi_15_3,
peakPhi_16_0 => peakPhi_16_0,
peakPhi_16_1 => peakPhi_16_1,
peakPhi_16_2 => peakPhi_16_2,
peakPhi_16_3 => peakPhi_16_3,

smallClusterET_0_0 => smallClusterET_0_0,
smallClusterET_0_1 => smallClusterET_0_1,
smallClusterET_0_2 => smallClusterET_0_2,
smallClusterET_0_3 => smallClusterET_0_3,
smallClusterET_1_0 => smallClusterET_1_0,
smallClusterET_1_1 => smallClusterET_1_1,
smallClusterET_1_2 => smallClusterET_1_2,
smallClusterET_1_3 => smallClusterET_1_3,
smallClusterET_2_0 => smallClusterET_2_0,
smallClusterET_2_1 => smallClusterET_2_1,
smallClusterET_2_2 => smallClusterET_2_2,
smallClusterET_2_3 => smallClusterET_2_3,
smallClusterET_3_0 => smallClusterET_3_0,
smallClusterET_3_1 => smallClusterET_3_1,
smallClusterET_3_2 => smallClusterET_3_2,
smallClusterET_3_3 => smallClusterET_3_3,
smallClusterET_4_0 => smallClusterET_4_0,
smallClusterET_4_1 => smallClusterET_4_1,
smallClusterET_4_2 => smallClusterET_4_2,
smallClusterET_4_3 => smallClusterET_4_3,
smallClusterET_5_0 => smallClusterET_5_0,
smallClusterET_5_1 => smallClusterET_5_1,
smallClusterET_5_2 => smallClusterET_5_2,
smallClusterET_5_3 => smallClusterET_5_3,
smallClusterET_6_0 => smallClusterET_6_0,
smallClusterET_6_1 => smallClusterET_6_1,
smallClusterET_6_2 => smallClusterET_6_2,
smallClusterET_6_3 => smallClusterET_6_3,
smallClusterET_7_0 => smallClusterET_7_0,
smallClusterET_7_1 => smallClusterET_7_1,
smallClusterET_7_2 => smallClusterET_7_2,
smallClusterET_7_3 => smallClusterET_7_3,
smallClusterET_8_0 => smallClusterET_8_0,
smallClusterET_8_1 => smallClusterET_8_1,
smallClusterET_8_2 => smallClusterET_8_2,
smallClusterET_8_3 => smallClusterET_8_3,
smallClusterET_9_0 => smallClusterET_9_0,
smallClusterET_9_1 => smallClusterET_9_1,
smallClusterET_9_2 => smallClusterET_9_2,
smallClusterET_9_3 => smallClusterET_9_3,
smallClusterET_10_0 => smallClusterET_10_0,
smallClusterET_10_1 => smallClusterET_10_1,
smallClusterET_10_2 => smallClusterET_10_2,
smallClusterET_10_3 => smallClusterET_10_3,
smallClusterET_11_0 => smallClusterET_11_0,
smallClusterET_11_1 => smallClusterET_11_1,
smallClusterET_11_2 => smallClusterET_11_2,
smallClusterET_11_3 => smallClusterET_11_3,
smallClusterET_12_0 => smallClusterET_12_0,
smallClusterET_12_1 => smallClusterET_12_1,
smallClusterET_12_2 => smallClusterET_12_2,
smallClusterET_12_3 => smallClusterET_12_3,
smallClusterET_13_0 => smallClusterET_13_0,
smallClusterET_13_1 => smallClusterET_13_1,
smallClusterET_13_2 => smallClusterET_13_2,
smallClusterET_13_3 => smallClusterET_13_3,
smallClusterET_14_0 => smallClusterET_14_0,
smallClusterET_14_1 => smallClusterET_14_1,
smallClusterET_14_2 => smallClusterET_14_2,
smallClusterET_14_3 => smallClusterET_14_3,
smallClusterET_15_0 => smallClusterET_15_0,
smallClusterET_15_1 => smallClusterET_15_1,
smallClusterET_15_2 => smallClusterET_15_2,
smallClusterET_15_3 => smallClusterET_15_3,
smallClusterET_16_0 => smallClusterET_16_0,
smallClusterET_16_1 => smallClusterET_16_1,
smallClusterET_16_2 => smallClusterET_16_2,
smallClusterET_16_3 => smallClusterET_16_3,

trackPT_0 => trackPT_0,
trackPT_1 => trackPT_1,
trackPT_2 => trackPT_2,
trackPT_3 => trackPT_3,
trackPT_4 => trackPT_4,
trackPT_5 => trackPT_5,
trackPT_6 => trackPT_6,
trackPT_7 => trackPT_7,
trackPT_8 => trackPT_8,
trackPT_9 => trackPT_9,
trackPT_10 => trackPT_10,
trackPT_11 => trackPT_11,
trackPT_12 => trackPT_12,
trackPT_13 => trackPT_13,
trackPT_14 => trackPT_14,
trackPT_15 => trackPT_15,
trackPT_16 => trackPT_16,
trackPT_17 => trackPT_17,
trackPT_18 => trackPT_18,
trackPT_19 => trackPT_19,

trackEta_0 => trackEta_0,
trackEta_1 => trackEta_1,
trackEta_2 => trackEta_2,
trackEta_3 => trackEta_3,
trackEta_4 => trackEta_4,
trackEta_5 => trackEta_5,
trackEta_6 => trackEta_6,
trackEta_7 => trackEta_7,
trackEta_8 => trackEta_8,
trackEta_9 => trackEta_9,
trackEta_10 => trackEta_10,
trackEta_11 => trackEta_11,
trackEta_12 => trackEta_12,
trackEta_13 => trackEta_13,
trackEta_14 => trackEta_14,
trackEta_15 => trackEta_15,
trackEta_16 => trackEta_16,
trackEta_17 => trackEta_17,
trackEta_18 => trackEta_18,
trackEta_19 => trackEta_19,

trackPhi_0 => trackPhi_0,
trackPhi_1 => trackPhi_1,
trackPhi_2 => trackPhi_2,
trackPhi_3 => trackPhi_3,
trackPhi_4 => trackPhi_4,
trackPhi_5 => trackPhi_5,
trackPhi_6 => trackPhi_6,
trackPhi_7 => trackPhi_7,
trackPhi_8 => trackPhi_8,
trackPhi_9 => trackPhi_9,
trackPhi_10 => trackPhi_10,
trackPhi_11 => trackPhi_11,
trackPhi_12 => trackPhi_12,
trackPhi_13 => trackPhi_13,
trackPhi_14 => trackPhi_14,
trackPhi_15 => trackPhi_15,
trackPhi_16 => trackPhi_16,
trackPhi_17 => trackPhi_17,
trackPhi_18 => trackPhi_18,
trackPhi_19 => trackPhi_19,

linkedTrackPT_0 => linkedTrackPT_0,
linkedTrackPT_1 => linkedTrackPT_1,
linkedTrackPT_2 => linkedTrackPT_2,
linkedTrackPT_3 => linkedTrackPT_3,
linkedTrackPT_4 => linkedTrackPT_4,
linkedTrackPT_5 => linkedTrackPT_5,
linkedTrackPT_6 => linkedTrackPT_6,
linkedTrackPT_7 => linkedTrackPT_7,
linkedTrackPT_8 => linkedTrackPT_8,
linkedTrackPT_9 => linkedTrackPT_9,
linkedTrackPT_10 => linkedTrackPT_10,
linkedTrackPT_11 => linkedTrackPT_11,
linkedTrackPT_12 => linkedTrackPT_12,
linkedTrackPT_13 => linkedTrackPT_13,
linkedTrackPT_14 => linkedTrackPT_14,
linkedTrackPT_15 => linkedTrackPT_15,
linkedTrackPT_16 => linkedTrackPT_16,
linkedTrackPT_17 => linkedTrackPT_17,
linkedTrackPT_18 => linkedTrackPT_18,
linkedTrackPT_19 => linkedTrackPT_19,

linkedTrackEta_0 => linkedTrackEta_0,
linkedTrackEta_1 => linkedTrackEta_1,
linkedTrackEta_2 => linkedTrackEta_2,
linkedTrackEta_3 => linkedTrackEta_3,
linkedTrackEta_4 => linkedTrackEta_4,
linkedTrackEta_5 => linkedTrackEta_5,
linkedTrackEta_6 => linkedTrackEta_6,
linkedTrackEta_7 => linkedTrackEta_7,
linkedTrackEta_8 => linkedTrackEta_8,
linkedTrackEta_9 => linkedTrackEta_9,
linkedTrackEta_10 => linkedTrackEta_10,
linkedTrackEta_11 => linkedTrackEta_11,
linkedTrackEta_12 => linkedTrackEta_12,
linkedTrackEta_13 => linkedTrackEta_13,
linkedTrackEta_14 => linkedTrackEta_14,
linkedTrackEta_15 => linkedTrackEta_15,
linkedTrackEta_16 => linkedTrackEta_16,
linkedTrackEta_17 => linkedTrackEta_17,
linkedTrackEta_18 => linkedTrackEta_18,
linkedTrackEta_19 => linkedTrackEta_19,

linkedTrackPhi_0 => linkedTrackPhi_0,
linkedTrackPhi_1 => linkedTrackPhi_1,
linkedTrackPhi_2 => linkedTrackPhi_2,
linkedTrackPhi_3 => linkedTrackPhi_3,
linkedTrackPhi_4 => linkedTrackPhi_4,
linkedTrackPhi_5 => linkedTrackPhi_5,
linkedTrackPhi_6 => linkedTrackPhi_6,
linkedTrackPhi_7 => linkedTrackPhi_7,
linkedTrackPhi_8 => linkedTrackPhi_8,
linkedTrackPhi_9 => linkedTrackPhi_9,
linkedTrackPhi_10 => linkedTrackPhi_10,
linkedTrackPhi_11 => linkedTrackPhi_11,
linkedTrackPhi_12 => linkedTrackPhi_12,
linkedTrackPhi_13 => linkedTrackPhi_13,
linkedTrackPhi_14 => linkedTrackPhi_14,
linkedTrackPhi_15 => linkedTrackPhi_15,
linkedTrackPhi_16 => linkedTrackPhi_16,
linkedTrackPhi_17 => linkedTrackPhi_17,
linkedTrackPhi_18 => linkedTrackPhi_18,
linkedTrackPhi_19 => linkedTrackPhi_19,

linkedTrackQuality_0 => linkedTrackQuality_0,
linkedTrackQuality_1 => linkedTrackQuality_1,
linkedTrackQuality_2 => linkedTrackQuality_2,
linkedTrackQuality_3 => linkedTrackQuality_3,
linkedTrackQuality_4 => linkedTrackQuality_4,
linkedTrackQuality_5 => linkedTrackQuality_5,
linkedTrackQuality_6 => linkedTrackQuality_6,
linkedTrackQuality_7 => linkedTrackQuality_7,
linkedTrackQuality_8 => linkedTrackQuality_8,
linkedTrackQuality_9 => linkedTrackQuality_9,
linkedTrackQuality_10 => linkedTrackQuality_10,
linkedTrackQuality_11 => linkedTrackQuality_11,
linkedTrackQuality_12 => linkedTrackQuality_12,
linkedTrackQuality_13 => linkedTrackQuality_13,
linkedTrackQuality_14 => linkedTrackQuality_14,
linkedTrackQuality_15 => linkedTrackQuality_15,
linkedTrackQuality_16 => linkedTrackQuality_16,
linkedTrackQuality_17 => linkedTrackQuality_17,
linkedTrackQuality_18 => linkedTrackQuality_18,
linkedTrackQuality_19 => linkedTrackQuality_19,

neutralClusterET_0 => neutralClusterET_0,
neutralClusterET_1 => neutralClusterET_1,
neutralClusterET_2 => neutralClusterET_2,
neutralClusterET_3 => neutralClusterET_3,
neutralClusterET_4 => neutralClusterET_4,
neutralClusterET_5 => neutralClusterET_5,
neutralClusterET_6 => neutralClusterET_6,
neutralClusterET_7 => neutralClusterET_7,
neutralClusterET_8 => neutralClusterET_8,
neutralClusterET_9 => neutralClusterET_9,
neutralClusterET_10 => neutralClusterET_10,
neutralClusterET_11 => neutralClusterET_11,
neutralClusterET_12 => neutralClusterET_12,
neutralClusterET_13 => neutralClusterET_13,
neutralClusterET_14 => neutralClusterET_14,
neutralClusterET_15 => neutralClusterET_15,
neutralClusterET_16 => neutralClusterET_16,
neutralClusterET_17 => neutralClusterET_17,
neutralClusterET_18 => neutralClusterET_18,
neutralClusterET_19 => neutralClusterET_19,
neutralClusterET_20 => neutralClusterET_20,
neutralClusterET_21 => neutralClusterET_21,
neutralClusterET_22 => neutralClusterET_22,
neutralClusterET_23 => neutralClusterET_23,
neutralClusterET_24 => neutralClusterET_24,
neutralClusterET_25 => neutralClusterET_25,
neutralClusterET_26 => neutralClusterET_26,
neutralClusterET_27 => neutralClusterET_27,
neutralClusterET_28 => neutralClusterET_28,
neutralClusterET_29 => neutralClusterET_29,
neutralClusterET_30 => neutralClusterET_30,
neutralClusterET_31 => neutralClusterET_31,
neutralClusterET_32 => neutralClusterET_32,
neutralClusterET_33 => neutralClusterET_33,
neutralClusterET_34 => neutralClusterET_34,
neutralClusterET_35 => neutralClusterET_35,
neutralClusterET_36 => neutralClusterET_36,
neutralClusterET_37 => neutralClusterET_37,
neutralClusterET_38 => neutralClusterET_38,
neutralClusterET_39 => neutralClusterET_39,
neutralClusterET_40 => neutralClusterET_40,
neutralClusterET_41 => neutralClusterET_41,
neutralClusterET_42 => neutralClusterET_42,
neutralClusterET_43 => neutralClusterET_43,
neutralClusterET_44 => neutralClusterET_44,
neutralClusterET_45 => neutralClusterET_45,
neutralClusterET_46 => neutralClusterET_46,
neutralClusterET_47 => neutralClusterET_47,
neutralClusterET_48 => neutralClusterET_48,
neutralClusterET_49 => neutralClusterET_49,
neutralClusterET_50 => neutralClusterET_50,
neutralClusterET_51 => neutralClusterET_51,
neutralClusterET_52 => neutralClusterET_52,
neutralClusterET_53 => neutralClusterET_53,
neutralClusterET_54 => neutralClusterET_54,
neutralClusterET_55 => neutralClusterET_55,
neutralClusterET_56 => neutralClusterET_56,
neutralClusterET_57 => neutralClusterET_57,
neutralClusterET_58 => neutralClusterET_58,
neutralClusterET_59 => neutralClusterET_59,
neutralClusterET_60 => neutralClusterET_60,
neutralClusterET_61 => neutralClusterET_61,
neutralClusterET_62 => neutralClusterET_62,
neutralClusterET_63 => neutralClusterET_63,
neutralClusterET_64 => neutralClusterET_64,
neutralClusterET_65 => neutralClusterET_65,
neutralClusterET_66 => neutralClusterET_66,
neutralClusterET_67 => neutralClusterET_67,

neutralClusterEta_0 => neutralClusterEta_0,
neutralClusterEta_1 => neutralClusterEta_1,
neutralClusterEta_2 => neutralClusterEta_2,
neutralClusterEta_3 => neutralClusterEta_3,
neutralClusterEta_4 => neutralClusterEta_4,
neutralClusterEta_5 => neutralClusterEta_5,
neutralClusterEta_6 => neutralClusterEta_6,
neutralClusterEta_7 => neutralClusterEta_7,
neutralClusterEta_8 => neutralClusterEta_8,
neutralClusterEta_9 => neutralClusterEta_9,
neutralClusterEta_10 => neutralClusterEta_10,
neutralClusterEta_11 => neutralClusterEta_11,
neutralClusterEta_12 => neutralClusterEta_12,
neutralClusterEta_13 => neutralClusterEta_13,
neutralClusterEta_14 => neutralClusterEta_14,
neutralClusterEta_15 => neutralClusterEta_15,
neutralClusterEta_16 => neutralClusterEta_16,
neutralClusterEta_17 => neutralClusterEta_17,
neutralClusterEta_18 => neutralClusterEta_18,
neutralClusterEta_19 => neutralClusterEta_19,
neutralClusterEta_20 => neutralClusterEta_20,
neutralClusterEta_21 => neutralClusterEta_21,
neutralClusterEta_22 => neutralClusterEta_22,
neutralClusterEta_23 => neutralClusterEta_23,
neutralClusterEta_24 => neutralClusterEta_24,
neutralClusterEta_25 => neutralClusterEta_25,
neutralClusterEta_26 => neutralClusterEta_26,
neutralClusterEta_27 => neutralClusterEta_27,
neutralClusterEta_28 => neutralClusterEta_28,
neutralClusterEta_29 => neutralClusterEta_29,
neutralClusterEta_30 => neutralClusterEta_30,
neutralClusterEta_31 => neutralClusterEta_31,
neutralClusterEta_32 => neutralClusterEta_32,
neutralClusterEta_33 => neutralClusterEta_33,
neutralClusterEta_34 => neutralClusterEta_34,
neutralClusterEta_35 => neutralClusterEta_35,
neutralClusterEta_36 => neutralClusterEta_36,
neutralClusterEta_37 => neutralClusterEta_37,
neutralClusterEta_38 => neutralClusterEta_38,
neutralClusterEta_39 => neutralClusterEta_39,
neutralClusterEta_40 => neutralClusterEta_40,
neutralClusterEta_41 => neutralClusterEta_41,
neutralClusterEta_42 => neutralClusterEta_42,
neutralClusterEta_43 => neutralClusterEta_43,
neutralClusterEta_44 => neutralClusterEta_44,
neutralClusterEta_45 => neutralClusterEta_45,
neutralClusterEta_46 => neutralClusterEta_46,
neutralClusterEta_47 => neutralClusterEta_47,
neutralClusterEta_48 => neutralClusterEta_48,
neutralClusterEta_49 => neutralClusterEta_49,
neutralClusterEta_50 => neutralClusterEta_50,
neutralClusterEta_51 => neutralClusterEta_51,
neutralClusterEta_52 => neutralClusterEta_52,
neutralClusterEta_53 => neutralClusterEta_53,
neutralClusterEta_54 => neutralClusterEta_54,
neutralClusterEta_55 => neutralClusterEta_55,
neutralClusterEta_56 => neutralClusterEta_56,
neutralClusterEta_57 => neutralClusterEta_57,
neutralClusterEta_58 => neutralClusterEta_58,
neutralClusterEta_59 => neutralClusterEta_59,
neutralClusterEta_60 => neutralClusterEta_60,
neutralClusterEta_61 => neutralClusterEta_61,
neutralClusterEta_62 => neutralClusterEta_62,
neutralClusterEta_63 => neutralClusterEta_63,
neutralClusterEta_64 => neutralClusterEta_64,
neutralClusterEta_65 => neutralClusterEta_65,
neutralClusterEta_66 => neutralClusterEta_66,
neutralClusterEta_67 => neutralClusterEta_67,

neutralClusterPhi_0 => neutralClusterPhi_0,
neutralClusterPhi_1 => neutralClusterPhi_1,
neutralClusterPhi_2 => neutralClusterPhi_2,
neutralClusterPhi_3 => neutralClusterPhi_3,
neutralClusterPhi_4 => neutralClusterPhi_4,
neutralClusterPhi_5 => neutralClusterPhi_5,
neutralClusterPhi_6 => neutralClusterPhi_6,
neutralClusterPhi_7 => neutralClusterPhi_7,
neutralClusterPhi_8 => neutralClusterPhi_8,
neutralClusterPhi_9 => neutralClusterPhi_9,
neutralClusterPhi_10 => neutralClusterPhi_10,
neutralClusterPhi_11 => neutralClusterPhi_11,
neutralClusterPhi_12 => neutralClusterPhi_12,
neutralClusterPhi_13 => neutralClusterPhi_13,
neutralClusterPhi_14 => neutralClusterPhi_14,
neutralClusterPhi_15 => neutralClusterPhi_15,
neutralClusterPhi_16 => neutralClusterPhi_16,
neutralClusterPhi_17 => neutralClusterPhi_17,
neutralClusterPhi_18 => neutralClusterPhi_18,
neutralClusterPhi_19 => neutralClusterPhi_19,
neutralClusterPhi_20 => neutralClusterPhi_20,
neutralClusterPhi_21 => neutralClusterPhi_21,
neutralClusterPhi_22 => neutralClusterPhi_22,
neutralClusterPhi_23 => neutralClusterPhi_23,
neutralClusterPhi_24 => neutralClusterPhi_24,
neutralClusterPhi_25 => neutralClusterPhi_25,
neutralClusterPhi_26 => neutralClusterPhi_26,
neutralClusterPhi_27 => neutralClusterPhi_27,
neutralClusterPhi_28 => neutralClusterPhi_28,
neutralClusterPhi_29 => neutralClusterPhi_29,
neutralClusterPhi_30 => neutralClusterPhi_30,
neutralClusterPhi_31 => neutralClusterPhi_31,
neutralClusterPhi_32 => neutralClusterPhi_32,
neutralClusterPhi_33 => neutralClusterPhi_33,
neutralClusterPhi_34 => neutralClusterPhi_34,
neutralClusterPhi_35 => neutralClusterPhi_35,
neutralClusterPhi_36 => neutralClusterPhi_36,
neutralClusterPhi_37 => neutralClusterPhi_37,
neutralClusterPhi_38 => neutralClusterPhi_38,
neutralClusterPhi_39 => neutralClusterPhi_39,
neutralClusterPhi_40 => neutralClusterPhi_40,
neutralClusterPhi_41 => neutralClusterPhi_41,
neutralClusterPhi_42 => neutralClusterPhi_42,
neutralClusterPhi_43 => neutralClusterPhi_43,
neutralClusterPhi_44 => neutralClusterPhi_44,
neutralClusterPhi_45 => neutralClusterPhi_45,
neutralClusterPhi_46 => neutralClusterPhi_46,
neutralClusterPhi_47 => neutralClusterPhi_47,
neutralClusterPhi_48 => neutralClusterPhi_48,
neutralClusterPhi_49 => neutralClusterPhi_49,
neutralClusterPhi_50 => neutralClusterPhi_50,
neutralClusterPhi_51 => neutralClusterPhi_51,
neutralClusterPhi_52 => neutralClusterPhi_52,
neutralClusterPhi_53 => neutralClusterPhi_53,
neutralClusterPhi_54 => neutralClusterPhi_54,
neutralClusterPhi_55 => neutralClusterPhi_55,
neutralClusterPhi_56 => neutralClusterPhi_56,
neutralClusterPhi_57 => neutralClusterPhi_57,
neutralClusterPhi_58 => neutralClusterPhi_58,
neutralClusterPhi_59 => neutralClusterPhi_59,
neutralClusterPhi_60 => neutralClusterPhi_60,
neutralClusterPhi_61 => neutralClusterPhi_61,
neutralClusterPhi_62 => neutralClusterPhi_62,
neutralClusterPhi_63 => neutralClusterPhi_63,
neutralClusterPhi_64 => neutralClusterPhi_64,
neutralClusterPhi_65 => neutralClusterPhi_65,
neutralClusterPhi_66 => neutralClusterPhi_66,
neutralClusterPhi_67 => neutralClusterPhi_67 
       );

-----------------------------------------------------------------------------
-- Configuration registers              
   
-----------------------------------------------------------------------------

-- Input Links
peakEta_0_0 <= s_INPUT_LINK_ARR( 0 )(15 downto 0);
peakEta_0_1 <= s_INPUT_LINK_ARR( 0 )(31 downto 16);
peakEta_0_2 <= s_INPUT_LINK_ARR( 0 )(47 downto 32);
peakEta_0_3 <= s_INPUT_LINK_ARR( 0 )(63 downto 48);
peakEta_1_0 <= s_INPUT_LINK_ARR( 0 )(79 downto 64);
peakEta_1_1 <= s_INPUT_LINK_ARR( 0 )(95 downto 80);
peakEta_1_2 <= s_INPUT_LINK_ARR( 0 )(111 downto 96);
peakEta_1_3 <= s_INPUT_LINK_ARR( 0 )(127 downto 112);
peakEta_2_0 <= s_INPUT_LINK_ARR( 0 )(143 downto 128);
peakEta_2_1 <= s_INPUT_LINK_ARR( 0 )(159 downto 144);
peakEta_2_2 <= s_INPUT_LINK_ARR( 0 )(175 downto 160);
peakEta_2_3 <= s_INPUT_LINK_ARR( 0 )(191 downto 176);
peakEta_3_0 <= s_INPUT_LINK_ARR( 1 )(15 downto 0);
peakEta_3_1 <= s_INPUT_LINK_ARR( 1 )(31 downto 16);
peakEta_3_2 <= s_INPUT_LINK_ARR( 1 )(47 downto 32);
peakEta_3_3 <= s_INPUT_LINK_ARR( 1 )(63 downto 48);
peakEta_4_0 <= s_INPUT_LINK_ARR( 1 )(79 downto 64);
peakEta_4_1 <= s_INPUT_LINK_ARR( 1 )(95 downto 80);
peakEta_4_2 <= s_INPUT_LINK_ARR( 1 )(111 downto 96);
peakEta_4_3 <= s_INPUT_LINK_ARR( 1 )(127 downto 112);
peakEta_5_0 <= s_INPUT_LINK_ARR( 1 )(143 downto 128);
peakEta_5_1 <= s_INPUT_LINK_ARR( 1 )(159 downto 144);
peakEta_5_2 <= s_INPUT_LINK_ARR( 1 )(175 downto 160);
peakEta_5_3 <= s_INPUT_LINK_ARR( 1 )(191 downto 176);
peakEta_6_0 <= s_INPUT_LINK_ARR( 2 )(15 downto 0);
peakEta_6_1 <= s_INPUT_LINK_ARR( 2 )(31 downto 16);
peakEta_6_2 <= s_INPUT_LINK_ARR( 2 )(47 downto 32);
peakEta_6_3 <= s_INPUT_LINK_ARR( 2 )(63 downto 48);
peakEta_7_0 <= s_INPUT_LINK_ARR( 2 )(79 downto 64);
peakEta_7_1 <= s_INPUT_LINK_ARR( 2 )(95 downto 80);
peakEta_7_2 <= s_INPUT_LINK_ARR( 2 )(111 downto 96);
peakEta_7_3 <= s_INPUT_LINK_ARR( 2 )(127 downto 112);
peakEta_8_0 <= s_INPUT_LINK_ARR( 2 )(143 downto 128);
peakEta_8_1 <= s_INPUT_LINK_ARR( 2 )(159 downto 144);
peakEta_8_2 <= s_INPUT_LINK_ARR( 2 )(175 downto 160);
peakEta_8_3 <= s_INPUT_LINK_ARR( 2 )(191 downto 176);
peakEta_9_0 <= s_INPUT_LINK_ARR( 3 )(15 downto 0);
peakEta_9_1 <= s_INPUT_LINK_ARR( 3 )(31 downto 16);
peakEta_9_2 <= s_INPUT_LINK_ARR( 3 )(47 downto 32);
peakEta_9_3 <= s_INPUT_LINK_ARR( 3 )(63 downto 48);
peakEta_10_0 <= s_INPUT_LINK_ARR( 3 )(79 downto 64);
peakEta_10_1 <= s_INPUT_LINK_ARR( 3 )(95 downto 80);
peakEta_10_2 <= s_INPUT_LINK_ARR( 3 )(111 downto 96);
peakEta_10_3 <= s_INPUT_LINK_ARR( 3 )(127 downto 112);
peakEta_11_0 <= s_INPUT_LINK_ARR( 3 )(143 downto 128);
peakEta_11_1 <= s_INPUT_LINK_ARR( 3 )(159 downto 144);
peakEta_11_2 <= s_INPUT_LINK_ARR( 3 )(175 downto 160);
peakEta_11_3 <= s_INPUT_LINK_ARR( 3 )(191 downto 176);
peakEta_12_0 <= s_INPUT_LINK_ARR( 4 )(15 downto 0);
peakEta_12_1 <= s_INPUT_LINK_ARR( 4 )(31 downto 16);
peakEta_12_2 <= s_INPUT_LINK_ARR( 4 )(47 downto 32);
peakEta_12_3 <= s_INPUT_LINK_ARR( 4 )(63 downto 48);
peakEta_13_0 <= s_INPUT_LINK_ARR( 4 )(79 downto 64);
peakEta_13_1 <= s_INPUT_LINK_ARR( 4 )(95 downto 80);
peakEta_13_2 <= s_INPUT_LINK_ARR( 4 )(111 downto 96);
peakEta_13_3 <= s_INPUT_LINK_ARR( 4 )(127 downto 112);
peakEta_14_0 <= s_INPUT_LINK_ARR( 4 )(143 downto 128);
peakEta_14_1 <= s_INPUT_LINK_ARR( 4 )(159 downto 144);
peakEta_14_2 <= s_INPUT_LINK_ARR( 4 )(175 downto 160);
peakEta_14_3 <= s_INPUT_LINK_ARR( 4 )(191 downto 176);
peakEta_15_0 <= s_INPUT_LINK_ARR( 5 )(15 downto 0);
peakEta_15_1 <= s_INPUT_LINK_ARR( 5 )(31 downto 16);
peakEta_15_2 <= s_INPUT_LINK_ARR( 5 )(47 downto 32);
peakEta_15_3 <= s_INPUT_LINK_ARR( 5 )(63 downto 48);
peakEta_16_0 <= s_INPUT_LINK_ARR( 5 )(79 downto 64);
peakEta_16_1 <= s_INPUT_LINK_ARR( 5 )(95 downto 80);
peakEta_16_2 <= s_INPUT_LINK_ARR( 5 )(111 downto 96);
peakEta_16_3 <= s_INPUT_LINK_ARR( 5 )(127 downto 112);

peakPhi_0_0 <= s_INPUT_LINK_ARR( 5 )(143 downto 128);
peakPhi_0_1 <= s_INPUT_LINK_ARR( 5 )(159 downto 144);
peakPhi_0_2 <= s_INPUT_LINK_ARR( 5 )(175 downto 160);
peakPhi_0_3 <= s_INPUT_LINK_ARR( 5 )(191 downto 176);
peakPhi_1_0 <= s_INPUT_LINK_ARR( 6 )(15 downto 0);
peakPhi_1_1 <= s_INPUT_LINK_ARR( 6 )(31 downto 16);
peakPhi_1_2 <= s_INPUT_LINK_ARR( 6 )(47 downto 32);
peakPhi_1_3 <= s_INPUT_LINK_ARR( 6 )(63 downto 48);
peakPhi_2_0 <= s_INPUT_LINK_ARR( 6 )(79 downto 64);
peakPhi_2_1 <= s_INPUT_LINK_ARR( 6 )(95 downto 80);
peakPhi_2_2 <= s_INPUT_LINK_ARR( 6 )(111 downto 96);
peakPhi_2_3 <= s_INPUT_LINK_ARR( 6 )(127 downto 112);
peakPhi_3_0 <= s_INPUT_LINK_ARR( 6 )(143 downto 128);
peakPhi_3_1 <= s_INPUT_LINK_ARR( 6 )(159 downto 144);
peakPhi_3_2 <= s_INPUT_LINK_ARR( 6 )(175 downto 160);
peakPhi_3_3 <= s_INPUT_LINK_ARR( 6 )(191 downto 176);
peakPhi_4_0 <= s_INPUT_LINK_ARR( 7 )(15 downto 0);
peakPhi_4_1 <= s_INPUT_LINK_ARR( 7 )(31 downto 16);
peakPhi_4_2 <= s_INPUT_LINK_ARR( 7 )(47 downto 32);
peakPhi_4_3 <= s_INPUT_LINK_ARR( 7 )(63 downto 48);
peakPhi_5_0 <= s_INPUT_LINK_ARR( 7 )(79 downto 64);
peakPhi_5_1 <= s_INPUT_LINK_ARR( 7 )(95 downto 80);
peakPhi_5_2 <= s_INPUT_LINK_ARR( 7 )(111 downto 96);
peakPhi_5_3 <= s_INPUT_LINK_ARR( 7 )(127 downto 112);
peakPhi_6_0 <= s_INPUT_LINK_ARR( 7 )(143 downto 128);
peakPhi_6_1 <= s_INPUT_LINK_ARR( 7 )(159 downto 144);
peakPhi_6_2 <= s_INPUT_LINK_ARR( 7 )(175 downto 160);
peakPhi_6_3 <= s_INPUT_LINK_ARR( 7 )(191 downto 176);
peakPhi_7_0 <= s_INPUT_LINK_ARR( 8 )(15 downto 0);
peakPhi_7_1 <= s_INPUT_LINK_ARR( 8 )(31 downto 16);
peakPhi_7_2 <= s_INPUT_LINK_ARR( 8 )(47 downto 32);
peakPhi_7_3 <= s_INPUT_LINK_ARR( 8 )(63 downto 48);
peakPhi_8_0 <= s_INPUT_LINK_ARR( 8 )(79 downto 64);
peakPhi_8_1 <= s_INPUT_LINK_ARR( 8 )(95 downto 80);
peakPhi_8_2 <= s_INPUT_LINK_ARR( 8 )(111 downto 96);
peakPhi_8_3 <= s_INPUT_LINK_ARR( 8 )(127 downto 112);
peakPhi_9_0 <= s_INPUT_LINK_ARR( 8 )(143 downto 128);
peakPhi_9_1 <= s_INPUT_LINK_ARR( 8 )(159 downto 144);
peakPhi_9_2 <= s_INPUT_LINK_ARR( 8 )(175 downto 160);
peakPhi_9_3 <= s_INPUT_LINK_ARR( 8 )(191 downto 176);
peakPhi_10_0 <= s_INPUT_LINK_ARR( 9 )(15 downto 0);
peakPhi_10_1 <= s_INPUT_LINK_ARR( 9 )(31 downto 16);
peakPhi_10_2 <= s_INPUT_LINK_ARR( 9 )(47 downto 32);
peakPhi_10_3 <= s_INPUT_LINK_ARR( 9 )(63 downto 48);
peakPhi_11_0 <= s_INPUT_LINK_ARR( 9 )(79 downto 64);
peakPhi_11_1 <= s_INPUT_LINK_ARR( 9 )(95 downto 80);
peakPhi_11_2 <= s_INPUT_LINK_ARR( 9 )(111 downto 96);
peakPhi_11_3 <= s_INPUT_LINK_ARR( 9 )(127 downto 112);
peakPhi_12_0 <= s_INPUT_LINK_ARR( 9 )(143 downto 128);
peakPhi_12_1 <= s_INPUT_LINK_ARR( 9 )(159 downto 144);
peakPhi_12_2 <= s_INPUT_LINK_ARR( 9 )(175 downto 160);
peakPhi_12_3 <= s_INPUT_LINK_ARR( 9 )(191 downto 176);
peakPhi_13_0 <= s_INPUT_LINK_ARR( 10 )(15 downto 0);
peakPhi_13_1 <= s_INPUT_LINK_ARR( 10 )(31 downto 16);
peakPhi_13_2 <= s_INPUT_LINK_ARR( 10 )(47 downto 32);
peakPhi_13_3 <= s_INPUT_LINK_ARR( 10 )(63 downto 48);
peakPhi_14_0 <= s_INPUT_LINK_ARR( 10 )(79 downto 64);
peakPhi_14_1 <= s_INPUT_LINK_ARR( 10 )(95 downto 80);
peakPhi_14_2 <= s_INPUT_LINK_ARR( 10 )(111 downto 96);
peakPhi_14_3 <= s_INPUT_LINK_ARR( 10 )(127 downto 112);
peakPhi_15_0 <= s_INPUT_LINK_ARR( 10 )(143 downto 128);
peakPhi_15_1 <= s_INPUT_LINK_ARR( 10 )(159 downto 144);
peakPhi_15_2 <= s_INPUT_LINK_ARR( 10 )(175 downto 160);
peakPhi_15_3 <= s_INPUT_LINK_ARR( 10 )(191 downto 176);
peakPhi_16_0 <= s_INPUT_LINK_ARR( 11 )(15 downto 0);
peakPhi_16_1 <= s_INPUT_LINK_ARR( 11 )(31 downto 16);
peakPhi_16_2 <= s_INPUT_LINK_ARR( 11 )(47 downto 32);
peakPhi_16_3 <= s_INPUT_LINK_ARR( 11 )(63 downto 48);

smallClusterET_0_0 <= s_INPUT_LINK_ARR( 11 )(79 downto 64);
smallClusterET_0_1 <= s_INPUT_LINK_ARR( 11 )(95 downto 80);
smallClusterET_0_2 <= s_INPUT_LINK_ARR( 11 )(111 downto 96);
smallClusterET_0_3 <= s_INPUT_LINK_ARR( 11 )(127 downto 112);
smallClusterET_1_0 <= s_INPUT_LINK_ARR( 11 )(143 downto 128);
smallClusterET_1_1 <= s_INPUT_LINK_ARR( 11 )(159 downto 144);
smallClusterET_1_2 <= s_INPUT_LINK_ARR( 11 )(175 downto 160);
smallClusterET_1_3 <= s_INPUT_LINK_ARR( 11 )(191 downto 176);
smallClusterET_2_0 <= s_INPUT_LINK_ARR( 12 )(15 downto 0);
smallClusterET_2_1 <= s_INPUT_LINK_ARR( 12 )(31 downto 16);
smallClusterET_2_2 <= s_INPUT_LINK_ARR( 12 )(47 downto 32);
smallClusterET_2_3 <= s_INPUT_LINK_ARR( 12 )(63 downto 48);
smallClusterET_3_0 <= s_INPUT_LINK_ARR( 12 )(79 downto 64);
smallClusterET_3_1 <= s_INPUT_LINK_ARR( 12 )(95 downto 80);
smallClusterET_3_2 <= s_INPUT_LINK_ARR( 12 )(111 downto 96);
smallClusterET_3_3 <= s_INPUT_LINK_ARR( 12 )(127 downto 112);
smallClusterET_4_0 <= s_INPUT_LINK_ARR( 12 )(143 downto 128);
smallClusterET_4_1 <= s_INPUT_LINK_ARR( 12 )(159 downto 144);
smallClusterET_4_2 <= s_INPUT_LINK_ARR( 12 )(175 downto 160);
smallClusterET_4_3 <= s_INPUT_LINK_ARR( 12 )(191 downto 176);
smallClusterET_5_0 <= s_INPUT_LINK_ARR( 13 )(15 downto 0);
smallClusterET_5_1 <= s_INPUT_LINK_ARR( 13 )(31 downto 16);
smallClusterET_5_2 <= s_INPUT_LINK_ARR( 13 )(47 downto 32);
smallClusterET_5_3 <= s_INPUT_LINK_ARR( 13 )(63 downto 48);
smallClusterET_6_0 <= s_INPUT_LINK_ARR( 13 )(79 downto 64);
smallClusterET_6_1 <= s_INPUT_LINK_ARR( 13 )(95 downto 80);
smallClusterET_6_2 <= s_INPUT_LINK_ARR( 13 )(111 downto 96);
smallClusterET_6_3 <= s_INPUT_LINK_ARR( 13 )(127 downto 112);
smallClusterET_7_0 <= s_INPUT_LINK_ARR( 13 )(143 downto 128);
smallClusterET_7_1 <= s_INPUT_LINK_ARR( 13 )(159 downto 144);
smallClusterET_7_2 <= s_INPUT_LINK_ARR( 13 )(175 downto 160);
smallClusterET_7_3 <= s_INPUT_LINK_ARR( 13 )(191 downto 176);
smallClusterET_8_0 <= s_INPUT_LINK_ARR( 14 )(15 downto 0);
smallClusterET_8_1 <= s_INPUT_LINK_ARR( 14 )(31 downto 16);
smallClusterET_8_2 <= s_INPUT_LINK_ARR( 14 )(47 downto 32);
smallClusterET_8_3 <= s_INPUT_LINK_ARR( 14 )(63 downto 48);
smallClusterET_9_0 <= s_INPUT_LINK_ARR( 14 )(79 downto 64);
smallClusterET_9_1 <= s_INPUT_LINK_ARR( 14 )(95 downto 80);
smallClusterET_9_2 <= s_INPUT_LINK_ARR( 14 )(111 downto 96);
smallClusterET_9_3 <= s_INPUT_LINK_ARR( 14 )(127 downto 112);
smallClusterET_10_0 <= s_INPUT_LINK_ARR( 14 )(143 downto 128);
smallClusterET_10_1 <= s_INPUT_LINK_ARR( 14 )(159 downto 144);
smallClusterET_10_2 <= s_INPUT_LINK_ARR( 14 )(175 downto 160);
smallClusterET_10_3 <= s_INPUT_LINK_ARR( 14 )(191 downto 176);
smallClusterET_11_0 <= s_INPUT_LINK_ARR( 15 )(15 downto 0);
smallClusterET_11_1 <= s_INPUT_LINK_ARR( 15 )(31 downto 16);
smallClusterET_11_2 <= s_INPUT_LINK_ARR( 15 )(47 downto 32);
smallClusterET_11_3 <= s_INPUT_LINK_ARR( 15 )(63 downto 48);
smallClusterET_12_0 <= s_INPUT_LINK_ARR( 15 )(79 downto 64);
smallClusterET_12_1 <= s_INPUT_LINK_ARR( 15 )(95 downto 80);
smallClusterET_12_2 <= s_INPUT_LINK_ARR( 15 )(111 downto 96);
smallClusterET_12_3 <= s_INPUT_LINK_ARR( 15 )(127 downto 112);
smallClusterET_13_0 <= s_INPUT_LINK_ARR( 15 )(143 downto 128);
smallClusterET_13_1 <= s_INPUT_LINK_ARR( 15 )(159 downto 144);
smallClusterET_13_2 <= s_INPUT_LINK_ARR( 15 )(175 downto 160);
smallClusterET_13_3 <= s_INPUT_LINK_ARR( 15 )(191 downto 176);
smallClusterET_14_0 <= s_INPUT_LINK_ARR( 16 )(15 downto 0);
smallClusterET_14_1 <= s_INPUT_LINK_ARR( 16 )(31 downto 16);
smallClusterET_14_2 <= s_INPUT_LINK_ARR( 16 )(47 downto 32);
smallClusterET_14_3 <= s_INPUT_LINK_ARR( 16 )(63 downto 48);
smallClusterET_15_0 <= s_INPUT_LINK_ARR( 16 )(79 downto 64);
smallClusterET_15_1 <= s_INPUT_LINK_ARR( 16 )(95 downto 80);
smallClusterET_15_2 <= s_INPUT_LINK_ARR( 16 )(111 downto 96);
smallClusterET_15_3 <= s_INPUT_LINK_ARR( 16 )(127 downto 112);
smallClusterET_16_0 <= s_INPUT_LINK_ARR( 16 )(143 downto 128);
smallClusterET_16_1 <= s_INPUT_LINK_ARR( 16 )(159 downto 144);
smallClusterET_16_2 <= s_INPUT_LINK_ARR( 16 )(175 downto 160);
smallClusterET_16_3 <= s_INPUT_LINK_ARR( 16 )(191 downto 176);

trackPT_0 <= s_INPUT_LINK_ARR( 17 )(15 downto 0);
trackPT_1 <= s_INPUT_LINK_ARR( 17 )(31 downto 16);
trackPT_2 <= s_INPUT_LINK_ARR( 17 )(47 downto 32);
trackPT_3 <= s_INPUT_LINK_ARR( 17 )(63 downto 48);
trackPT_4 <= s_INPUT_LINK_ARR( 17 )(79 downto 64);
trackPT_5 <= s_INPUT_LINK_ARR( 17 )(95 downto 80);
trackPT_6 <= s_INPUT_LINK_ARR( 17 )(111 downto 96);
trackPT_7 <= s_INPUT_LINK_ARR( 17 )(127 downto 112);
trackPT_8 <= s_INPUT_LINK_ARR( 17 )(143 downto 128);
trackPT_9 <= s_INPUT_LINK_ARR( 17 )(159 downto 144);
trackPT_10 <= s_INPUT_LINK_ARR( 17 )(175 downto 160);
trackPT_11 <= s_INPUT_LINK_ARR( 17 )(191 downto 176);
trackPT_12 <= s_INPUT_LINK_ARR( 18 )(15 downto 0);
trackPT_13 <= s_INPUT_LINK_ARR( 18 )(31 downto 16);
trackPT_14 <= s_INPUT_LINK_ARR( 18 )(47 downto 32);
trackPT_15 <= s_INPUT_LINK_ARR( 18 )(63 downto 48);
trackPT_16 <= s_INPUT_LINK_ARR( 18 )(79 downto 64);
trackPT_17 <= s_INPUT_LINK_ARR( 18 )(95 downto 80);
trackPT_18 <= s_INPUT_LINK_ARR( 18 )(111 downto 96);
trackPT_19 <= s_INPUT_LINK_ARR( 18 )(127 downto 112);

trackEta_0 <= s_INPUT_LINK_ARR( 18 )(143 downto 128);
trackEta_1 <= s_INPUT_LINK_ARR( 18 )(159 downto 144);
trackEta_2 <= s_INPUT_LINK_ARR( 18 )(175 downto 160);
trackEta_3 <= s_INPUT_LINK_ARR( 18 )(191 downto 176);
trackEta_4 <= s_INPUT_LINK_ARR( 19 )(15 downto 0);
trackEta_5 <= s_INPUT_LINK_ARR( 19 )(31 downto 16);
trackEta_6 <= s_INPUT_LINK_ARR( 19 )(47 downto 32);
trackEta_7 <= s_INPUT_LINK_ARR( 19 )(63 downto 48);
trackEta_8 <= s_INPUT_LINK_ARR( 19 )(79 downto 64);
trackEta_9 <= s_INPUT_LINK_ARR( 19 )(95 downto 80);
trackEta_10 <= s_INPUT_LINK_ARR( 19 )(111 downto 96);
trackEta_11 <= s_INPUT_LINK_ARR( 19 )(127 downto 112);
trackEta_12 <= s_INPUT_LINK_ARR( 19 )(143 downto 128);
trackEta_13 <= s_INPUT_LINK_ARR( 19 )(159 downto 144);
trackEta_14 <= s_INPUT_LINK_ARR( 19 )(175 downto 160);
trackEta_15 <= s_INPUT_LINK_ARR( 19 )(191 downto 176);
trackEta_16 <= s_INPUT_LINK_ARR( 20 )(15 downto 0);
trackEta_17 <= s_INPUT_LINK_ARR( 20 )(31 downto 16);
trackEta_18 <= s_INPUT_LINK_ARR( 20 )(47 downto 32);
trackEta_19 <= s_INPUT_LINK_ARR( 20 )(63 downto 48);

trackPhi_0 <= s_INPUT_LINK_ARR( 20 )(79 downto 64);
trackPhi_1 <= s_INPUT_LINK_ARR( 20 )(95 downto 80);
trackPhi_2 <= s_INPUT_LINK_ARR( 20 )(111 downto 96);
trackPhi_3 <= s_INPUT_LINK_ARR( 20 )(127 downto 112);
trackPhi_4 <= s_INPUT_LINK_ARR( 20 )(143 downto 128);
trackPhi_5 <= s_INPUT_LINK_ARR( 20 )(159 downto 144);
trackPhi_6 <= s_INPUT_LINK_ARR( 20 )(175 downto 160);
trackPhi_7 <= s_INPUT_LINK_ARR( 20 )(191 downto 176);
trackPhi_8 <= s_INPUT_LINK_ARR( 21 )(15 downto 0);
trackPhi_9 <= s_INPUT_LINK_ARR( 21 )(31 downto 16);
trackPhi_10 <= s_INPUT_LINK_ARR( 21 )(47 downto 32);
trackPhi_11 <= s_INPUT_LINK_ARR( 21 )(63 downto 48);
trackPhi_12 <= s_INPUT_LINK_ARR( 21 )(79 downto 64);
trackPhi_13 <= s_INPUT_LINK_ARR( 21 )(95 downto 80);
trackPhi_14 <= s_INPUT_LINK_ARR( 21 )(111 downto 96);
trackPhi_15 <= s_INPUT_LINK_ARR( 21 )(127 downto 112);
trackPhi_16 <= s_INPUT_LINK_ARR( 21 )(143 downto 128);
trackPhi_17 <= s_INPUT_LINK_ARR( 21 )(159 downto 144);
trackPhi_18 <= s_INPUT_LINK_ARR( 21 )(175 downto 160);
trackPhi_19 <= s_INPUT_LINK_ARR( 21 )(191 downto 176);


-----------------------------------------------------------------------------
 
-- Output Links   
s_OUTPUT_LINK_ARR( 0 )(15 downto 0) <= linkedTrackPT_0 ;
s_OUTPUT_LINK_ARR( 0 )(31 downto 16) <= linkedTrackPT_1 ;
s_OUTPUT_LINK_ARR( 0 )(47 downto 32) <= linkedTrackPT_2 ;
s_OUTPUT_LINK_ARR( 0 )(63 downto 48) <= linkedTrackPT_3 ;
s_OUTPUT_LINK_ARR( 0 )(79 downto 64) <= linkedTrackPT_4 ;
s_OUTPUT_LINK_ARR( 0 )(95 downto 80) <= linkedTrackPT_5 ;
s_OUTPUT_LINK_ARR( 0 )(111 downto 96) <= linkedTrackPT_6 ;
s_OUTPUT_LINK_ARR( 0 )(127 downto 112) <= linkedTrackPT_7 ;
s_OUTPUT_LINK_ARR( 0 )(143 downto 128) <= linkedTrackPT_8 ;
s_OUTPUT_LINK_ARR( 0 )(159 downto 144) <= linkedTrackPT_9 ;
s_OUTPUT_LINK_ARR( 0 )(175 downto 160) <= linkedTrackPT_10 ;
s_OUTPUT_LINK_ARR( 0 )(191 downto 176) <= linkedTrackPT_11 ;
s_OUTPUT_LINK_ARR( 1 )(15 downto 0) <= linkedTrackPT_12 ;
s_OUTPUT_LINK_ARR( 1 )(31 downto 16) <= linkedTrackPT_13 ;
s_OUTPUT_LINK_ARR( 1 )(47 downto 32) <= linkedTrackPT_14 ;
s_OUTPUT_LINK_ARR( 1 )(63 downto 48) <= linkedTrackPT_15 ;
s_OUTPUT_LINK_ARR( 1 )(79 downto 64) <= linkedTrackPT_16 ;
s_OUTPUT_LINK_ARR( 1 )(95 downto 80) <= linkedTrackPT_17 ;
s_OUTPUT_LINK_ARR( 1 )(111 downto 96) <= linkedTrackPT_18 ;
s_OUTPUT_LINK_ARR( 1 )(127 downto 112) <= linkedTrackPT_19 ;

s_OUTPUT_LINK_ARR( 1 )(143 downto 128) <= linkedTrackEta_0 ;
s_OUTPUT_LINK_ARR( 1 )(159 downto 144) <= linkedTrackEta_1 ;
s_OUTPUT_LINK_ARR( 1 )(175 downto 160) <= linkedTrackEta_2 ;
s_OUTPUT_LINK_ARR( 1 )(191 downto 176) <= linkedTrackEta_3 ;
s_OUTPUT_LINK_ARR( 2 )(15 downto 0) <= linkedTrackEta_4 ;
s_OUTPUT_LINK_ARR( 2 )(31 downto 16) <= linkedTrackEta_5 ;
s_OUTPUT_LINK_ARR( 2 )(47 downto 32) <= linkedTrackEta_6 ;
s_OUTPUT_LINK_ARR( 2 )(63 downto 48) <= linkedTrackEta_7 ;
s_OUTPUT_LINK_ARR( 2 )(79 downto 64) <= linkedTrackEta_8 ;
s_OUTPUT_LINK_ARR( 2 )(95 downto 80) <= linkedTrackEta_9 ;
s_OUTPUT_LINK_ARR( 2 )(111 downto 96) <= linkedTrackEta_10 ;
s_OUTPUT_LINK_ARR( 2 )(127 downto 112) <= linkedTrackEta_11 ;
s_OUTPUT_LINK_ARR( 2 )(143 downto 128) <= linkedTrackEta_12 ;
s_OUTPUT_LINK_ARR( 2 )(159 downto 144) <= linkedTrackEta_13 ;
s_OUTPUT_LINK_ARR( 2 )(175 downto 160) <= linkedTrackEta_14 ;
s_OUTPUT_LINK_ARR( 2 )(191 downto 176) <= linkedTrackEta_15 ;
s_OUTPUT_LINK_ARR( 3 )(15 downto 0) <= linkedTrackEta_16 ;
s_OUTPUT_LINK_ARR( 3 )(31 downto 16) <= linkedTrackEta_17 ;
s_OUTPUT_LINK_ARR( 3 )(47 downto 32) <= linkedTrackEta_18 ;
s_OUTPUT_LINK_ARR( 3 )(63 downto 48) <= linkedTrackEta_19 ;

s_OUTPUT_LINK_ARR( 3 )(79 downto 64) <= linkedTrackPhi_0 ;
s_OUTPUT_LINK_ARR( 3 )(95 downto 80) <= linkedTrackPhi_1 ;
s_OUTPUT_LINK_ARR( 3 )(111 downto 96) <= linkedTrackPhi_2 ;
s_OUTPUT_LINK_ARR( 3 )(127 downto 112) <= linkedTrackPhi_3 ;
s_OUTPUT_LINK_ARR( 3 )(143 downto 128) <= linkedTrackPhi_4 ;
s_OUTPUT_LINK_ARR( 3 )(159 downto 144) <= linkedTrackPhi_5 ;
s_OUTPUT_LINK_ARR( 3 )(175 downto 160) <= linkedTrackPhi_6 ;
s_OUTPUT_LINK_ARR( 3 )(191 downto 176) <= linkedTrackPhi_7 ;
s_OUTPUT_LINK_ARR( 4 )(15 downto 0) <= linkedTrackPhi_8 ;
s_OUTPUT_LINK_ARR( 4 )(31 downto 16) <= linkedTrackPhi_9 ;
s_OUTPUT_LINK_ARR( 4 )(47 downto 32) <= linkedTrackPhi_10 ;
s_OUTPUT_LINK_ARR( 4 )(63 downto 48) <= linkedTrackPhi_11 ;
s_OUTPUT_LINK_ARR( 4 )(79 downto 64) <= linkedTrackPhi_12 ;
s_OUTPUT_LINK_ARR( 4 )(95 downto 80) <= linkedTrackPhi_13 ;
s_OUTPUT_LINK_ARR( 4 )(111 downto 96) <= linkedTrackPhi_14 ;
s_OUTPUT_LINK_ARR( 4 )(127 downto 112) <= linkedTrackPhi_15 ;
s_OUTPUT_LINK_ARR( 4 )(143 downto 128) <= linkedTrackPhi_16 ;
s_OUTPUT_LINK_ARR( 4 )(159 downto 144) <= linkedTrackPhi_17 ;
s_OUTPUT_LINK_ARR( 4 )(175 downto 160) <= linkedTrackPhi_18 ;
s_OUTPUT_LINK_ARR( 4 )(191 downto 176) <= linkedTrackPhi_19 ;

s_OUTPUT_LINK_ARR( 5 )(15 downto 0) <= linkedTrackQuality_0 ;
s_OUTPUT_LINK_ARR( 5 )(31 downto 16) <= linkedTrackQuality_1 ;
s_OUTPUT_LINK_ARR( 5 )(47 downto 32) <= linkedTrackQuality_2 ;
s_OUTPUT_LINK_ARR( 5 )(63 downto 48) <= linkedTrackQuality_3 ;
s_OUTPUT_LINK_ARR( 5 )(79 downto 64) <= linkedTrackQuality_4 ;
s_OUTPUT_LINK_ARR( 5 )(95 downto 80) <= linkedTrackQuality_5 ;
s_OUTPUT_LINK_ARR( 5 )(111 downto 96) <= linkedTrackQuality_6 ;
s_OUTPUT_LINK_ARR( 5 )(127 downto 112) <= linkedTrackQuality_7 ;
s_OUTPUT_LINK_ARR( 5 )(143 downto 128) <= linkedTrackQuality_8 ;
s_OUTPUT_LINK_ARR( 5 )(159 downto 144) <= linkedTrackQuality_9 ;
s_OUTPUT_LINK_ARR( 5 )(175 downto 160) <= linkedTrackQuality_10 ;
s_OUTPUT_LINK_ARR( 5 )(191 downto 176) <= linkedTrackQuality_11 ;
s_OUTPUT_LINK_ARR( 6 )(15 downto 0) <= linkedTrackQuality_12 ;
s_OUTPUT_LINK_ARR( 6 )(31 downto 16) <= linkedTrackQuality_13 ;
s_OUTPUT_LINK_ARR( 6 )(47 downto 32) <= linkedTrackQuality_14 ;
s_OUTPUT_LINK_ARR( 6 )(63 downto 48) <= linkedTrackQuality_15 ;
s_OUTPUT_LINK_ARR( 6 )(79 downto 64) <= linkedTrackQuality_16 ;
s_OUTPUT_LINK_ARR( 6 )(95 downto 80) <= linkedTrackQuality_17 ;
s_OUTPUT_LINK_ARR( 6 )(111 downto 96) <= linkedTrackQuality_18 ;
s_OUTPUT_LINK_ARR( 6 )(127 downto 112) <= linkedTrackQuality_19 ;

s_OUTPUT_LINK_ARR( 6 )(143 downto 128) <= neutralClusterET_0 ;
s_OUTPUT_LINK_ARR( 6 )(159 downto 144) <= neutralClusterET_1 ;
s_OUTPUT_LINK_ARR( 6 )(175 downto 160) <= neutralClusterET_2 ;
s_OUTPUT_LINK_ARR( 6 )(191 downto 176) <= neutralClusterET_3 ;
s_OUTPUT_LINK_ARR( 7 )(15 downto 0) <= neutralClusterET_4 ;
s_OUTPUT_LINK_ARR( 7 )(31 downto 16) <= neutralClusterET_5 ;
s_OUTPUT_LINK_ARR( 7 )(47 downto 32) <= neutralClusterET_6 ;
s_OUTPUT_LINK_ARR( 7 )(63 downto 48) <= neutralClusterET_7 ;
s_OUTPUT_LINK_ARR( 7 )(79 downto 64) <= neutralClusterET_8 ;
s_OUTPUT_LINK_ARR( 7 )(95 downto 80) <= neutralClusterET_9 ;
s_OUTPUT_LINK_ARR( 7 )(111 downto 96) <= neutralClusterET_10 ;
s_OUTPUT_LINK_ARR( 7 )(127 downto 112) <= neutralClusterET_11 ;
s_OUTPUT_LINK_ARR( 7 )(143 downto 128) <= neutralClusterET_12 ;
s_OUTPUT_LINK_ARR( 7 )(159 downto 144) <= neutralClusterET_13 ;
s_OUTPUT_LINK_ARR( 7 )(175 downto 160) <= neutralClusterET_14 ;
s_OUTPUT_LINK_ARR( 7 )(191 downto 176) <= neutralClusterET_15 ;
s_OUTPUT_LINK_ARR( 8 )(15 downto 0) <= neutralClusterET_16 ;
s_OUTPUT_LINK_ARR( 8 )(31 downto 16) <= neutralClusterET_17 ;
s_OUTPUT_LINK_ARR( 8 )(47 downto 32) <= neutralClusterET_18 ;
s_OUTPUT_LINK_ARR( 8 )(63 downto 48) <= neutralClusterET_19 ;
s_OUTPUT_LINK_ARR( 8 )(79 downto 64) <= neutralClusterET_20 ;
s_OUTPUT_LINK_ARR( 8 )(95 downto 80) <= neutralClusterET_21 ;
s_OUTPUT_LINK_ARR( 8 )(111 downto 96) <= neutralClusterET_22 ;
s_OUTPUT_LINK_ARR( 8 )(127 downto 112) <= neutralClusterET_23 ;
s_OUTPUT_LINK_ARR( 8 )(143 downto 128) <= neutralClusterET_24 ;
s_OUTPUT_LINK_ARR( 8 )(159 downto 144) <= neutralClusterET_25 ;
s_OUTPUT_LINK_ARR( 8 )(175 downto 160) <= neutralClusterET_26 ;
s_OUTPUT_LINK_ARR( 8 )(191 downto 176) <= neutralClusterET_27 ;
s_OUTPUT_LINK_ARR( 9 )(15 downto 0) <= neutralClusterET_28 ;
s_OUTPUT_LINK_ARR( 9 )(31 downto 16) <= neutralClusterET_29 ;
s_OUTPUT_LINK_ARR( 9 )(47 downto 32) <= neutralClusterET_30 ;
s_OUTPUT_LINK_ARR( 9 )(63 downto 48) <= neutralClusterET_31 ;
s_OUTPUT_LINK_ARR( 9 )(79 downto 64) <= neutralClusterET_32 ;
s_OUTPUT_LINK_ARR( 9 )(95 downto 80) <= neutralClusterET_33 ;
s_OUTPUT_LINK_ARR( 9 )(111 downto 96) <= neutralClusterET_34 ;
s_OUTPUT_LINK_ARR( 9 )(127 downto 112) <= neutralClusterET_35 ;
s_OUTPUT_LINK_ARR( 9 )(143 downto 128) <= neutralClusterET_36 ;
s_OUTPUT_LINK_ARR( 9 )(159 downto 144) <= neutralClusterET_37 ;
s_OUTPUT_LINK_ARR( 9 )(175 downto 160) <= neutralClusterET_38 ;
s_OUTPUT_LINK_ARR( 9 )(191 downto 176) <= neutralClusterET_39 ;
s_OUTPUT_LINK_ARR( 10 )(15 downto 0) <= neutralClusterET_40 ;
s_OUTPUT_LINK_ARR( 10 )(31 downto 16) <= neutralClusterET_41 ;
s_OUTPUT_LINK_ARR( 10 )(47 downto 32) <= neutralClusterET_42 ;
s_OUTPUT_LINK_ARR( 10 )(63 downto 48) <= neutralClusterET_43 ;
s_OUTPUT_LINK_ARR( 10 )(79 downto 64) <= neutralClusterET_44 ;
s_OUTPUT_LINK_ARR( 10 )(95 downto 80) <= neutralClusterET_45 ;
s_OUTPUT_LINK_ARR( 10 )(111 downto 96) <= neutralClusterET_46 ;
s_OUTPUT_LINK_ARR( 10 )(127 downto 112) <= neutralClusterET_47 ;
s_OUTPUT_LINK_ARR( 10 )(143 downto 128) <= neutralClusterET_48 ;
s_OUTPUT_LINK_ARR( 10 )(159 downto 144) <= neutralClusterET_49 ;
s_OUTPUT_LINK_ARR( 10 )(175 downto 160) <= neutralClusterET_50 ;
s_OUTPUT_LINK_ARR( 10 )(191 downto 176) <= neutralClusterET_51 ;
s_OUTPUT_LINK_ARR( 11 )(15 downto 0) <= neutralClusterET_52 ;
s_OUTPUT_LINK_ARR( 11 )(31 downto 16) <= neutralClusterET_53 ;
s_OUTPUT_LINK_ARR( 11 )(47 downto 32) <= neutralClusterET_54 ;
s_OUTPUT_LINK_ARR( 11 )(63 downto 48) <= neutralClusterET_55 ;
s_OUTPUT_LINK_ARR( 11 )(79 downto 64) <= neutralClusterET_56 ;
s_OUTPUT_LINK_ARR( 11 )(95 downto 80) <= neutralClusterET_57 ;
s_OUTPUT_LINK_ARR( 11 )(111 downto 96) <= neutralClusterET_58 ;
s_OUTPUT_LINK_ARR( 11 )(127 downto 112) <= neutralClusterET_59 ;
s_OUTPUT_LINK_ARR( 11 )(143 downto 128) <= neutralClusterET_60 ;
s_OUTPUT_LINK_ARR( 11 )(159 downto 144) <= neutralClusterET_61 ;
s_OUTPUT_LINK_ARR( 11 )(175 downto 160) <= neutralClusterET_62 ;
s_OUTPUT_LINK_ARR( 11 )(191 downto 176) <= neutralClusterET_63 ;
s_OUTPUT_LINK_ARR( 12 )(15 downto 0) <= neutralClusterET_64 ;
s_OUTPUT_LINK_ARR( 12 )(31 downto 16) <= neutralClusterET_65 ;
s_OUTPUT_LINK_ARR( 12 )(47 downto 32) <= neutralClusterET_66 ;
s_OUTPUT_LINK_ARR( 12 )(63 downto 48) <= neutralClusterET_67 ;

s_OUTPUT_LINK_ARR( 12 )(79 downto 64) <= neutralClusterEta_0 ;
s_OUTPUT_LINK_ARR( 12 )(95 downto 80) <= neutralClusterEta_1 ;
s_OUTPUT_LINK_ARR( 12 )(111 downto 96) <= neutralClusterEta_2 ;
s_OUTPUT_LINK_ARR( 12 )(127 downto 112) <= neutralClusterEta_3 ;
s_OUTPUT_LINK_ARR( 12 )(143 downto 128) <= neutralClusterEta_4 ;
s_OUTPUT_LINK_ARR( 12 )(159 downto 144) <= neutralClusterEta_5 ;
s_OUTPUT_LINK_ARR( 12 )(175 downto 160) <= neutralClusterEta_6 ;
s_OUTPUT_LINK_ARR( 12 )(191 downto 176) <= neutralClusterEta_7 ;
s_OUTPUT_LINK_ARR( 13 )(15 downto 0) <= neutralClusterEta_8 ;
s_OUTPUT_LINK_ARR( 13 )(31 downto 16) <= neutralClusterEta_9 ;
s_OUTPUT_LINK_ARR( 13 )(47 downto 32) <= neutralClusterEta_10 ;
s_OUTPUT_LINK_ARR( 13 )(63 downto 48) <= neutralClusterEta_11 ;
s_OUTPUT_LINK_ARR( 13 )(79 downto 64) <= neutralClusterEta_12 ;
s_OUTPUT_LINK_ARR( 13 )(95 downto 80) <= neutralClusterEta_13 ;
s_OUTPUT_LINK_ARR( 13 )(111 downto 96) <= neutralClusterEta_14 ;
s_OUTPUT_LINK_ARR( 13 )(127 downto 112) <= neutralClusterEta_15 ;
s_OUTPUT_LINK_ARR( 13 )(143 downto 128) <= neutralClusterEta_16 ;
s_OUTPUT_LINK_ARR( 13 )(159 downto 144) <= neutralClusterEta_17 ;
s_OUTPUT_LINK_ARR( 13 )(175 downto 160) <= neutralClusterEta_18 ;
s_OUTPUT_LINK_ARR( 13 )(191 downto 176) <= neutralClusterEta_19 ;
s_OUTPUT_LINK_ARR( 14 )(15 downto 0) <= neutralClusterEta_20 ;
s_OUTPUT_LINK_ARR( 14 )(31 downto 16) <= neutralClusterEta_21 ;
s_OUTPUT_LINK_ARR( 14 )(47 downto 32) <= neutralClusterEta_22 ;
s_OUTPUT_LINK_ARR( 14 )(63 downto 48) <= neutralClusterEta_23 ;
s_OUTPUT_LINK_ARR( 14 )(79 downto 64) <= neutralClusterEta_24 ;
s_OUTPUT_LINK_ARR( 14 )(95 downto 80) <= neutralClusterEta_25 ;
s_OUTPUT_LINK_ARR( 14 )(111 downto 96) <= neutralClusterEta_26 ;
s_OUTPUT_LINK_ARR( 14 )(127 downto 112) <= neutralClusterEta_27 ;
s_OUTPUT_LINK_ARR( 14 )(143 downto 128) <= neutralClusterEta_28 ;
s_OUTPUT_LINK_ARR( 14 )(159 downto 144) <= neutralClusterEta_29 ;
s_OUTPUT_LINK_ARR( 14 )(175 downto 160) <= neutralClusterEta_30 ;
s_OUTPUT_LINK_ARR( 14 )(191 downto 176) <= neutralClusterEta_31 ;
s_OUTPUT_LINK_ARR( 15 )(15 downto 0) <= neutralClusterEta_32 ;
s_OUTPUT_LINK_ARR( 15 )(31 downto 16) <= neutralClusterEta_33 ;
s_OUTPUT_LINK_ARR( 15 )(47 downto 32) <= neutralClusterEta_34 ;
s_OUTPUT_LINK_ARR( 15 )(63 downto 48) <= neutralClusterEta_35 ;
s_OUTPUT_LINK_ARR( 15 )(79 downto 64) <= neutralClusterEta_36 ;
s_OUTPUT_LINK_ARR( 15 )(95 downto 80) <= neutralClusterEta_37 ;
s_OUTPUT_LINK_ARR( 15 )(111 downto 96) <= neutralClusterEta_38 ;
s_OUTPUT_LINK_ARR( 15 )(127 downto 112) <= neutralClusterEta_39 ;
s_OUTPUT_LINK_ARR( 15 )(143 downto 128) <= neutralClusterEta_40 ;
s_OUTPUT_LINK_ARR( 15 )(159 downto 144) <= neutralClusterEta_41 ;
s_OUTPUT_LINK_ARR( 15 )(175 downto 160) <= neutralClusterEta_42 ;
s_OUTPUT_LINK_ARR( 15 )(191 downto 176) <= neutralClusterEta_43 ;
s_OUTPUT_LINK_ARR( 16 )(15 downto 0) <= neutralClusterEta_44 ;
s_OUTPUT_LINK_ARR( 16 )(31 downto 16) <= neutralClusterEta_45 ;
s_OUTPUT_LINK_ARR( 16 )(47 downto 32) <= neutralClusterEta_46 ;
s_OUTPUT_LINK_ARR( 16 )(63 downto 48) <= neutralClusterEta_47 ;
s_OUTPUT_LINK_ARR( 16 )(79 downto 64) <= neutralClusterEta_48 ;
s_OUTPUT_LINK_ARR( 16 )(95 downto 80) <= neutralClusterEta_49 ;
s_OUTPUT_LINK_ARR( 16 )(111 downto 96) <= neutralClusterEta_50 ;
s_OUTPUT_LINK_ARR( 16 )(127 downto 112) <= neutralClusterEta_51 ;
s_OUTPUT_LINK_ARR( 16 )(143 downto 128) <= neutralClusterEta_52 ;
s_OUTPUT_LINK_ARR( 16 )(159 downto 144) <= neutralClusterEta_53 ;
s_OUTPUT_LINK_ARR( 16 )(175 downto 160) <= neutralClusterEta_54 ;
s_OUTPUT_LINK_ARR( 16 )(191 downto 176) <= neutralClusterEta_55 ;
s_OUTPUT_LINK_ARR( 17 )(15 downto 0) <= neutralClusterEta_56 ;
s_OUTPUT_LINK_ARR( 17 )(31 downto 16) <= neutralClusterEta_57 ;
s_OUTPUT_LINK_ARR( 17 )(47 downto 32) <= neutralClusterEta_58 ;
s_OUTPUT_LINK_ARR( 17 )(63 downto 48) <= neutralClusterEta_59 ;
s_OUTPUT_LINK_ARR( 17 )(79 downto 64) <= neutralClusterEta_60 ;
s_OUTPUT_LINK_ARR( 17 )(95 downto 80) <= neutralClusterEta_61 ;
s_OUTPUT_LINK_ARR( 17 )(111 downto 96) <= neutralClusterEta_62 ;
s_OUTPUT_LINK_ARR( 17 )(127 downto 112) <= neutralClusterEta_63 ;
s_OUTPUT_LINK_ARR( 17 )(143 downto 128) <= neutralClusterEta_64 ;
s_OUTPUT_LINK_ARR( 17 )(159 downto 144) <= neutralClusterEta_65 ;
s_OUTPUT_LINK_ARR( 17 )(175 downto 160) <= neutralClusterEta_66 ;
s_OUTPUT_LINK_ARR( 17 )(191 downto 176) <= neutralClusterEta_67 ;

s_OUTPUT_LINK_ARR( 18 )(15 downto 0) <= neutralClusterPhi_0 ;
s_OUTPUT_LINK_ARR( 18 )(31 downto 16) <= neutralClusterPhi_1 ;
s_OUTPUT_LINK_ARR( 18 )(47 downto 32) <= neutralClusterPhi_2 ;
s_OUTPUT_LINK_ARR( 18 )(63 downto 48) <= neutralClusterPhi_3 ;
s_OUTPUT_LINK_ARR( 18 )(79 downto 64) <= neutralClusterPhi_4 ;
s_OUTPUT_LINK_ARR( 18 )(95 downto 80) <= neutralClusterPhi_5 ;
s_OUTPUT_LINK_ARR( 18 )(111 downto 96) <= neutralClusterPhi_6 ;
s_OUTPUT_LINK_ARR( 18 )(127 downto 112) <= neutralClusterPhi_7 ;
s_OUTPUT_LINK_ARR( 18 )(143 downto 128) <= neutralClusterPhi_8 ;
s_OUTPUT_LINK_ARR( 18 )(159 downto 144) <= neutralClusterPhi_9 ;
s_OUTPUT_LINK_ARR( 18 )(175 downto 160) <= neutralClusterPhi_10 ;
s_OUTPUT_LINK_ARR( 18 )(191 downto 176) <= neutralClusterPhi_11 ;
s_OUTPUT_LINK_ARR( 19 )(15 downto 0) <= neutralClusterPhi_12 ;
s_OUTPUT_LINK_ARR( 19 )(31 downto 16) <= neutralClusterPhi_13 ;
s_OUTPUT_LINK_ARR( 19 )(47 downto 32) <= neutralClusterPhi_14 ;
s_OUTPUT_LINK_ARR( 19 )(63 downto 48) <= neutralClusterPhi_15 ;
s_OUTPUT_LINK_ARR( 19 )(79 downto 64) <= neutralClusterPhi_16 ;
s_OUTPUT_LINK_ARR( 19 )(95 downto 80) <= neutralClusterPhi_17 ;
s_OUTPUT_LINK_ARR( 19 )(111 downto 96) <= neutralClusterPhi_18 ;
s_OUTPUT_LINK_ARR( 19 )(127 downto 112) <= neutralClusterPhi_19 ;
s_OUTPUT_LINK_ARR( 19 )(143 downto 128) <= neutralClusterPhi_20 ;
s_OUTPUT_LINK_ARR( 19 )(159 downto 144) <= neutralClusterPhi_21 ;
s_OUTPUT_LINK_ARR( 19 )(175 downto 160) <= neutralClusterPhi_22 ;
s_OUTPUT_LINK_ARR( 19 )(191 downto 176) <= neutralClusterPhi_23 ;
s_OUTPUT_LINK_ARR( 20 )(15 downto 0) <= neutralClusterPhi_24 ;
s_OUTPUT_LINK_ARR( 20 )(31 downto 16) <= neutralClusterPhi_25 ;
s_OUTPUT_LINK_ARR( 20 )(47 downto 32) <= neutralClusterPhi_26 ;
s_OUTPUT_LINK_ARR( 20 )(63 downto 48) <= neutralClusterPhi_27 ;
s_OUTPUT_LINK_ARR( 20 )(79 downto 64) <= neutralClusterPhi_28 ;
s_OUTPUT_LINK_ARR( 20 )(95 downto 80) <= neutralClusterPhi_29 ;
s_OUTPUT_LINK_ARR( 20 )(111 downto 96) <= neutralClusterPhi_30 ;
s_OUTPUT_LINK_ARR( 20 )(127 downto 112) <= neutralClusterPhi_31 ;
s_OUTPUT_LINK_ARR( 20 )(143 downto 128) <= neutralClusterPhi_32 ;
s_OUTPUT_LINK_ARR( 20 )(159 downto 144) <= neutralClusterPhi_33 ;
s_OUTPUT_LINK_ARR( 20 )(175 downto 160) <= neutralClusterPhi_34 ;
s_OUTPUT_LINK_ARR( 20 )(191 downto 176) <= neutralClusterPhi_35 ;
s_OUTPUT_LINK_ARR( 21 )(15 downto 0) <= neutralClusterPhi_36 ;
s_OUTPUT_LINK_ARR( 21 )(31 downto 16) <= neutralClusterPhi_37 ;
s_OUTPUT_LINK_ARR( 21 )(47 downto 32) <= neutralClusterPhi_38 ;
s_OUTPUT_LINK_ARR( 21 )(63 downto 48) <= neutralClusterPhi_39 ;
s_OUTPUT_LINK_ARR( 21 )(79 downto 64) <= neutralClusterPhi_40 ;
s_OUTPUT_LINK_ARR( 21 )(95 downto 80) <= neutralClusterPhi_41 ;
s_OUTPUT_LINK_ARR( 21 )(111 downto 96) <= neutralClusterPhi_42 ;
s_OUTPUT_LINK_ARR( 21 )(127 downto 112) <= neutralClusterPhi_43 ;
s_OUTPUT_LINK_ARR( 21 )(143 downto 128) <= neutralClusterPhi_44 ;
s_OUTPUT_LINK_ARR( 21 )(159 downto 144) <= neutralClusterPhi_45 ;
s_OUTPUT_LINK_ARR( 21 )(175 downto 160) <= neutralClusterPhi_46 ;
s_OUTPUT_LINK_ARR( 21 )(191 downto 176) <= neutralClusterPhi_47 ;
s_OUTPUT_LINK_ARR( 22 )(15 downto 0) <= neutralClusterPhi_48 ;
s_OUTPUT_LINK_ARR( 22 )(31 downto 16) <= neutralClusterPhi_49 ;
s_OUTPUT_LINK_ARR( 22 )(47 downto 32) <= neutralClusterPhi_50 ;
s_OUTPUT_LINK_ARR( 22 )(63 downto 48) <= neutralClusterPhi_51 ;
s_OUTPUT_LINK_ARR( 22 )(79 downto 64) <= neutralClusterPhi_52 ;
s_OUTPUT_LINK_ARR( 22 )(95 downto 80) <= neutralClusterPhi_53 ;
s_OUTPUT_LINK_ARR( 22 )(111 downto 96) <= neutralClusterPhi_54 ;
s_OUTPUT_LINK_ARR( 22 )(127 downto 112) <= neutralClusterPhi_55 ;
s_OUTPUT_LINK_ARR( 22 )(143 downto 128) <= neutralClusterPhi_56 ;
s_OUTPUT_LINK_ARR( 22 )(159 downto 144) <= neutralClusterPhi_57 ;
s_OUTPUT_LINK_ARR( 22 )(175 downto 160) <= neutralClusterPhi_58 ;
s_OUTPUT_LINK_ARR( 22 )(191 downto 176) <= neutralClusterPhi_59 ;
s_OUTPUT_LINK_ARR( 23 )(15 downto 0) <= neutralClusterPhi_60 ;
s_OUTPUT_LINK_ARR( 23 )(31 downto 16) <= neutralClusterPhi_61 ;
s_OUTPUT_LINK_ARR( 23 )(47 downto 32) <= neutralClusterPhi_62 ;
s_OUTPUT_LINK_ARR( 23 )(63 downto 48) <= neutralClusterPhi_63 ;
s_OUTPUT_LINK_ARR( 23 )(79 downto 64) <= neutralClusterPhi_64 ;
s_OUTPUT_LINK_ARR( 23 )(95 downto 80) <= neutralClusterPhi_65 ;
s_OUTPUT_LINK_ARR( 23 )(111 downto 96) <= neutralClusterPhi_66 ;
s_OUTPUT_LINK_ARR( 23 )(127 downto 112) <= neutralClusterPhi_67 ;
   
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- End User_Code
-----------------------------------------------------------------------------

end ctp7_top_arch;
