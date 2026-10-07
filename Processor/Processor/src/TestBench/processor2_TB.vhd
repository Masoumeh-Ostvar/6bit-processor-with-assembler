library ieee;
use ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity processor2_tb is
end processor2_tb;

architecture TB_ARCHITECTURE of processor2_tb is
	-- Component declaration of the tested unit
	component processor2
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : processor2
		port map (
			clk => clk,
			reset => reset
		);				  
		
	reset <= '1', '0' after 10ns;
   
   process
   begin  
	    for i in 0 to 100 loop
        clk <= '0';
        wait for 10ns;  
        clk <= '1';
        wait for 10ns;
		end loop;
		wait;
   end process;

   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_processor2 of processor2_tb is
	for TB_ARCHITECTURE
		for UUT : processor2
			use entity work.processor2(processor2);
		end for;
	end for;
end TESTBENCH_FOR_processor2;

