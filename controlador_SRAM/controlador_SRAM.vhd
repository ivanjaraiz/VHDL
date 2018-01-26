----------------------------------------------------------------------------------
-- Company: UAH
-- Engineer: M.PRIETO
-- 
-- Create Date:    10:45:28 11/29/2012 
-- Design Name: CONTROLADOR SRAM
-- Module Name:    controlador_SRAM - Behavioral 
-- Project Name: PRACTICA 4 - AC - GIT
-- Target Devices: 
-- Tool versions: 
-- Description: PROCESO SINCRONO. MAQUINA DE ESTADOS PARA GENERAR LA TEMPORIZACION NECESARIA DE ACCESO A MEMORIA
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_SRAM is
	PORT(oe: OUT STD_LOGIC; -- Linea de Output Enable (lectura)
		  we: OUT STD_LOGIC; -- Linea de Write Enable (escritura)
		  adv: OUT STD_LOGIC; -- Linea de Address Valid (Dirección valida)
		  ce: OUT STD_LOGIC; -- Linea de Chip Enable (habilitacion)
		  lb: OUT STD_LOGIC; -- Linea de Low Byte Enable (habilitacion parte baja del bus)
		  ub: OUT STD_LOGIC; -- Linea de Upper Byte Enable (habilitacion parte alta del bus)
		  rst: IN STD_LOGIC; -- Señal de reset
		  mem_write: IN STD_LOGIC; -- Pulsador de escritura
		  mem_read: IN STD_LOGIC; -- Pulsador de lectura
		  clk_mem: OUT STD_LOGIC; -- Reloj para memoria. Forzado a nivel bajo
		  dir_up: IN STD_LOGIC; -- Pulsador de incremento de direcciones
		  dir_down: IN STD_LOGIC; -- Pulsador de decremento de direcciones
		  clk: IN STD_LOGIC; -- Reloj que genera la temporizacion
		  salida_leds: OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Salida LEDs
		  datos_int: IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Datos microinterruptores
		  bus_direcciones: OUT STD_LOGIC_VECTOR (19 DOWNTO 0); -- Bus de direciones de la memoria
		  display : out  STD_LOGIC_VECTOR (6 downto 0); -- BCD 7 segmentos
		  control_display: OUT STD_LOGIC_VECTOR (3 downto 0); -- Control del display
		  bus_datos_l: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Bus de datos de memoria (parte baja)
		  bus_datos_h: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0)); -- Bus de datos de memoria (parte alta)
		  
		  
end controlador_SRAM;

architecture Behavioral of controlador_SRAM is

type state_type is (st_q0, st_q1,st_q2,st_q3); -- st_q0 = inactivo, st_q1 activacion señales durante el tiempo indicado
signal next_state : state_type;
signal contador:STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0'); -- Contador de pulsos
signal direccion_actual: STD_LOGIC_VECTOR(19 DOWNTO 0):=(others => '0');
signal Q11, Q12, Q13,Q21,Q22,Q23 : std_logic;
signal dir_up_d,dir_down_d: std_logic;

-- TIEMPO DE ACCCESO A MEMORIA EN CICLOS (COMPLETAR)
constant TIEMPO : INTEGER := XXXX;

begin

