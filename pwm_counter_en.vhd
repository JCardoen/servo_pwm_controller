LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY PWM_Counter IS
    PORT (
        rst : IN std_logic;
        servo_clk : IN std_logic;
        position : IN std_logic_vector(7 DOWNTO 0);
        pwm : OUT std_logic);
END PWM_Counter;

ARCHITECTURE behavioral OF PWM_Counter IS
    SIGNAL counter : unsigned(13 DOWNTO 0);
    SIGNAL offset_pos : unsigned(11 DOWNTO 0);
    SIGNAL default_pos : unsigned(7 DOWNTO 0) := "10000000";
BEGIN
    offset_pos <= unsigned("0000" & position) + 640; -- offset
    PROCESS (rst, servo_clk)
    BEGIN
        IF (rst = '1') THEN
	    counter <= (OTHERS => '0');
        ELSIF rising_edge(servo_clk) THEN
            IF (counter < 10240) THEN
                counter <= counter + 1;
            ELSE
                counter <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

    pwm <= '1' WHEN (counter < offset_pos) ELSE
        '0';

END ARCHITECTURE;