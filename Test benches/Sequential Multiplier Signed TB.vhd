library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

ENTITY MULSEQTB IS
  GENERIC (
    N : INTEGER := 4
  );
END ENTITY;

ARCHITECTURE MULSEQ_ASSERTIONS OF MULSEQTB IS
  COMPONENT MULSEQ IS 
  GENERIC (
    N : INTEGER := 4
  );
  PORT (Q, M : IN SIGNED (N-1 DOWNTO 0);
        ENABLE, CLK, RST : IN STD_LOGIC;
        BUSY, VALID : OUT STD_LOGIC;
        MSB, LSB : OUT SIGNED (N-1 DOWNTO 0));
      END COMPONENT MULSEQ;
      
      SIGNAL Q, M : SIGNED (N-1 DOWNTO 0);
      SIGNAL CLK, RST :  STD_LOGIC;
      SIGNAL ENABLE, BUSY, VALID : STD_LOGIC;
      SIGNAL  MSB, LSB :  SIGNED (N-1 DOWNTO 0);
            
      BEGIN
        
        -- INSTANTIATION
        DUT1 : MULSEQ PORT MAP (Q, M, ENABLE, CLK, RST, BUSY, VALID, MSB, LSB);
          
          -- GENERATING CLOCK
          CLKP : PROCESS IS
          BEGIN
            CLK <= '1';
            WAIT FOR 50 PS;
            CLK <= '0';
            WAIT FOR 50 PS;
          END PROCESS CLKP;
        
        -- TEST CASES
        TC : PROCESS IS
        BEGIN
          
          -- TC1 : RESET
          M <= "1010"; -- "-6"
          Q <= "0101"; -- "5"
          RST <= '0';
          ENABLE <= '0';
          REPORT ("1st TC : RESET");
          WAIT FOR 150 PS;
          
          -- TC2 : +ve Q "5"  AND -ve M "-6"
          RST <= '1';
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;
          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "1110" AND LSB = "0010") 
          REPORT ("2nd TC : +ve Q 5  AND -ve M -6 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "1110" AND LSB = "0010") 
          REPORT ("2nd TC : +ve Q 5  AND -ve M -6 PASSED!!")
          SEVERITY NOTE;
          
          -- TC3 : -ve Q "-7"  AND +ve M "5"
          WAIT FOR 50 PS;
          M <= "0101"; -- "5"
          Q <= "1001"; -- "-7"
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;

          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "1101" AND LSB = "1101") 
          REPORT ("3rd TC : -ve Q -7  AND +ve M 5 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "1101" AND LSB = "1101") 
          REPORT ("3rd TC : -ve Q -7  AND +ve M 5 PASSED!!")
          SEVERITY NOTE;  
          
          -- TC4 : -ve Q "-4"  AND -ve M "-3"
          WAIT FOR 50 PS;
          M <= "1101"; -- "-3"
          Q <= "1100"; -- "-4"
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;
          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "0000" AND LSB = "1100") 
          REPORT ("4th TC : -ve Q -4  AND -ve M -3 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "0000" AND LSB = "1100") 
          REPORT ("4th TC : -ve Q -4  AND -ve M -3 PASSED!!")
          SEVERITY NOTE;  
          
          -- TC5 : +ve Q "6"  AND +ve M "7"
          WAIT FOR 50 PS;
          M <= "0111"; -- "7"
          Q <= "0110"; -- "6"
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;
          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "0010" AND LSB = "1010") 
          REPORT ("5th TC : +ve Q 6  AND +ve M 7 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "0010" AND LSB = "1010") 
          REPORT ("5th TC : +ve Q 6  AND +ve M 7 PASSED!!")
          SEVERITY NOTE; 
          
          
          -- TC6 "LARGEST POSITIVE NUMBER" : +ve Q "7"  AND +ve M "7" 
          WAIT FOR 50 PS;
          M <= "0111"; -- "7"
          Q <= "0111"; -- "7"
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;
          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "0011" AND LSB = "0001") 
          REPORT ("6th TC : +ve Q 7  AND +ve M 7 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "0011" AND LSB = "0001") 
          REPORT ("6th TC : +ve Q 7  AND +ve M 7 PASSED!!")
          SEVERITY NOTE;  
          
          
          -- TC7 "LARGEST NEGATIVE NUMBER" : -ve Q "-8"  AND -ve M "-4" 
          WAIT FOR 50 PS;
          M <= "1100"; -- "-4"
          Q <= "1000"; -- "-8"
          ENABLE <= '1';
          wait for 100 ps;
          ENABLE <= '0';
          WAIT FOR 450 PS;
          ASSERT (BUSY = '0' AND VALID = '1' AND MSB = "0010" AND LSB = "0000") 
          REPORT ("7th TC : -ve Q -8  AND -ve M -4 FAILID!!")
          SEVERITY ERROR;
          
          ASSERT NOT(BUSY = '0' AND VALID = '1' AND MSB = "0010" AND LSB = "0000") 
          REPORT ("7th TC : -ve Q -8  AND -ve M -4 PASSED!!")
          SEVERITY NOTE;  
          WAIT;
        END PROCESS TC;
END ARCHITECTURE MULSEQ_ASSERTIONS;
          
----------------------------
---------- FILE ------------
----------------------------
ARCHITECTURE testbench_MULSEQ_file OF MULSEQTB IS
   -- component
    component MULSEQ IS GENERIC(N : integer := 4);
        PORT (  Q, M : IN SIGNED (N-1 DOWNTO 0);
                ENABLE, CLK, RST : IN STD_LOGIC;
                BUSY, VALID : OUT STD_LOGIC;
                MSB, LSB : OUT SIGNED (N-1 DOWNTO 0)
        );
    END COMPONENT MULSEQ;

   -- Needed signals

   SIGNAL Q, M :        SIGNED (N-1 DOWNTO 0);
   SIGNAL CLK, RST :    STD_LOGIC;
   SIGNAL ENABLE, BUSY, VALID : STD_LOGIC;
   SIGNAL  MSB, LSB :   SIGNED (N-1 DOWNTO 0);

 BEGIN
    -- Port Map
    DUT:  MULSEQ PORT MAP (Q, M, ENABLE, CLK, RST, BUSY, VALID, MSB, LSB);

----------------------------------
----------------------------------
    -- GENERATING CLOCK
    CLKP : PROCESS IS
    BEGIN
        CLK <= '1';
        WAIT FOR 50 PS;
        CLK <= '0';
        WAIT FOR 50 PS;
    END PROCESS CLKP;

    -- Stim. Process
    Stimulus: PROCESS IS
    -------------------
    FILE i_file: text OPEN READ_MODE IS "mul_test.txt";   
    FILE r_file: text OPEN WRITE_MODE IS "mul_results.txt";
 
     -- Needed vars.
    VARIABLE in_l,r_l: line; 
    -- Expected inputs    
    VARIABLE qf: signed(N-1 DOWNTO 0);
    VARIABLE mf: signed(N-1 DOWNTO 0);  
    -- Expected outputs
    VARIABLE bf: STD_LOGIC;
    VARIABLE vf: STD_LOGIC;
    VARIABLE resultf: signed(2*N-1 DOWNTO 0);

    BEGIN     
    -- RESET
    Q <= (OTHERS => '0');
    M <= (OTHERS => '0');
    ENABLE <= '0';
    RST <= '0';
    wait for 150 ps; -- Zero for 1.5 Cycles
    RST <= '1';

    WHILE NOT endfile (i_file) LOOP
     -- 
         READLINE (i_file, in_l);      
         READ (in_l, qf);         
         READ (in_l, mf);           
         READ (in_l, bf);  
         READ (in_l, vf);         
         READ (in_l, resultf);         

     -- Driving Signals
        Q <= qf;
        M <= mf;
        ENABLE <= '1';
        wait for 100 ps;
        ENABLE <= '0';
        wait for 450 PS; 
     
     -- Writing results into the Results file
         WRITE (r_l, string'("Result = ")); 			
         WRITE (r_l, MSB & LSB);

         WRITE (r_l, string'(", BUSY = ")); 			
         WRITE (r_l, BUSY);

         WRITE (r_l, string'(", VALID = ")); 			
         WRITE (r_l, VALID);


         WRITE (r_l, string'(", Expected Result = ")); 
         WRITE (r_l, resultf);

         WRITE (r_l, string'(", Expected BUSY = ")); 			
         WRITE (r_l, bf);

         WRITE (r_l, string'(", Expected VALID = ")); 			
         WRITE (r_l, vf);

 
     -- Comparing Results and Writing into Results file
         -- Comparing
         IF (((MSB & LSB) /= resultf) or (BUSY /= bf) or (VALID /= vf)) THEN
             WRITE (r_l, string'(". ->> Test failed!, DUT output does not match."));
         ELSE
             WRITE (r_l, string'(". ->> Test passed."));
         END IF;
 
             -- Writing 
         WRITELINE (r_file, r_l);
         
         -- wait next edge
         wait for 50 ps;
    END LOOP;

   -----------------
   -- Test Completed
   wait;
   END PROCESS Stimulus;   
  
END ARCHITECTURE testbench_MULSEQ_file;
          
        
        
      
  

