--=============================================================================
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
entity tick_generator_tb is
end entity;

--=============================================================================
--Architecture
--=============================================================================
architecture testbench of tick_generator_tb is

--=============================================================================
--Component Declaration
--=============================================================================
component tick_generator is
	generic (FREQUENCY_DIVIDER_RATIO : integer);
	port (
	start_sig : in std_logic;
		system_clk_port  : in  std_logic;
		button_light_same: in std_logic;
		tick_port		 : out std_logic);
end component;

--=============================================================================
--Signals
--=============================================================================
signal start_sig			: std_logic := '0';
signal system_clk_port 			: std_logic := '0';
signal button_light_same 		: std_logic := '0';
signal tick_port 		: std_logic := '0';

constant clk_period: time := 10 ns;	-- 100 MHz

begin

--=============================================================================
--Port Map
--=============================================================================
uut: tick_generator
generic map(
	FREQUENCY_DIVIDER_RATIO =>10000)
port map( 
    start_sig => start_sig,
    button_light_same => button_light_same,
	system_clk_port 	=> system_clk_port,
	tick_port			=> tick_port);

--=============================================================================
--clk_100MHz generation 
--=============================================================================
clkgen_proc: process
begin
	system_clk_port <= not(system_clk_port);		-- toggle clk signal
    wait for clk_period/2;	-- OK to use "wait" in testbench
end process clkgen_proc;

--=============================================================================
--Stimulus Process
--=============================================================================
stim_proc: process
begin				
	start_sig <= '1';
	wait for 2 * clk_period;
	
	--simulate hitting the moles multiple times
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for  clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for  clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	wait for clk_period;
	button_light_same <='1';
	wait for  clk_period;
	button_light_same <='0';
	
	wait for  10 * clk_period;
	button_light_same <='1';
	wait for  20* clk_period;
	button_light_same <='0';
	start_sig <='0';
	wait for 10 * clk_period;
	start_sig <= '1';
	wait for 10 * clk_period;
	
end process stim_proc;

end testbench;
