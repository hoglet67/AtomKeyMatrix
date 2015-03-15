----------------------------------------------------------------------------------
-- Company:        Hoglet Web Services Inc.
-- Engineer:       David Banks
-- 
-- Create Date:    13:38:38 03/15/2015 
-- Design Name:    AtomKeyMatrix
-- Module Name:    Translator - Behavioral 
-- Project Name: 
-- Target Devices: XC9572XL
-- Tool versions: 
-- Description:    Allows a BBC Keyboard to be used with an Atom
--
-- Dependencies: 
--
-- Revision: 
--    0.1 - initial revision
-- 
-- Additional Comments: 
--    currently untested
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Translator is
    port (
        Clk        : in  std_logic;
        RSTn       : in  std_logic;
        AtomRow    : in  std_logic_vector (9 downto 0);
        AtomData   : out std_logic_vector (5 downto 0);
        AtomShift  : out std_logic;
        AtomCtrl   : out std_logic;
        AtomRept   : out std_logic;
        BeebData   : in  std_logic;
        BeebRowCol : out std_logic_vector (6 downto 0);
        BeebLED    : out std_logic_vector (3 downto 1)
        );
end Translator;

architecture Behavioral of Translator is

    signal AtomCol : std_logic_vector (3 downto 0);

begin

    process (AtomRow, AtomCol)
    begin
        if (AtomCol = "0110") then
            BeebRowCol <= "0000" & "001";  -- Ctrl
        elsif (AtomCol = "0111") then
            BeebRowCol <= "0000" & "000";  -- Shift
        elsif (AtomCol = "1000") then
            BeebRowCol <= "0000" & "110";  -- Rept (Beeb Tab)
        else
            case (AtomCol & AtomRow) is
                when "0101" & "1111111110" => BeebRowCol <= "0000" & "111";  -- ESC
                when "0101" & "1111111101" => BeebRowCol <= "0001" & "110";  -- Z
                when "0101" & "1111111011" => BeebRowCol <= "0100" & "100";  -- Y
                when "0101" & "1111110111" => BeebRowCol <= "0010" & "100";  -- X
                when "0101" & "1111101111" => BeebRowCol <= "0001" & "010";  -- W
                when "0101" & "1111011111" => BeebRowCol <= "0011" & "110";  -- V
                when "0101" & "1110111111" => BeebRowCol <= "0101" & "011";  -- U
                when "0101" & "1101111111" => BeebRowCol <= "0011" & "010";  -- T
                when "0101" & "1011111111" => BeebRowCol <= "0001" & "101";  -- S
                when "0101" & "0111111111" => BeebRowCol <= "0011" & "011";  -- R
                when "0100" & "1111111110" => BeebRowCol <= "0000" & "001";  -- Q
                when "0100" & "1111111101" => BeebRowCol <= "0111" & "011";  -- P
                when "0100" & "1111111011" => BeebRowCol <= "0110" & "011";  -- O
                when "0100" & "1111110111" => BeebRowCol <= "0101" & "101";  -- N
                when "0100" & "1111101111" => BeebRowCol <= "0101" & "110";  -- M
                when "0100" & "1111011111" => BeebRowCol <= "0110" & "101";  -- L
                when "0100" & "1110111111" => BeebRowCol <= "0110" & "100";  -- K
                when "0100" & "1101111111" => BeebRowCol <= "0101" & "100";  -- J
                when "0100" & "1011111111" => BeebRowCol <= "0101" & "010";  -- I
                when "0100" & "0111111111" => BeebRowCol <= "0100" & "101";  -- H
                when "0011" & "1111111110" => BeebRowCol <= "0011" & "101";  -- G
                when "0011" & "1111111101" => BeebRowCol <= "0011" & "100";  -- F
                when "0011" & "1111111011" => BeebRowCol <= "0010" & "010";  -- E
                when "0011" & "1111110111" => BeebRowCol <= "0010" & "011";  -- D
                when "0011" & "1111101111" => BeebRowCol <= "0010" & "101";  -- C
                when "0011" & "1111011111" => BeebRowCol <= "0100" & "110";  -- B
                when "0011" & "1110111111" => BeebRowCol <= "0001" & "100";  -- A
                when "0011" & "1101111111" => BeebRowCol <= "0111" & "100";  -- @
                when "0011" & "1011111111" => BeebRowCol <= "1000" & "110";  -- /
                when "0011" & "0111111111" => BeebRowCol <= "0111" & "110";  -- .
                when "0010" & "1111111110" => BeebRowCol <= "0111" & "001";  -- -
                when "0010" & "1111111101" => BeebRowCol <= "0110" & "110";  -- ,
                when "0010" & "1111111011" => BeebRowCol <= "0111" & "101";  -- ;
                when "0010" & "1111110111" => BeebRowCol <= "1000" & "100";  -- :
                when "0010" & "1111101111" => BeebRowCol <= "0110" & "010";  -- 9
                when "0010" & "1111011111" => BeebRowCol <= "0101" & "001";  -- 8
                when "0010" & "1110111111" => BeebRowCol <= "0100" & "010";  -- 7
                when "0010" & "1101111111" => BeebRowCol <= "0100" & "011";  -- 6
                when "0010" & "1011111111" => BeebRowCol <= "0011" & "001";  -- 5
                when "0010" & "0111111111" => BeebRowCol <= "0010" & "001";  -- 4
                when "0001" & "1111111110" => BeebRowCol <= "0001" & "001";  -- 3
                when "0001" & "1111111101" => BeebRowCol <= "0001" & "011";  -- 2
                when "0001" & "1111111011" => BeebRowCol <= "0000" & "011";  -- 1
                when "0001" & "1111110111" => BeebRowCol <= "0111" & "010";  -- 0
                when "0001" & "1111101111" => BeebRowCol <= "1001" & "101";  -- Del
                when "0001" & "1111011111" => BeebRowCol <= "1001" & "110";  -- Copy
                when "0001" & "1110111111" => BeebRowCol <= "1001" & "100";  -- Ret
                when "0000" & "1111111011" => BeebRowCol <= "1001" & "011";  -- Up/Down (Beeb Up)
                when "0000" & "1111110111" => BeebRowCol <= "1001" & "001";  -- Left/Right (Beeb Left)
                when "0000" & "1111101111" => BeebRowCol <= "0000" & "101";  -- Lock (Beeb Shift Lock)
                when "0000" & "1111011111" => BeebRowCol <= "1000" & "001";  -- ^
                when "0000" & "1110111111" => BeebRowCol <= "1000" & "101";  -- ]
                when "0000" & "1101111111" => BeebRowCol <= "1000" & "111";  -- \
                when "0000" & "1011111111" => BeebRowCol <= "1001" & "011";  -- [
                when "0000" & "0111111111" => BeebRowCol <= "0010" & "110";  -- Space
                when others                => BeebRowCol <= "0000" & "000";                               
            end case;
        end if;
    end process;

    process (Clk, RSTn)
    begin
        if (RSTn = '0') then
            AtomCol   <= (others => '0');
            AtomData  <= (others => '1');
            AtomShift <= '1';
            AtomCtrl  <= '1';
            AtomRept  <= '1';
            -- BeebLED(1) is the shift lock
            -- BeebLED(2) is the caps lock
            -- BeebLED(3) is the casette motor
            BeebLED   <= (others => '1');
        elsif rising_edge(Clk) then
            if (AtomCol = "1000") then
                AtomCol <= (others => '0');
            else
                AtomCol <= std_logic_vector(unsigned(AtomCol) + 1);
            end if;
            case (AtomCol) is
                when "0000" => AtomData(0) <= BeebData;
                when "0001" => AtomData(1) <= BeebData;
                when "0010" => AtomData(2) <= BeebData;
                when "0011" => AtomData(3) <= BeebData;
                when "0100" => AtomData(4) <= BeebData;
                when "0101" => AtomData(5) <= BeebData;
                when "0110" => AtomCtrl    <= BeebData;
                when "0111" => AtomShift   <= BeebData;
                when "1000" => AtomRept    <= BeebData;
                when others =>
            end case;
        end if;
    end process;

end Behavioral;
