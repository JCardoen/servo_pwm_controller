LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.clocks_pkg.ALL;

ENTITY pwm_counter_tb IS
END ENTITY;

ARCHITECTURE test OF pwm_counter_tb IS
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL servo_clk : std_logic := '0';
    SIGNAL pwm : std_logic;
    SIGNAL end_simulation : BOOLEAN := FALSE;
    SIGNAL position : std_logic_vector(7 DOWNTO 0) := "00000000";

    COMPONENT PWM_Counter IS
        PORT (
            rst : IN std_logic;
            servo_clk : IN std_logic;
            position : IN std_logic_vector(7 DOWNTO 0);
            pwm : OUT std_logic);
    END COMPONENT;

BEGIN
    U1 : PWM_Counter
    PORT MAP(
        rst => rst,
        servo_clk => servo_clk,
        position => position,
        pwm => pwm);

    -- Generate clock signals using clocks_pkg
    clock(servo_clk, 1.953125 us, end_simulation);
    clock(clk, 20 ms, end_simulation);

    stimuli_gen : PROCESS
        VARIABLE count : INTEGER := 0;
    BEGIN
        REPORT " -- Simulation start --"
            SEVERITY note;
        rst <= '1';
        WAIT UNTIL rising_edge(clk);
        rst <= '0';
        WHILE count < 8 LOOP

            WAIT UNTIL rising_edge(clk);
            position <= std_logic_vector(unsigned(position) + 32);
            count := count + 1;
        END LOOP;
        position <= "11111111";
        WAIT UNTIL rising_edge(clk);
        REPORT "-- Simulation done --"
            SEVERITY note;
        end_simulation <= TRUE;
        WAIT;
    END PROCESS stimuli_gen;

    -- Process to calculate Ton of PWM signal
    test_pwm : PROCESS (pwm)
        VARIABLE time_pwm_rising : TIME;
        VARIABLE time_pwm_falling : TIME;
        VARIABLE time_pwm_diff : TIME;
        VARIABLE current_pwm : INTEGER;
        VARIABLE asserted_time : TIME;
        VARIABLE asserted_time_diff : TIME;
        VARIABLE servo_clock_period : TIME := 1.953125 us;
    BEGIN
        IF pwm = '1' THEN
            time_pwm_rising := now;
        ELSE
            time_pwm_falling := now;
            time_pwm_diff := time_pwm_falling - time_pwm_rising;
            current_pwm := to_integer(unsigned(position));
            asserted_time := 1.25 ms + (current_pwm * servo_clock_period);
            asserted_time_diff := asserted_time - time_pwm_diff;
            REPORT "Ton of PWM (ms) : " & real'image(real(time_pwm_diff / 1 ns));
            REPORT "Current position " & INTEGER'image(current_pwm);
            REPORT "Time difference between Ton and calculated test time: "
                & TIME'image(asserted_time_diff);
            ASSERT asserted_time_diff < 1 us
            REPORT "Asserted Ton does not equal the output of the PWM Counter"
                SEVERITY error;
        END IF;
    END PROCESS test_pwm;
END test;