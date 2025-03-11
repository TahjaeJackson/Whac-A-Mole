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
entity tick_generator is
	generic (FREQUENCY_DIVIDER_RATIO : integer);
	port (
	start_sig : in std_logic;
		system_clk_port  : in  std_logic;
		button_light_same: in std_logic;
		tick_port		 : out std_logic);
end tick_generator;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of tick_generator is
--=============================================================================
--Signal Declarations: 
--=============================================================================
--CONSTANT FOR SYNTHESIS:
constant FREQUENCY_DIVIDER_TC: integer := FREQUENCY_DIVIDER_RATIO;
--CONSTANT FOR SIMULATION:
--constant FREQUENCY_DIVIDER_TC: integer := 10;

--Automatic register sizing:
constant COUNT_LEN					: integer := integer(ceil( log2( real(FREQUENCY_DIVIDER_TC) ) ));
signal frequency_divider_counter	: unsigned(COUNT_LEN-1 downto 0) := (others => '0');       
signal freq_div : integer :=0;
signal right_count : integer:=0; --counts how many right you have in a row

--=============================================================================
--Processes: 
--=============================================================================
begin
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Frequency Divider: updsates the frequency that the lights appear as one hits more moles
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
increase_freq: process(freq_div,right_count,button_light_same,system_clk_port,start_sig)
begin
    if rising_edge(system_clk_port) then 
        if start_sig = '0' then
            right_count <= 0;
        else if button_light_same='1' then
            right_count <= right_count + 1;
            end if;
        end if;
        
        if (right_count mod 5 = 0) and (right_count/=0) then
            freq_div <= freq_div + 1;
        else if right_count = 0  then 
            freq_div <= 0;
        
    end if;
    end if;
    end if;
    

end process;
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Frequency Divider:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
frequency_divider: process(system_clk_port, frequency_divider_counter,freq_div)
begin
	if rising_edge(system_clk_port) then
	   	if frequency_divider_counter = (((FREQUENCY_DIVIDER_TC)/(4**freq_div))-1) then 	  
			frequency_divider_counter <= (others => '0');			  -- Reset
		else
			frequency_divider_counter <= frequency_divider_counter + 1; -- Count up
		end if;
	end if;
	
	if frequency_divider_counter = 0 then tick_port <= '1';
	else tick_port <= '0';
	end if;
end process frequency_divider;

end behavioral_architecture;
