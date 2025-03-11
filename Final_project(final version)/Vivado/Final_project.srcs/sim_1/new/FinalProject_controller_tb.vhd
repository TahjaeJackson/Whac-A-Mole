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
entity FinalProject_controller_tb is
end entity;

--=============================================================================
--Architecture
--=============================================================================
architecture testbench of FinalProject_controller_tb is

--=============================================================================
--Component Declaration
--=============================================================================
component FinalProject_controller is
  Port ( 
    --timing:
    clk_port 			: in std_logic;

    --control inputs for buttons:
    up_port		    : in std_logic;
    left_port		    : in std_logic;
    down_port		    : in std_logic;
    right_port		    : in std_logic;
    centre_port : in std_logic;
    
    --control outputs:
    button_output_port	    : out std_logic_vector(2 downto 0));
end component;

--=============================================================================
--Signals
--=============================================================================

--Inputs

signal clk_port : std_logic := '0';
signal up_port : std_logic := '0';
signal left_port : std_logic := '0';
signal down_port : std_logic := '0';
signal right_port : std_logic := '0';
signal centre_port : std_logic := '0';


--Outputs
signal button_output_port : std_logic_vector(2 downto 0);



-- Clock period definitions
constant clk_period : time := 10ns;
constant system_clk_period : time := 10ns;








begin

--=============================================================================
--Port Map
--=============================================================================
uut: FinalProject_controller
	port map(		
		clk_port 	=> clk_port ,
		up_port => up_port,
    left_port => left_port,
    down_port => down_port,
    right_port => right_port,
    centre_port => centre_port,
    button_output_port => button_output_port);

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
	up_port <= '1';
    wait for  system_clk_period;
    up_port <= '0';
    
    wait for 2 * system_clk_period;
    

    
 --Simulation of the monopulse signal
    left_port <= '1';
    wait for  system_clk_period;
    left_port <= '0';
    
    wait for 2 * system_clk_period;
    
--Simulation of the monopulse signal
	down_port <= '1';
    wait for  system_clk_period;
    down_port <= '0';
    
    wait for 2 * system_clk_period;
    
--Simulation of the monopulse signal
	right_port <= '1';
    wait for  system_clk_period;
    right_port <= '0';
    
    wait for 2 * system_clk_period;
    
    centre_port <= '1';
    wait for system_clk_period;
    centre_port <= '0';
    
    --we will see that there is an output of "000" when none of the lights are turned on 
    
   
    wait for 10 * system_clk_period;
   
    wait;
    
    
    
end process stim_proc;

end testbench;
