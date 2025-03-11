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
entity FinalProject_datapath is
  Port ( 
    --timing:
    clk_port 	        : in std_logic;

    --control inputs:
    button_input_port	    : in std_logic_vector(2 downto 0);
    button_light_same: out std_logic; -- signals that goes high iff the LED light on corresponds with the button pressed
    led_light_on : in std_logic_vector(2 downto 0); --tells which of the 5 led lights are on
    start_input : in std_logic; -- tells when the game is initiated 
    
    --datapath outputs:
    score_display_port  : out std_logic_vector(7 downto 0)); --passes the score to the display 
end FinalProject_datapath;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of FinalProject_datapath is
--=============================================================================
--Signal Declarations: 
	signal reset : std_logic := '0';
    signal button_light_sig : std_logic:='0';
    signal score_sig: std_logic_vector( 5 downto 0 ); 
    signal hs_greater: std_logic; -- goes high if the high score is greater
    signal cs_greater : std_logic; -- goes high if the current score is greater
    signal equal : std_logic; -- goes hight if high score is equal to current score
    signal highscore: std_logic_vector (5 downto 0):="000000";
    signal current_score: std_logic_vector (5 downto 0):="000000";
    signal first_four : std_logic_vector(3 downto 0); --last fours bits of the BCD
    signal second_four : std_logic_vector(3 downto 0); -- furst four bits of the BCD
    signal high_first_four : std_logic_vector(3 downto 0);
    signal high_second_four : std_logic_vector(3 downto 0);
    
	
--=============================================================================



--=============================================================================
--Processes: 

begin
    --============================================
    --This register updates the current score by check if the mole has been hit
    --=================================
    check_light_button: process(led_light_on,button_input_port,button_light_sig,current_score,clk_port)
    begin
    if rising_edge(clk_port) then 
        if (led_light_on /= button_input_port) then 
            reset <= '1';
            button_light_sig <= '0';
       else if (led_light_on /="000")then 
            
                button_light_sig <= '1';
                reset <='1';
             end if;
        end if;
     end if;
        button_light_same<=button_light_sig;
    end process;
    
    --============================================
    --This register keeps track of the current score
    --=================================    
   	Score_reg : process(button_light_sig,current_score, clk_port, led_light_on,start_input)
    begin 
    	if rising_edge(clk_port) then   	
            	if start_input = '0' then 
                     current_score <= "000000";
                     first_four <= "0000";
                     second_four <= "0000";
            	else
                     if( button_light_sig = '1') then 
                        current_score <= std_logic_vector( unsigned(current_score) + 1 );
                        first_four <= std_logic_vector( unsigned(first_four) + 1 );
                        if (first_four = "1001") then 
                           first_four <= "0000";
                           second_four <= std_logic_vector( unsigned(second_four) + 1 );
                        end if;
                    
                    else  if button_light_sig = '0' and led_light_on/="000" then
                            current_score <= current_score;
                             first_four <= first_four;
                             second_four <= second_four;
                        end if ;
                end if;

            	
            end if;
            end if;
    end process;
    
    --============================================
    --This register keeps track of the highest score by using a comparator 
    --=================================
    
    HighScore_reg: process(clk_port,hs_greater, cs_greater, equal,highscore, current_score)
    begin
    --comparator between high score and current score (should this be after the rising edge if statement)
        if (highscore > current_score) then 
    	   hs_greater <= '1' ;
    	   cs_greater <= '0';
    	   equal <= '0';
		else if (current_score > highscore) then
		   hs_greater <= '0' ;
    	   cs_greater <= '1';
    	   equal <= '0';
		else
		   hs_greater <= '0' ;
    	   cs_greater <= '0';
    	   equal <= '1';
		end if;
		end if;
		  
    	if rising_edge (clk_port) then
        	if hs_greater = '0' then 
            	if cs_greater = '1' then 
                	highscore <= current_score;
                	high_second_four <= second_four;
                	high_first_four <= first_four;
                end if;
             else
             	highscore <= highscore;
             end if ;
        end if; 
     end process; 
    
    --============================================
    --This process behaves like a multiplexer that selects which score to output depending on if the game is currently being played
    --=================================

    seg_display: process (start_input, current_score, highscore,clk_port,current_score,first_four,second_four)
    begin
        case start_input is 
        when '1' =>
            score_display_port <= second_four & first_four;
        when '0' =>
            score_display_port <= high_second_four & high_first_four;
            
        when others =>
            score_display_port <= second_four & first_four;
     end case;  

    end process;          
end behavioral_architecture;

