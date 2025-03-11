--=============================================================================
--ENGS 31/ CoSc 56
--Lab 5 Shell
--Tahjae Jackson
--=============================================================================

--=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--=============================================================================
--Entity Declaration:
--=============================================================================
entity FinalProject_shell is
  Port (

    -- mapped to external IO device (100 MHz Clock)			        	
    clk_ext_port	        : in std_logic;

    
    
    -- input buttons
    button1_ext_port		        : in std_logic;
    button2_ext_port		        : in std_logic;
    button3_ext_port		        : in std_logic;
    button4_ext_port		        : in std_logic;
    button5_ext_port		        : in std_logic;
    
    start_ext_port : in std_logic; -- signal that initiates the name
    
    --LED'S that behave as teh moles in the game
    
    led1_ext_port		        : out std_logic; --mole 1
    led2_ext_port		        : out std_logic; -- mole 2
    led3_ext_port		        : out std_logic; -- mole 3
    led4_ext_port		        : out std_logic; -- mole 4
    led5_ext_port		        : out std_logic; -- mole 5
    
    
    --responsible for the display of the score
    seg_ext_port		: out std_logic_vector(0 to 6);
    dp_ext_port			: out std_logic;
    an_ext_port			: out std_logic_vector(3 downto 0)
    
   
    
    );  				
end FinalProject_shell;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of FinalProject_shell is

--=============================================================================
--Sub-Component Declarations:
--=============================================================================
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--System Clock Generation:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component system_clock_generation is
	generic (
	   CLOCK_DIVIDER_RATIO : integer);
    port (
        input_clk_port		: in  std_logic;
        system_clk_port	    : out std_logic;
		fwd_clk_port		: out std_logic);
end component;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Sample Tick Generation
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component tick_generator is
	generic (
	   FREQUENCY_DIVIDER_RATIO : integer);
	port (
		   start_sig: in std_logic;
		system_clk_port : in  std_logic;
		button_light_same : in std_logic;
		tick_port	    : out std_logic);
end component;
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Input Conditioning:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component button_interface is
  Port( clk_port            : in  std_logic;
        button_port         : in  std_logic;
        button_db_port      : out std_logic;
        button_mp_port      : out std_logic);	
end component;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Controller:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Datapath:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component FinalProject_datapath is
  Port ( 
    --timing:
    clk_port 	        : in std_logic;

    --control inputs:
    button_input_port	    : in std_logic_vector(2 downto 0);
    button_light_same : out std_logic;
    led_light_on : in std_logic_vector(2 downto 0); --could be a name
    start_input : in std_logic;
    
    --datapath outputs:
    score_display_port  : out std_logic_vector(7 downto 0));
end component;
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Linear Feedback Register and LED display:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component FinalProject_LFSR is
  Port ( 
    --timing:
    clk_port 	        : in std_logic;
    --control inputs:

    start_en_port         : in std_logic;   
    --outputs
    
    light_output : out std_logic_vector (15 downto 0));

    
end component;

component FinalProject_Display is
  Port ( 
    --timing:
    clk_port 	        : in std_logic;
    take_sample_port: in std_logic;
    
    --outputs
    led1 : out std_logic;
    light_output : in std_logic_vector (15 downto 0);
    light_3_bits: out std_logic_vector (2 downto 0);
    led2 : out std_logic;
    led3 : out std_logic;
    led4 : out std_logic;
    led5 : out std_logic);

    
end component;


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--7-Segment Display:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component mux7seg is
  Port (
    --should get the 1 MHz system clk
    clk_port 	: in  std_logic;

    --score_in_port 	: in  std_logic_vector(5 downto 0); --left most digit
   y3_port 	: in  std_logic_vector(3 downto 0); --left most digit
    y2_port 	: in  std_logic_vector(3 downto 0);
    y1_port 	: in  std_logic_vector(3 downto 0);
    y0_port 	: in  std_logic_vector(3 downto 0); --right most digit
    dp_set_port : in  std_logic_vector(3 downto 0); --decimal points
    seg_port 	: out std_logic_vector(0 to 6);	    --segments (a...g)
    dp_port 	: out std_logic;		    --decimal point
    an_port 	: out std_logic_vector (3 downto 0) );	--anodes
  
end component;

--=============================================================================
--Signal Declarations: 
--=============================================================================
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Timing:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
signal system_clk: std_logic := '0';


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Controller:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
signal button1_button_mp : std_logic;
signal button2_button_mp : std_logic;
signal button3_button_mp : std_logic;
signal button4_button_mp : std_logic;
signal button5_button_mp : std_logic;
 
signal button_output_sig :  std_logic_vector(2 downto 0);

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Datapath:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

