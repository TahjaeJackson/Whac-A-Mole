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
entity FinalProject_Display_tb is
end entity;

--=============================================================================
--Architecture
--=============================================================================
architecture testbench of FinalProject_Display_tb is

--=============================================================================
--Component Declaration
--=============================================================================
component FinalProject_LFSR is 
    Port ( 
       ---timing:
    clk_port 	        : in std_logic;
    --control inputs:
    start_en_port         : in std_logic;   
    --outputs
    light_output : out std_logic_vector (15 downto 0));
end component;

--=============================================================================
--Signals
--=============================================================================

--Inputs

signal clk_port : std_logic := '0';
signal start_en_port : std_logic := '0';




--Outputs
signal light_output : std_logic_vector(15 downto 0);



-- Clock period definitions
constant clk_period : time := 1ns;
constant system_clk_period : time := 10ns;








begin

--=============================================================================
--Port Map
--=============================================================================
uut: FinalProject_LFSR
	port map(		
		clk_port 	=> clk_port ,

    light_output => light_output, 
    start_en_port  => start_en_port);

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
    
--=============================================================================
--LOAD EVERYTHING AND CLEAR AT THE END
--=============================================================================
    
--Simulation of the monopulse signal
	start_en_port <= '1';
    wait for  10* system_clk_period;
    start_en_port <= '0';
    wait for 10* system_clk_period;
    start_en_port <= '1';
    
    wait;
    
    
    
end process stim_proc;

end testbench;
