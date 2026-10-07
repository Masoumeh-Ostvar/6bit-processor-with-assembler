library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Processor2 is						 
	port(clk, reset : in STD_LOGIC);
end Processor2;

architecture Processor2 of Processor2 is	   

type Memory_t is array (63 downto 0) of std_logic_vector(6 downto 0);
type State_t is (S0, HaltCheck ,S1, S2, S3, S4, S5, S6, S7, S8);

signal Memory : Memory_t := 
( 		  
    --PART 3:
    0 => "0000000",	-- Load R0,
	1 => "0000110",	-- 6
	2 => "0000100",	-- Load R1, 
	3 => "0001000",	-- 8
	4 => "1000001",	-- Mult, R0, R1
	others => "1111111" -- Halt 
);

--FSM
signal CurrentState, NextState : State_t;  
-- Registers
signal R0,R1,R2,R3,IR,PC : std_logic_vector (6 downto 0); 
signal R0Next,R1Next,R2Next,R3Next,IRNext,PCNext : std_logic_vector (6 downto 0);
-- Controls		
signal ALURes : std_logic_vector(13 downto 0);
signal MData, DataBUS, IN1,IN2 : std_logic_vector(6 downto 0);
signal SelMux1,SelMux2 : std_logic_vector(1 downto 0);	
signal LD0,LD1,LD2,LD3, BUSSel,LDPC,LDIR,INC,RST, ZR0,ZR1,ZR2,ZR3: std_logic;	  
signal CMD : std_logic_vector(1 downto 0);
--Helpers for simpler code
signal Z : std_logic_vector(3 downto 0);	 
signal index : integer;	

