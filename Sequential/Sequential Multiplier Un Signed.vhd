-- Including Libs.
LIBRARY IEEE;
LIBRARY std;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_bit.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_signed.ALL;

---------------------------------
-- Seq Multiplier Entity
---------------------------------
ENTITY SeqMulti IS GENERIC(N : integer := 4);
   PORT(    CLK:    IN std_logic;
            RST:    IN std_logic;
            En:     IN std_logic;
            A:      IN std_logic_vector(N-1 downto 0);
            B:      IN std_logic_vector(N-1 downto 0);

            Busy:   OUT std_logic;
            Ready:  OUT std_logic;
            Result: OUT std_logic_vector(2*N-1 downto 0)
        ); 
END ENTITY SeqMulti;

---------------------------------
-- Seq Multiplier Architecture
---------------------------------
ARCHITECTURE behav OF SeqMulti IS
-- Needed Signals
SIGNAL A_temp:      std_logic_vector(2*N-1 downto 0);
SIGNAL B_temp:      std_logic_vector(2*N-1 downto 0);
SIGNAL Result_temp: std_logic_vector(2*N-1 downto 0);

SIGNAL Count : NATURAL RANGE 0 TO N ;

BEGIN 
-- Main Process
   Main: PROCESS (CLK, RST)
   BEGIN
-- Reset
    IF RST = '0' THEN
        A_temp      <= (others => '0');
        B_temp      <= (others => '0');
        Result_temp <= (others => '0');

        Ready   <= '0';
        Busy    <= '0';
        Count   <= 0;

    ELSIF rising_edge(CLK) THEN 
        IF En = '1' THEN 
            A_temp(N-1 downto 0) <= A; A_temp(2*N-1 downto N)  <= (others => '0');
            B_temp(N-1 downto 0) <= B; A_temp(2*N-1 downto N)  <= (others => '0');
            Result_temp <= (others => '0');

            Count   <= 0;            
            Ready   <= '0';
            Busy    <= '1';

        ELSIF (Count < N+1) THEN
            -- Add
            IF B_temp(0) = '1' THEN
                Result_temp <= Result_temp + A_temp;
            ELSE
                Result_temp <= Result_temp;
            END IF;

            -- Inc Counter & Raise flags
            IF Count = N THEN
                Ready   <= '1';
                Busy    <= '0';
                Result <= Result_temp;
            ELSE
                -- Shift
                B_temp <= '0' & B_temp(2*N-1 downto 1);     --Shifting Multiplier   right >>>
                A_temp <= A_temp(2*N-2 downto 0) & '0';     --Shifting Multiplicant left  <<<

                Ready   <= '0';
                Busy    <= '1';
                Count   <= Count + 1;  
            END IF;
        END IF;
    END IF;
   END  PROCESS Main;
END ARCHITECTURE behav;



