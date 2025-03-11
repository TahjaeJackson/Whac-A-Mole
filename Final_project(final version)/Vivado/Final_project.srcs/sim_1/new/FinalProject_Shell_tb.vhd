--=============================================================================
--ENGS 31/ CoSc 56 
--B.L. Dobbins, E.W. Hansen, Professor Luke
--Name: Tahjae Jackson
--=============================================================================

--=============================================================================
--Library Declarations:

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--=============================================================================

--=============================================================================
--Entity Declaration:
ENTITY FinalProject_Shell_tb IS
END ENTITY;

--=============================================================================


--=============================================================================
----Architecture Type:
 ARCHITECTURE testbench OF FinalProject_shell_tb IS
--=============================================================================    


--=============================================================================
--Component Declaration:
COMPONENT FinalProject_shell IS

  Port (

    -- mapped to external IO device (100 MHz Clock)			        	
    clk_ext_port	        : in std_logic;

    
    
    -- input buttons
    button1_ext_port		        : in std_logic;
    button2_ext_port		        : in std_logic;
    button3_ext_port		        : in std_logic;
    button4_ext_port		        : in std_logic;
    button5_ext_port		        : in std_logic;
    
    start_ext_port : in std_logic;
    
    led1_ext_port		        : out std_logic;
    led2_ext_port		        : out std_logic;
    led3_ext_port		        : out std_logic;
    led4_ext_port		        : out std_logic;
    led5_ext_port		        : out std_logic;
    
    seg_ext_port		: out std_logic_vector(0 to 6);
    dp_ext_port			: out std_logic;
    an_ext_port			: out std_logic_vector(3 downto 0)
    
   
    
    );  				


END COMPONENT;

--=============================================================================    
-- Declare the unit that is to be simulated
-- Need to specify what the input ports and output ports are



--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Controller:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
signal button1_button_mp : std_logic:='0';
signal button2_button_mp : std_logic:='0';
signal button3_button_mp : std_logic:='0';
signal button4_button_mp : std_logic:='0';
signal button5_button_mp : std_logic:='0';
signal start_sig : std_logic;




signal led1: std_logic;
signal led2: std_logic;
signal led3: std_logic;
signal led4: std_logic;
signal led5: std_logic;

signal seg_port         : std_logic_vector(0 to 6);
signal dp_port			: std_logic;
signal an_port			: std_logic_vector(3 downto 0);

   




--=============================================================================
--Signal and Constant Declarations: 
--=============================================================================





--Inputs

signal clk_port : std_logic := '0';



-- Clock period definitions
constant clk_period : time := 10ns;
constant system_clk_period : time := 10ns;

begin
--=============================================================================
--Port Map: 
--=============================================================================
--This "port map" connects the ports (inputs and outputs of bcd_digit)
--to the signals (behaves like variables) in the testbench

dut: FinalProject_shell PORT MAP (
 	clk_ext_port	=> clk_port ,           	-- mapped to clock divider
 	-- input buttons
    button1_ext_port => button1_button_mp,
    button2_ext_port => button2_button_mp,		        
    button3_ext_port => button3_button_mp,		        
    button4_ext_port => button4_button_mp,		        
    button5_ext_port => button5_button_mp,		        
    
    start_ext_port => start_sig,
    
    led1_ext_port => led1,
    led2_ext_port	=> led2,
    led3_ext_port	=> led3,
    led4_ext_port	=> led4,
    led5_ext_port	=> led5,
    
    seg_ext_port	=>seg_port,
    dp_ext_port			=> dp_port,
    an_ext_port			=> an_port);


--=============================================================================
--Clock Generation Process: 
--=============================================================================
--Mimics the clock generation sub-component in the larger design


-- Clock process definitions
clk_process :process
begin
  clk_port <= '0';
  wait for clk_period/2;
  clk_port <= '1';
  wait for clk_period/2;
end process;







--=============================================================================
--Stimulus Process: 
--=============================================================================
--Generates inputs to the system from the external world.
--In this case, pretends to be the user setting slide switches.
--Default behavior is the initialized values.


--For the clock you could have if statements that use different constants depending on the frequency 

  -- Stimulus process
  stim_proc: process
  begin
  
  --checking the outputs of the LFSR
  start_sig <= '1';
  --button1_button_mp <= '1';
  
 
    button1_button_mp <= '1';
    wait for 1*system_clk_period;
    button1_button_mp <= '0';
    wait for  1*system_clk_period;
    button5_button_mp <= '1';
    wait for 1*system_clk_period;
    button5_button_mp <= '0';
    wait for  1*system_clk_period;
    button5_button_mp <= '1';
    wait for 1*system_clk_period;
    button5_button_mp <= '0';
    wait for  1*system_clk_period;
    button5_button_mp <= '1';
    wait for 1*system_clk_period;
    button5_button_mp <= '0';
    wait for  1*system_clk_period;
    button5_button_mp <= '1';
    wait for 1*system_clk_period;
    button5_button_mp <= '0';
    wait for  10*system_clk_period;
    start_sig <= '0';
    wait for 1* system_clk_period;
  end process stim_proc; 


END testbench;



