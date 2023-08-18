library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

---------------------------------
---------------------------------
---------------------------------

-- TB Entity
ENTITY SignedDivisionComb_test IS GENERIC(N : integer := 4);
END ENTITY SignedDivisionComb_test;

-- TB Archs.
----------------------------
------- Assertions ---------
----------------------------
ARCHITECTURE testbench_SignedDivisionComb_assertions OF SignedDivisionComb_test IS
   -- component
   component SignedDivisionComb IS GENERIC(N : integer := 4);
    PORT(
            Q, M    : IN  SIGNED(N-1 DOWNTO 0);
            QO, R   : OUT SIGNED(N-1 DOWNTO 0);
            ERROR   : OUT STD_LOGIC
            ); 
   END component SignedDivisionComb;

   -- Needed signals

   SIGNAL Q_Signal:    SIGNED(N-1 DOWNTO 0);
   SIGNAL M_Signal:    SIGNED(N-1 DOWNTO 0);

   SIGNAL QO_Signal:   SIGNED(N-1 DOWNTO 0);
   SIGNAL R_Signal:    SIGNED(N-1 DOWNTO 0);
   SIGNAL E_Signal:    STD_LOGIC;

 BEGIN
    -- Port Map
    DUT:  SignedDivisionComb GENERIC MAP (N => 4) PORT MAP(Q_Signal,M_Signal,QO_Signal,R_Signal,E_Signal);

----------------------------------
----------------------------------
    -- Stim. Process
    Stimulus: PROCESS BEGIN
    -------------------
    -- Range
    -- -2^n-1 (-8) -> -2^n-1 -1 (7)

    -- CASE 1: 4/2     + +
    Q_Signal <= "0100";
    M_Signal <= "0010";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0010") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 1: Test Passed"
    SEVERITY note;

    -- CASE 2: -8/2     - +
    Q_Signal <= "1000";
    M_Signal <= "0010";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "1100") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 2: Test Passed"
    SEVERITY note;

    -- CASE 3: -4/-6     - -
    Q_Signal <= "1100";
    M_Signal <= "1010";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "1100") and (E_Signal = '0')) 
    REPORT "CASE 3: Test Passed"
    SEVERITY note;

    -- CASE 4: 6/-2     + -
    Q_Signal <= "0110";
    M_Signal <= "1110";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "1101") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 4: Test Passed"
    SEVERITY note;

    -- CASE 5: -4/0     Div by 0
    Q_Signal <= "1100";
    M_Signal <= "0000";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0000") and (E_Signal = '1')) 
    REPORT "CASE 5: Test Passed"
    SEVERITY note;

    -- CASE 6: 0/0     
    Q_Signal <= "0000";
    M_Signal <= "0000";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0000") and (E_Signal = '1')) 
    REPORT "CASE 6: Test Passed"
    SEVERITY note;

    -- CASE 7: 5/2     remainder
    Q_Signal <= "0101";
    M_Signal <= "0010";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0010") and (R_Signal = "0001") and (E_Signal = '0')) 
    REPORT "CASE 7: Test Passed"
    SEVERITY note;

    -- CASE 8: 5/1    div by 1
    Q_Signal <= "0101";
    M_Signal <= "0001";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0101") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 8: Test Passed"
    SEVERITY note;

    -- CASE 9: 5/5    div num by itself
    Q_Signal <= "0101";
    M_Signal <= "0101";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0001") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 9: Test Passed"
    SEVERITY note;

    -- CASE 10: -13/-13    div -ve num by itself
    Q_Signal <= "1101";
    M_Signal <= "1101";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0001") and (R_Signal = "0000") and (E_Signal = '0')) 
    REPORT "CASE 10: Test Passed"
    SEVERITY note;

--     -- CASE 11: x/x  
--     Q_Signal <= "XXXX";
--     M_Signal <= "XXXX";
--     wait for 5 ns;
--     -- Check 
--    ASSERT NOT ((QO_Signal = "0001") and (R_Signal = "XXXX") and (E_Signal = '0')) 
--     REPORT "CASE 11: Test Passed"
--     SEVERITY note;

    -- CASE 12: x/0  
    Q_Signal <= "XXXX";
    M_Signal <= "0000";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0000") and (E_Signal = '1')) 
    REPORT "CASE 12: Test Passed"
    SEVERITY note;

    -- CASE 13: 5/x  
    Q_Signal <= "0101";
    M_Signal <= "XXXX";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0101") and (E_Signal = '0')) 
    REPORT "CASE 13: Test Passed"
    SEVERITY note;


