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
entity FinalProject_LFSR_Display is
  Port ( 
       --timing:
    clk_port 	        : in std_logic;
    --control inputs:
    LFSR_bits	    : out std_logic_vector(3 downto 0); 
    start_en_port         : in std_logic;   
    --outputs
    led1 : out std_logic;
    light_output : out std_logic_vector (2 downto 0);
    led2 : out std_logic;
    led3 : out std_logic;
    led4 : out std_logic;
    led5 : out std_logic);

    
end FinalProject_LFSR_Display;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture Behavioral of FinalProject_LFSR_Display is
type state is (NONE,L1,L2,L3,L4,L5);
--=============================================================================
--Signal Declarations: 
    signal current_state, nextState: state := NONE;

	signal LFSR_bits_sig: std_logic_vector(3 downto 0):="1000";
    signal temp  : std_logic;
    signal light_signal : std_logic_vector (3 downto 0); --4 so that the limit is 15 and each light has 33.3% chance of turning on
    signal mod_value : integer; 
    signal light_sig_int: integer;
    signal mod_num: integer := 5;

--=============================================================================



--=============================================================================
--Processes: 
--============================================
--=================================
begin
  StateUpdate: process(clk_port)
  begin
      if rising_edge(clk_port) then 
          current_state <= nextState;
      end if;

  end process StateUpdate;
  
  NextStateLogic: process(current_state,light_signal, light_sig_int,mod_value, mod_num)
  begin

	nextState <= current_state;
    light_sig_int <= to_integer(signed(light_signal));
    mod_value <= light_sig_int mod mod_num;
    
    light_output <= std_logic_vector(to_unsigned(mod_value, 3));
    
    case current_state is 
    
    --Allows the user to enter number
    	when NONE=>
    	-- maybe this needs some elses
        	if mod_value = 0  then
            	nextState <= L1;
            end if;
            if mod_value = 1  then
            	nextState <= L2;
            end if;
            if mod_value = 2  then
            	nextState <= L3;
            end if;
            if mod_value = 3  then
            	nextState <= L4;
            end if;
            if mod_value = 4  then
            	nextState <= L5;
            end if;
            
            
            --Always switch to all lights being off after a light is turned 
        when L1 =>
        	nextState <= NONE;
        when L2 =>
        	nextState <= NONE;
        when L3 =>
        	nextState <= NONE;
        when L4 =>
        	nextState <= NONE;
        when L5 =>
        	nextState <= NONE;
            
            --edge case
        when others =>
        	nextState <= NONE;
      end case;
  end process NextStateLogic;

  OutputLogic: process(current_state)
  begin

--everything starts off with not being enabled 

	led1 <= '0';
    led2 <= '0';
    led3 <= '0';
    led4 <= '0';
    led5 <= '0';
    
    case current_state is 
    
        when L1 =>
        	led1 <= '1';
       	
        when L2 =>
        	led2 <= '1';
        
        when L3 =>
        	led3 <= '1';
        
        when L4 =>
        	led4 <= '1';
            
        when L5 =>
        	led5 <= '1';
            
        when others =>
        	led1 <= '0';
            led2 <= '0';
            led3 <= '0';
            led4 <= '0';
            led5 <= '0';
        	
     end case;
    
  end process OutputLogic;
				
  LFSR: process(clk_port,start_en_port,temp,LFSR_bits_sig,light_signal)
  begin
    if rising_edge(clk_port) then
    	if start_en_port = '1' then
        	temp <= (LFSR_bits_sig(0) xor LFSR_bits_sig(1));
        	light_signal <= LFSR_bits_sig(3 downto 0);
            LFSR_bits_sig <= temp & LFSR_bits_sig(3 downto 1); -- shift_right(LFSR_bits_sig,1);
            LFSR_bits <= LFSR_bits_sig(3 downto 0);
           -- LFSR_bits sll 1;
            --LFSR_bits_sig(15) <= temp;
            
        
        
        	-- this is where I do the shifting
--       else
--            LFSR_bits_sig <= "1000";
--            LFSR_bits<="1000";

    end if;
   end if;
  end process;
  
end behavioral;

