LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE clocks_pkg IS
    PROCEDURE clock(
        SIGNAL clk : INOUT std_logic;
        CONSTANT period : IN TIME;
        SIGNAL end_simulation : IN BOOLEAN
    );
END PACKAGE clocks_pkg;

PACKAGE BODY clocks_pkg IS
    PROCEDURE clock(SIGNAL clk : INOUT std_logic; CONSTANT period : IN TIME; SIGNAL end_simulation : IN BOOLEAN) IS
    BEGIN
        LOOP
            EXIT WHEN end_simulation;
            clk <= NOT clk;
            WAIT FOR period/2;
        END LOOP;
    END PROCEDURE clock;
END PACKAGE BODY clocks_pkg;