--     -- CASE 14: U/U 
--     Q_Signal <= "UUUU";
--     M_Signal <= "UUUU";
--     wait for 5 ns;
--     -- Check 
--    ASSERT NOT ((QO_Signal = "0000") and (R_Signal == "UUUU") and (E_Signal = '0')) 
--     REPORT "CASE 14: Test Passed"
--     SEVERITY note;

    -- CASE 15: U/0  
    Q_Signal <= "UUUU";
    M_Signal <= "0000";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0000") and (E_Signal = '1')) 
    REPORT "CASE 15: Test Passed"
    SEVERITY note;

    -- CASE 16: 5/U 
    Q_Signal <= "0101";
    M_Signal <= "UUUU";
    wait for 5 ns;
    -- Check 
   ASSERT NOT ((QO_Signal = "0000") and (R_Signal = "0101") and (E_Signal = '0')) 
    REPORT "CASE 16: Test Passed"
    SEVERITY note;

   -----------------
   -- Test Completed
   wait;
   END PROCESS Stimulus;   
  
END ARCHITECTURE testbench_SignedDivisionComb_assertions;

----------------------------
---------- FILE ------------
----------------------------
ARCHITECTURE testbench_SignedDivisionComb_file OF SignedDivisionComb_test IS
   -- component
   component SignedDivisionComb IS GENERIC(N : integer := 4);
    PORT(
            Q, M    : IN  SIGNED(N-1 DOWNTO 0);
            QO, R   : OUT SIGNED(N-1 DOWNTO 0);
            ERROR   : OUT STD_LOGIC
            ); 
   END component SignedDivisionComb;

   -- Needed signals

   SIGNAL Q_Signal:    SIGNED(N-1 DOWNTO 0);
   SIGNAL M_Signal:    SIGNED(N-1 DOWNTO 0);

   SIGNAL QO_Signal:   SIGNED(N-1 DOWNTO 0);
   SIGNAL R_Signal:    SIGNED(N-1 DOWNTO 0);
   SIGNAL E_Signal:    STD_LOGIC;

 BEGIN
    -- Port Map
    DUT:  SignedDivisionComb GENERIC MAP (N => 4) PORT MAP(Q_Signal,M_Signal,QO_Signal,R_Signal,E_Signal);

----------------------------------
----------------------------------
    -- Stim. Process
    Stimulus: PROCESS IS
    -------------------
    FILE i_file: text OPEN READ_MODE IS "test.txt";   
    FILE r_file: text OPEN WRITE_MODE IS "results.txt";
 
     -- Needed vars.
    VARIABLE in_l,r_l: line;    
    VARIABLE qf: signed(N-1 DOWNTO 0);
    VARIABLE mf: signed(N-1 DOWNTO 0);  
    VARIABLE qof: signed(N-1 DOWNTO 0);
    VARIABLE rf: signed(N-1 DOWNTO 0);  
    VARIABLE ef: STD_LOGIC;

    BEGIN     
    WHILE NOT endfile (i_file) LOOP
     -- 
         READLINE (i_file, in_l);      
         READ (in_l, qf);         
         READ (in_l, mf);           
         READ (in_l, qof);         
         READ (in_l, rf);  
         READ (in_l, ef);         
         
     -- Driving Signals
        Q_Signal <= qf;
        M_Signal <= mf;
        wait for 5 ns;
     
     -- Writing results into the Results file
         WRITE (r_l, string'("Result = ")); 			
         WRITE (r_l, QO_Signal & R_Signal);

         WRITE (r_l, string'(", Error = ")); 			
         WRITE (r_l, E_Signal);

         WRITE (r_l, string'(", Expected Result = ")); 
         WRITE (r_l, qof & rf);

         WRITE (r_l, string'(", Expected Error = ")); 			
         WRITE (r_l, ef);
 
     -- Comparing Results and Writing into Results file
         -- Comparing
         IF ((qof /= QO_Signal) or (rf /= R_Signal) or (ef /= E_Signal)) THEN
             WRITE (r_l, string'(". ->> Test failed!, DUT output does not match."));
         ELSE
             WRITE (r_l, string'(". ->> Test passed."));
         END IF;
 
             -- Writing 
         WRITELINE (r_file, r_l); 
    END LOOP;

   -----------------
   -- Test Completed
   wait;
   END PROCESS Stimulus;   
  
END ARCHITECTURE testbench_SignedDivisionComb_file;

