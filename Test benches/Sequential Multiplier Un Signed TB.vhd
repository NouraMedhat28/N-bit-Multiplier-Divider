-- Including Libs.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

---------------------------------
---------------------------------
---------------------------------

-- TB Entity
ENTITY SeqMulti_test IS GENERIC(N : integer := 4);
END ENTITY SeqMulti_test;

-- TB Archs.
----------------------------
------- Assertions ---------
----------------------------
ARCHITECTURE testbench_SeqMulti_assertions OF SeqMulti_test IS
   -- component
   component SeqMulti IS GENERIC(N : integer := 4);
    PORT(       CLK:    IN std_logic;
                RST:    IN std_logic;
                En:     IN std_logic;
                A:      IN std_logic_vector(N-1 downto 0);
                B:      IN std_logic_vector(N-1 downto 0);

                Busy:   OUT std_logic;
                Ready:  OUT std_logic;
                Result: OUT std_logic_vector(2*N-1 downto 0)
            ); 
   END component SeqMulti;

   -- Needed signals

   SIGNAL CLK_Signal:   std_logic;
   SIGNAL RST_Signal:   std_logic;
   SIGNAL En_Signal:    std_logic;
   SIGNAL A_Signal:     std_logic_vector(N-1 downto 0);
   SIGNAL B_Signal:     std_logic_vector(N-1 downto 0);

   SIGNAL Busy_Signal:      std_logic;
   SIGNAL Ready_Signal:     std_logic;
   SIGNAL Result_Signal:    std_logic_vector(2*N-1 downto 0);

 BEGIN
    -- Port Map
    DUT:  SeqMulti GENERIC MAP (N => 4) PORT MAP(CLK_Signal,RST_Signal,En_Signal,A_Signal,B_Signal,Busy_Signal,Ready_Signal,Result_Signal);

----------------------------------
----------------------------------
    -- GENERATING CLOCK
    CLKP : PROCESS IS
    BEGIN
        CLK_Signal <= '1';
        WAIT FOR 50 PS;
        CLK_Signal <= '0';
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
    VARIABLE qf: std_logic_vector(N-1 DOWNTO 0);
    VARIABLE mf: std_logic_vector(N-1 DOWNTO 0);  
    -- Expected outputs
    VARIABLE bf: STD_LOGIC;
    VARIABLE vf: STD_LOGIC;
    VARIABLE resultf: std_logic_vector(2*N-1 DOWNTO 0);

    BEGIN     
    -- RESET
    A_Signal <= (OTHERS => '0');
    B_Signal <= (OTHERS => '0');
    En_Signal <= '0';
    RST_Signal <= '0';
    wait for 150 ps; -- Zero for 1.5 Cycles
    RST_Signal <= '1';

    WHILE NOT endfile (i_file) LOOP
     -- 
         READLINE (i_file, in_l);      
         READ (in_l, qf);         
         READ (in_l, mf);           
         READ (in_l, bf);  
         READ (in_l, vf);         
         READ (in_l, resultf);         

     -- Driving Signals
        A_Signal <= qf;
        B_Signal <= mf;
        En_Signal <= '1';
        wait for 100 ps;
        En_Signal <= '0';
        wait for 550 PS; 
     
     -- Writing results into the Results file
         WRITE (r_l, string'("Result = ")); 			
         WRITE (r_l, Result_Signal);

         WRITE (r_l, string'(", BUSY = ")); 			
         WRITE (r_l, Busy_Signal);

         WRITE (r_l, string'(", VALID = ")); 			
         WRITE (r_l, Ready_Signal);


         WRITE (r_l, string'(", Expected Result = ")); 
         WRITE (r_l, resultf);

         WRITE (r_l, string'(", Expected BUSY = ")); 			
         WRITE (r_l, bf);

         WRITE (r_l, string'(", Expected VALID = ")); 			
         WRITE (r_l, vf);

 
     -- Comparing Results and Writing into Results file
         -- Comparing
         IF ((Result_Signal /= resultf) or (Busy_Signal /= bf) or (Ready_Signal /= vf)) THEN
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
  
END ARCHITECTURE testbench_SeqMulti_assertions;