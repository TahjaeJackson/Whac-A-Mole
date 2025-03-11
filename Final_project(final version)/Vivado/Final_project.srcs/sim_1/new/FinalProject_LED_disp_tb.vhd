-----=========--=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
library UNISIM;
use UNISIM.VComponents.all;

--=============================================================================
--Entity Declaration:
--=============================================================================
entity FinalProject_LED_disp_tb is
end entity;

--=============================================================================
--Architecture
--=============================================================================
architecture testbench of FinalProject_LED_disp_tb is

--=============================================================================
--Component Declaration
--=============================================================================
component FinalProject_Display is
  Port ( 
    --timing:
    clk_port 	        : in std_logic;
    
    --outputs
    led1 : out std_logic;
    take_sample_port : in std_logic;
    light_output : in std_logic_vector (15 downto 0);
    light_3_bits: out std_logic_vector (2 downto 0);
    led2 : out std_logic;
    led3 : out std_logic;
    led4 : out std_logic;
    led5 : out std_logic);
end component;

--=============================================================================
--Signals
--=============================================================================

--Inputs

signal clk_port : std_logic := '0';
signal take_sample : std_logic;
signal light_3_bits : std_logic_vector(2 downto 0);
signal light_output : std_logic_vector(15 downto 0);
signal led1 : std_logic:='0';
signal led2 : std_logic:='0';
signal led3 : std_logic:='0';
signal led4 : std_logic:='0';
signal led5 : std_logic:='0';




-- Clock period definitions
constant clk_period : time := 10ns;
constant system_clk_period : time := 10ns;








begin

--=============================================================================
--Port Map
--=============================================================================
uut: FinalProject_Display
	port map(		
		clk_port	 	=>     clk_port,
    --control inputs:
    light_output => light_output, 
    light_3_bits => light_3_bits, 
    take_sample_port => take_sample,    
    --outputs
    led1 => led1,
    led2 => led2,
    led3 => led3,
    led4 => led4,
    led5 => led5);

--=============================================================================
--clk_100MHz generation 
--=============================================================================
clkgen_proc: process
begin

  clk_port <= '0';
  wait for clk_period/2;
  clk_port <= '1';
  wait for clk_period/2;

end process clkgen_proc;

--=============================================================================
--Stimulus Process
--=============================================================================
stim_proc: process
begin
    
    take_sample <='1';
    light_output <= "1000100010001000";
    wait for 2* system_clk_period;
    
    light_output <= "1001100010001000";
    wait for 2* system_clk_period;
    light_output <= "1010100010001000";
    wait for 2* system_clk_period;
    light_output <= "0010100010001000";
    wait for 2* system_clk_period;
    light_output <= "0110100010001000";
    wait for 2* system_clk_period;
    
    light_output <= "0000100010001000";
    wait for 2* system_clk_period;
    light_output <= "1100010001000000";
    wait for 2* system_clk_period;
    light_output <= "1001000100010001";
    wait for 2* system_clk_period;
    
    --NO LIGHT SHOULD BE ON HERE
    light_output <= "0000000000000000";
    wait for 20* system_clk_period;
    
    
    
end process stim_proc;

end testbench;
