---=============================================================================
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
entity FinalProject_controller is
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
end FinalProject_controller;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of FinalProject_controller is
	type state is (IDLE, BUTTON1, BUTTON2, BUTTON3, BUTTON4, BUTTON5);
    signal current_state, nextState: state := IDLE;
--============================================================================
--Signal Declarations: 
--=============================================================================

--=============================================================================
--Processes: 
--=============================================================================
begin
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Update the current state (synchronous):
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
StateUpdate: process(clk_port)
begin
	if rising_edge(clk_port) then  
    	current_state <= nextState;
    end if;

end process StateUpdate;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Next State Logic (asynchronous):
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NextStateLogic: process(current_state,up_port, down_port, left_port, right_port, centre_port)
begin

	nextState <= current_state;
    
    case current_state is 
    
    	when IDLE=>
        	if up_port = '1' then
            	nextState <= BUTTON1;
            end if;
            if left_port = '1' then
            	nextState <= BUTTON2;
            end if;
            if down_port = '1' then
            	nextState <= BUTTON3;
            end if;
            if right_port = '1' then
            	nextState <= BUTTON4;
            end if;
            if centre_port = '1' then
            	nextState <= BUTTON5;
            end if;
            
        when BUTTON1 =>
        	nextState <= IDLE;
        when BUTTON2 =>
        	nextState <= IDLE;
        when BUTTON3 =>
        	nextState <= IDLE;
        when BUTTON4 =>
        	nextState <= IDLE;
        when BUTTON5 =>
        	nextState <= IDLE;
           
            
            --edge case
        when others =>
        	nextState <= IDLE;
      end case;
end process NextStateLogic;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Output Logic (asynchronous):
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OutputLogic: process(current_state)
begin

--the default output is "000" which indicates that none of the lights are turned on

	button_output_port<="000";
    
    case current_state is 
    
        when BUTTON1 =>
        	button_output_port <= "001";
       	
        when BUTTON2 =>
        	button_output_port <= "010";
        
        when BUTTON3 =>
        	button_output_port <= "011";
        
        when BUTTON4 =>
        	button_output_port <= "100";
            
        when BUTTON5 =>
        	button_output_port <= "101";
            
        when others =>
        	button_output_port<="000";
        	
     end case;
    
end process OutputLogic;
				
end behavioral_architecture;


