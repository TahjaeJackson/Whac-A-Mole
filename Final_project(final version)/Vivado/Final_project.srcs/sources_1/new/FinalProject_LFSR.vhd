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
entity FinalProject_LFSR is
  Port ( 
       --timing:
    clk_port 	        : in std_logic;
    --control inputs:
    start_en_port         : in std_logic;   
    --outputs
    light_output : out std_logic_vector (15 downto 0));

    
end FinalProject_LFSR;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture Behavioral of FinalProject_LFSR is

--=============================================================================
--Signal Declarations: 
   
	signal current: std_logic_vector(15 downto 0):="1100010000100101"; --seed valuess
	signal next_state: std_logic_vector(15 downto 0):="1100010000100101";
    signal temp  : std_logic;


--=============================================================================



--=============================================================================
--Processes: Implementation of Linear feedback shift register that generates random 16 bits so that random lights are turned on 
--============================================
--=================================
begin

   temp <= (current(0) xor current(2) xor current(3) xor current(5)); --value fed into most significant bits using the taps
   
  
  LFSR: process(clk_port,start_en_port,temp,current, next_state)
  begin
    if rising_edge(clk_port) then
    	if start_en_port = '1' then
        	   
        	  
              next_state <= temp & current(15 downto 1); -- shift_right(LFSR_bits_sig,1);
              light_output <= current(15 downto 0);
              current <= next_state(15 downto 0);
                
         else
            light_output <= "0000000000000000"; -- outputs 0 to depict that no light should be on 
                 

    end if;
   end if;
  end process;

  
  
end behavioral;