signal led_light_sig : std_logic_vector(2 downto 0); --signal that stores what light is turned on
signal led_lights_out: std_logic_vector(15 downto 0); --signal that is generated by the LFSR that is used to output the light 
signal score_sig :  std_logic_vector(7 downto 0); --signal of the score
signal y3: std_logic_vector(3 downto 0) := (others => '0');
signal y2: std_logic_vector(3 downto 0) := (others => '0');
signal y1: std_logic_vector(3 downto 0) := (others => '0');
signal y0: std_logic_vector(3 downto 0) := (others => '0');
signal an: std_logic_vector(3 downto 0) := (others => '1');
signal same_sig: std_logic; -- signal that goes high if the mle has been hit ie. the led light on corresponds with teh button pressed
signal take_sample      : std_logic := '0';   --signal pased using the tick generator 
signal overflow         : std_logic := '0';
signal dp_set : std_logic_vector(3 downto 0);



--=============================================================================
--Port Mapping (wiring the component blocks together): 
--=============================================================================
begin
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the system clock generator into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
  clocking: system_clock_generation 
generic map(
	CLOCK_DIVIDER_RATIO => 10)               --You don't need a semicolon here
port map(
	input_clk_port 		=> clk_ext_port,
	system_clk_port 	=> system_clk);

tick_generation: tick_generator
generic map(
	FREQUENCY_DIVIDER_RATIO =>10E6)
port map( 
    start_sig => start_ext_port,
    button_light_same => same_sig,
	system_clk_port 	=> system_clk,
	tick_port			=> take_sample);


	
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the input conditioning block into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wiring the port map in twice generates two separate instances of one component
  button1_monopulse: button_interface port map(
    clk_port            =>    system_clk ,
    button_port         =>     button1_ext_port,
    button_db_port      =>     open,
    button_mp_port      =>     button1_button_mp);
    
   button2_monopulse: button_interface port map(
    clk_port            =>    system_clk ,
    button_port         =>     button2_ext_port,
    button_db_port      =>     open,
    button_mp_port      =>     button2_button_mp);
    
    
   button3_monopulse: button_interface port map(
    clk_port            =>    system_clk ,
    button_port         =>     button3_ext_port,
    button_db_port      =>     open,
    button_mp_port      =>     button3_button_mp);
    
   button4_monopulse: button_interface port map(
    clk_port            =>    system_clk ,
    button_port         =>     button4_ext_port,
    button_db_port      =>     open,
    button_mp_port      =>     button4_button_mp);
    
    
  button5_monopulse: button_interface port map(
    clk_port            =>    system_clk ,
    button_port         =>     button5_ext_port,
    button_db_port      =>     open,
    button_mp_port      =>     button5_button_mp);
    
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the controller into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  controller: FinalProject_controller port map(
    clk_port	 	  =>     system_clk,
    
    up_port => button1_button_mp,
    left_port => button2_button_mp,
    down_port => button3_button_mp,
    right_port => button4_button_mp,
    centre_port => button5_button_mp,
    button_output_port => button_output_sig);
	
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the datapath into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  datapath: FinalProject_datapath port map(
    clk_port	 	=>     system_clk,
    start_input => start_ext_port,
    button_light_same => same_sig,
    button_input_port => button_output_sig,
    led_light_on => led_light_sig,
    score_display_port  => score_sig );
    
    
    
  --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the Linear feedback Shift register display into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  led_lfsr: FinalProject_LFSR port map(
    clk_port	 	=>     system_clk,
    --control inputs: 
    light_output => led_lights_out,
    start_en_port  => start_ext_port);
    
    
  led_display: FinalProject_Display port map(
    clk_port	 	=>     system_clk,
    take_sample_port => take_sample,
    --control inputs:
    light_output => led_lights_out, 
    light_3_bits => led_light_sig,     
    --outputs
    led1 => led1_ext_port,
    led2 => led2_ext_port,
    led3 => led3_ext_port,
    led4 => led4_ext_port,
    led5 => led5_ext_port);
		
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the 7-segment display into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
display_select: process(score_sig)
begin

        y3 <= "0000";
        y2 <= "0000";
        y1 <= score_sig(7 downto 4) ;
        y0 <= score_sig(3 downto 0);

end process;
   dp_set <= "000" & overflow;
              
  seven_seg: mux7seg port map(
   clk_port	=>     system_clk,   --should get the 1 MHz system clk
    y3_port	=>     y3,   --left most digit
    y2_port 	=>     y2,   --center left digit
    y1_port 	=>     y1,   --center right digit
    y0_port 	=>     y0,   --right most digit
    dp_set_port => dp_set, --you get this one for free too
    seg_port 	=>     seg_ext_port,
    dp_port 	=>    dp_ext_port ,
    an_port 	=>    an_ext_port);	
    
end behavioral_architecture;