begin	   
	
	Z(0) <= ZR0;
	Z(1) <= ZR1;
	Z(2) <= ZR2;
	Z(3) <= ZR3;
	index <= to_integer(unsigned(IR(3 downto 2)));
	
	Registers: process(clk,reset)  
	begin 	
		if reset='1' then 
			CurrentState <= s0;
			IR <= "0000000";
			PC <= "0000000";	
			R0 <= "0000000";	 
			R1 <= "0000000";
			R2 <= "0000000";
			R3 <= "0000000";	
		elsif (rising_edge(clk)) then			
			CurrentState <= NextState;
			IR <= IRNext;
			PC <= PCNext;
		    R0 <= R0Next;	 
			R1 <= R1Next;
			R2 <= R2Next;
			R3 <= R3Next;
		end if;
	end process; 
	
	
	Mux0: process(MData, ALURes, BUSSel)
	begin 
		case BUSSel is 
			when '0' => 
		 	   DataBUS <= MData; 
			when '1' =>
			   DataBUS <= ALURes(6 downto 0);
			when others =>
			   DataBUS <= (others => '0');
	    end case;	
	end process; 
	
	Mux1: process(R0,R1,R2,R3,SelMux1)
	begin  
		case SelMux1 is 
			when "00" => 
			   IN1 <= R0;
			when "01" =>
			   IN1 <= R1;
			when "10" => 
			   IN1 <= R2;
			when "11" =>
			   IN1 <= R3;
			when others =>
			   IN1 <= (others => '0');
	    end case;			
	end process;
	
	Mux2:process(R0,R1,R2,R3,SelMux2)
	begin  
		case SelMux2 is 
			when "00" => 
			   IN2 <= R0;
			when "01" =>
			   IN2 <= R1;
			when "10" => 
			   IN2 <= R2;
			when "11" =>
			   IN2 <= R3;
			when others =>
			   IN2 <= (others => '0');
	    end case;			
	end process; 
	
	
	MData <= Memory(to_integer(unsigned(PC)));	
	ZR0 <= '1' when R0="0000000" else '0';
	ZR1 <= '1' when R1="0000000" else '0';
	ZR2 <= '1' when R2="0000000" else '0';
	ZR3 <= '1' when R3="0000000" else '0'; 
	PCNext <= DataBUS when LDPC='1' else PC+1 when INC='1' else "0000000" when RST='1' else PC;
	IRNext <= DataBUS when LDIR='1' else IR;
	R0Next <= DataBUS when LD0='1' else R0;
	R1Next <= DataBUS when LD1='1' else R1;
	R2Next <= DataBUS when LD2='1' else R2;
	R3Next <= DataBUS when LD3='1' else R3; 

	
	process(IN1, IN2, CMD)
	begin
    case CMD is
        when "00" =>
            ALURes <= "0000000" & (IN1 + IN2);
        when "01" =>
            ALURes <= "0000000" & (IN1 - IN2);
        when "10" =>
            ALURes <= IN1 * IN2;
        when others =>
            ALURes <= (others => '0');
    end case;
	end process;
 
	
	process(IR, Z, CurrentState)
	begin
	-- Initialize signals
	CMD <= "00";
	INC <= '0';
	RST <= '0';
	LD0 <= '0';
	LD1 <= '0';
	LD2 <= '0';
	LD3 <= '0';
	LDPC <= '0';
	LDIR <= '0';
	SelMux1 <= "00";
	SelMux2 <= "00";
	BUSSel <= '0';

	-- State transitions
	case CurrentState is
		when s0 =>
			RST <= '1';
			NextState <= s1;
			
		when s1 =>
			LDIR <= '1';
			INC <= '1';
			BUSSel <= '0';
			NextState <= HaltCheck;
			
		when HaltCheck =>
			if IR = "1111111" then
				NextState <= s2;
			elsif IR(6 downto 4) = "000" then
				NextState <= s3;
			elsif IR(6 downto 4) = "001" then
				NextState <= s4;
			elsif IR(6 downto 4) = "010" then
				NextState <= s5;
			elsif IR(6 downto 4) = "011" then
				if Z(index) = '0' then
					NextState <= s6;
				else
					NextState <= s7;
				end if;
			elsif IR(6 downto 4) = "100" then  
				NextState <= s8;
			else
				NextState <= s1;
			end if;

		when s2 =>
			NextState <= s2;

		when s3 =>
			NextState <= s1;
			INC <= '1';
			BUSSel <= '0';
			case IR(3 downto 2) is
				when "00" => LD0 <= '1';
				when "01" => LD1 <= '1';
				when "10" => LD2 <= '1';
				when others => LD3 <= '1';
			end case;

		when s4 =>
			NextState <= s1;
			CMD <= "00";
			SelMux1 <= IR(3 downto 2);
			SelMux2 <= IR(1 downto 0);
			BUSSel <= '1';

			case IR(3 downto 2) is
				when "00" => LD0 <= '1';
				when "01" => LD1 <= '1';
				when "10" => LD2 <= '1';
				when others => LD3 <= '1';
			end case;

		when s5 =>
			NextState <= s1;
			CMD <= "01";	 
			SelMux1 <= IR(3 downto 2);
			SelMux2 <= IR(1 downto 0);
			BUSSel <= '1';

			case IR(3 downto 2) is
				when "00" => LD0 <= '1';
				when "01" => LD1 <= '1';
				when "10" => LD2 <= '1';
				when others => LD3 <= '1';
			end case;

		when s6 =>
			NextState <= s1;
			LDPC <= '1';
			BUSSel <= '0';

		when s7 =>	
			INC <= '1';
			NextState <= s1; 
		
		when s8 =>
   	 	NextState <= s1;
   	 	CMD <= "10";
     	BUSSel <= '1';
   		SelMux1 <= IR(3 downto 2);
   		SelMux2 <= IR(1 downto 0);
    
   		case IR(3 downto 2) is
        when "00" => LD0 <= '1';
        when "01" => LD1 <= '1';
        when "10" => LD2 <= '1';
        when others => LD3 <= '1';
    	end case;	

	end case;
	end process;

end Processor2;
