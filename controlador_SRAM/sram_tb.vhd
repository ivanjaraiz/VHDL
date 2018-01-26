--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:51:48 11/29/2012
-- Design Name:   
-- Module Name:   C:/Mi_ISE/P4/AC-P4a/sram_tb.vhd
-- Project Name:  AC-P4a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controlador_SRAM
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sram_tb IS
END sram_tb;
 
ARCHITECTURE behavior OF sram_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controlador_SRAM
    PORT(
         oe : OUT  std_logic;
         we : OUT  std_logic;
         adv : OUT  std_logic;
         ce : OUT  std_logic;
         lb : OUT  std_logic;
         ub : OUT  std_logic;
         rst : IN  std_logic;
         mem_write : IN  std_logic;
			mem_read : IN  std_logic;
			clk_mem: OUT std_logic;
			dir_up: IN std_logic;
			dir_down: IN std_logic;
         clk : IN  std_logic;
			salida_leds: OUT std_logic_vector(7 downto 0);
			datos_int: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			bus_direcciones: OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
			display : out  STD_LOGIC_VECTOR (6 downto 0);
			control_display: OUT STD_LOGIC_VECTOR (3 downto 0);
         bus_datos_l : INOUT  std_logic_vector(7 downto 0);
         bus_datos_h : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal mem_write : std_logic := '0';
	signal mem_read : std_logic := '0';
	signal dir_up : std_logic := '0';
	signal dir_down : std_logic := '0';
   signal clk : std_logic := '0';
	signal clk_mem : std_logic := '0';
	signal datos_int: STD_LOGIC_VECTOR (7 DOWNTO 0);

	--BiDirs
   signal bus_datos_l : std_logic_vector(7 downto 0);
   signal bus_datos_h : std_logic_vector(7 downto 0);

 	--Outputs
   signal oe : std_logic;
   signal we : std_logic;
   signal adv : std_logic;
   signal ce : std_logic;
   signal lb : std_logic;
   signal ub : std_logic;
	signal salida_leds: std_logic_vector(7 DOWNTO 0);
	signal bus_direcciones: std_logic_vector(19 DOWNTO 0);
	signal display : STD_LOGIC_VECTOR (6 downto 0);
	signal control_display : STD_LOGIC_VECTOR (3 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controlador_SRAM PORT MAP (
          oe => oe,
          we => we,
          adv => adv,
          ce => ce,
          lb => lb,
          ub => ub,
          rst => rst,
          mem_write => mem_write,
			 mem_read => mem_read,
			 clk_mem => clk_mem,
			 dir_up => dir_up,
			 dir_down => dir_down,
          clk => clk,
			 salida_leds => salida_leds,
			 datos_int => datos_int,
			 bus_direcciones => bus_direcciones,
			 display => display,
			 control_display => control_display,
          bus_datos_l => bus_datos_l,
          bus_datos_h => bus_datos_h
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
			rst<='1';
			
		wait for 100 ns;
			rst<='0';
		--bus_direcciones<=(others=>'0');
		mem_write<='0';
		mem_read<='1';
		wait for clk_period*100;
		mem_write<='1';
		datos_int<=X"5A";
		mem_read<='0';
		wait for clk_period*100;
		mem_read<='0';
		mem_write<='0';
      -- insert stimulus here 
	
		dir_down<='0';
		dir_up<='1';
		wait for clk_period*10;
		dir_down<='0';
		dir_up<='0';
		wait for clk_period*10;
		dir_down<='0';
		dir_up<='1';

      wait;
   end process;

END;
