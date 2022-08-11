----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/11/2022 09:05:24 AM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( 
        sw  : in std_logic_vector(7 downto 0);
        led : out std_logic_vector(3 downto 0);
        clk : in std_logic
    );
end top;

architecture Behavioral of top is

signal choice : std_logic_vector(1 downto 0);
signal flipFlopOut : std_logic_vector(3 downto 0);
signal mux_out    : std_logic_vector(3 downto 0);
signal enable    :  std_logic;
signal incrementado : std_logic_vector(3 downto 0);

begin
    prio_encoder : entity work.cod_prio(cond_arch)
        port map(
            r => sw(7 downto 5),
            pcode => choice(1 downto 0)
        );
    
    MUX0 : entity work.mux_4x1(cond_arch)
        port map(
            i(0) => flipFlopOut(0),
            i(1) => flipFlopOut(1),
            i(2) => incrementado(0),
            i(3) => sw(0),
            c => choice,
            s => mux_out(0)   
        ); 
        
    MUX1: entity work.mux_4x1(cond_arch)
        port map(
            i(0) => flipFlopOut(1),
            i(1) => flipFlopOut(2),
            i(2) => incrementado(1),
            i(3) => sw(1),
            c => choice,
            s => mux_out(1)   
        ); 
        
    MUX2 : entity work.mux_4x1(cond_arch)
        port map(
            i(0) => flipFlopOut(2),
            i(1) => flipFlopOut(3),
            i(2) => incrementado(2),
            i(3) => sw(2),
            c => choice,
            s => mux_out(2)   
        ); 
                        
    MUX3 : entity work.mux_4x1(cond_arch)
        port map(
            i(0) => flipFlopOut(3),
            i(1) => sw(4),
            i(2) => incrementado(3),
            i(3) => sw(3),
            c => choice,
            s => mux_out(3)   
        );     
        
    flipflop0 : entity work.FF_D(Behavioral)
        port map(
            D => mux_out(0),
            e => enable,
            Q => flipFlopOut(0),
            clk => clk
        );
        
    flipflop1 : entity work.FF_D(Behavioral)
        port map(
            D => mux_out(1),
            e => enable,
            Q => flipFlopOut(1),
            clk => clk
        );
        
    flipflop2 : entity work.FF_D(Behavioral)
        port map(
            D => mux_out(2),
            e => enable,
            Q => flipFlopOut(2),
            clk => clk
        );
        
    flipflop3 : entity work.FF_D(Behavioral)
        port map(
            D => mux_out(3),
            e => enable,
            Q => flipFlopOut(3),
            clk => clk
        );
    
    saidasFlipFlop: entity work.saidas(Behavioral)
        port map(
            a => flipFlopOut,
            b => led
        );

    divisorClock : entity work.div_clk(Behavioral)
        port map(
            clk => clk,
            en => enable
        );   
    
    incrementando: entity work.inc_4bits(Behavioral)
        port map(
            inc_in => flipFlopOut,
            inc_out => incrementado
        );
    
    
end Behavioral;