SYNC_PROC: process (clk,mem_read,mem_write)

	begin
		if (clk'event and clk= '1') then
			if (rst = '1') then -- Si reset, estado cero y salidas 0000
			next_state <= st_q0;
				
			
			else
			
			contador<=contador+1; -- incrementamos contador
			
			case (next_state) is
					when st_q0 =>
						contador<=(others=>'0'); -- Ponemos contador de pulsos de reloj a cero
						-- Todo deshabilitado
						-- AQUI LINEAS DE CONTROL PARA DEJARLO TODO DESHABILITADO (COMPLETAR)
						
						bus_datos_l<=(OTHERS=>'Z');
						bus_datos_h<=(OTHERS=>'Z');
						clk_mem<='0';

						
						if ((mem_write='0' and mem_read='0') or (mem_write='1' and mem_read='1')) then
						next_state<=st_q0; -- Estado inactivo;
											
												
						elsif (mem_write='0' and mem_read='1') then
						next_state<=st_q1; -- lectura
						elsif (mem_write='1' and mem_read='0') then
						next_state<=st_q2; -- Escritura
						end if;

			
					when st_q1 =>	-- Proceso de lectura
			
						
						if (contador<TIEMPO) then
						next_state<=st_q1; -- Mientras no se cumpla el tiempo, nos mantenemos en el mismo estado
						
						-- AQUI LINEAS DE CONTROL PARA LECTURA EN MEMORIA (COMPLETAR)
						
						salida_leds<=bus_datos_l;

						else
						next_state<=st_q0;
						end if;

		
					when st_q2 =>	-- Proceso de escritura
			
						if (contador<TIEMPO) then
						next_state<=st_q2; -- Mientras no se cumpla el tiempo, nos mantenemos en el mismo estado
												
						
						-- AQUI LINEAS DE CONTROL PARA ESCRITURA EN MEMORIA (COMPLETAR)
						
						bus_datos_l<=datos_int;
						bus_datos_h<=(others=>'0');
						
						else
						next_state<=st_q0;
						end if;

					
					when  others =>
						-- Todo deshabilitado
						-- AQUI LINEAS DE CONTROL PARA DEJARLO TODO DESHABILITADO (COMPLETAR)
						
						bus_datos_l<=(OTHERS=>'Z');
						bus_datos_h<=(OTHERS=>'Z');
						clk_mem<='0';
	

					end case;	

			
			end if;
			
	end if;
	
end process;


SYNC_PROC2: process (clk,dir_up_d,dir_down_d,direccion_actual)
begin
	
	
		if (clk'event and clk= '1') then
			if (rst = '1') then -- Si reset, estado cero y salidas 0000
			direccion_actual<=(OTHERS=>'0');	
			
			else
				
										
					if (dir_up_d='1') then direccion_actual<=direccion_actual+1;
						elsif (dir_down_d='1') then direccion_actual<=direccion_actual-1;
					end if;
			
											
			end if;
			
		end if;
	
end process;

--**Insert the following after the 'begin' keyword**
ANTIRREBOTES1: process(clk)
begin
   if (clk'event and clk = '1') then
      if (rst = '1') then
         Q11 <= '0';
         Q12 <= '0';
         Q13 <= '0'; 
      else
         Q11 <= dir_up;
         Q12 <= Q11;
         Q13 <= Q12;
      end if;
   end if;
end process;

--**Insert the following after the 'begin' keyword**
ANTIRREBOTES2: process(clk)
begin
   if (clk'event and clk = '1') then
      if (rst = '1') then
         Q21 <= '0';
         Q22 <= '0';
         Q23 <= '0'; 
      else
         Q21 <= dir_down;
         Q22 <= Q21;
         Q23 <= Q22;
      end if;
   end if;
end process;



MOSTRAR: process (direccion_actual)
begin

	case (direccion_actual(3 downto 0)) IS
		when "0000" => display <="0000001";
		when "0001" => display <="1001111";
		when "0010" => display <="0010010";
		when "0011" => display <="0000110";
		when "0100" => display <="1001100";
		when "0101" => display <="0100100";
		when "0110" => display <="1100000";
		when "0111" => display <="0001111";
		when "1000" => display <="0000000";
		when "1001" => display <="0001100";
		when "1010" => display <="0001000";
		when "1011" => display <="1100000";
		when "1100" => display <="0110001";
		when "1101" => display <="1000010";
		when "1110" => display <="0110000";
		when "1111" => display <="0111000";
		when others => display <="1111111";
	        
	end case;
end process;


dir_up_d <= Q11 and Q12 and (not Q13); 
dir_down_d <= Q21 and Q22 and (not Q23);
control_display<="1110";
bus_direcciones<=direccion_actual;


end Behavioral;

