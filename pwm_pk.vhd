library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package pwm_pk is
  constant BROADCAST_ADDR : std_logic_vector(7 downto 0) := "11111111";
  constant UNICAST_ADDR : std_logic_vector(7 downto 0) := "00000001";
end package;