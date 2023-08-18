library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
---------------------------------
---------------------------------
---------------------------------
-- TB Entity
ENTITY TopTB IS GENERIC (N : INTEGER := 4);
END ENTITY;

-- TB Archs.
----------------------------
------ Comparison TB -------
----------------------------
ARCHITECTURE TopComparisonFilesTB OF TopTB IS
-- components
component Top IS GENERIC(N : integer := 4);
    port(
        a,b:                in signed(n-1 downto 0);
        clk,rst_n,start,s:  in std_logic;
        m,r:                out signed(n-1 downto 0);
        busy,valid,err:     out std_logic
    );
END COMPONENT Top;

   -- Needed signals
   SIGNAL A_Signal, B_Signal :        SIGNED (N-1 DOWNTO 0);
   SIGNAL CLK_Signal, RST_Signal, Sel_Signal,ENABLE_Signal :    STD_LOGIC;

    -- Comb Outs
   SIGNAL BUSY_Signal, VALID_Signal, Erorr_Signal : STD_LOGIC;
   SIGNAL M_Signal, R_Signal :   SIGNED (N-1 DOWNTO 0);

    -- Seq Outs
    SIGNAL BUSY1_Signal, VALID1_Signal, Erorr1_Signal : STD_LOGIC;
    SIGNAL M1_Signal, R1_Signal :   SIGNED (N-1 DOWNTO 0);

 BEGIN
    -- Port Map
    DUT_Comb:  Top PORT MAP (A_Signal, B_Signal, CLK_Signal , RST_Signal, ENABLE_Signal, Sel_Signal, M_Signal, R_Signal, BUSY_Signal, VALID_Signal,Erorr_Signal);
    DUT_Seq :  Top PORT MAP (A_Signal, B_Signal, CLK_Signal , RST_Signal, ENABLE_Signal, Sel_Signal, M1_Signal, R1_Signal, BUSY1_Signal, VALID1_Signal,Erorr1_Signal);

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
    FILE i_file: text OPEN READ_MODE IS "top_test.txt";   
    FILE r_file: text OPEN WRITE_MODE IS "top_results.txt";
 
     -- Needed vars.
    VARIABLE in_l,r_l: line; 
    -- Inputs    
    VARIABLE af: signed(N-1 DOWNTO 0);
    VARIABLE bf: signed(N-1 DOWNTO 0); 
    VARIABLE self: STD_LOGIC;

    BEGIN     
    -- RESET
    A_Signal <= (OTHERS => '0');
    B_Signal <= (OTHERS => '0');
    Sel_Signal <= '1';

    ENABLE_Signal <= '0';
    RST_Signal <= '0';
    wait for 150 ps; -- Zero for 1.5 Cycles
    RST_Signal <= '1';

    WHILE NOT endfile (i_file) LOOP
     -- 
         READLINE (i_file, in_l);      
         READ (in_l, af);         
         READ (in_l, bf);           
         READ (in_l, self);       

        -- Driving Signals
        A_Signal <= af;
        B_Signal <= bf;
        Sel_Signal <= self;

        ENABLE_Signal <= '1';
        wait for 100 ps;
        ENABLE_Signal <= '0';
        wait for 450 PS; 
     
     -- Writing results into the Results file
         WRITE (r_l, string'("Comb. Result = ")); 			
         WRITE (r_l, M_Signal & R_Signal);

         WRITE (r_l, string'(", Seq. Result = ")); 			
         WRITE (r_l, M1_Signal & R1_Signal);

 
     -- Comparing Results and Writing into Results file
         -- Comparing
         IF (((M_Signal & R_Signal) /= M1_Signal & R1_Signal) or (Erorr1_Signal /= Erorr_Signal)) THEN
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
  
END ARCHITECTURE TopComparisonFilesTB;

----------------------------
------ Comparison TB -------
----------------------------
ARCHITECTURE TopComparisonFilesTB2 OF TopTB IS
-- components
component Top IS GENERIC(N : integer := 4);
    port(
        a,b:                in signed(n-1 downto 0);
        clk,rst_n,start,s:  in std_logic;
        m,r:                out signed(n-1 downto 0);
        busy,valid,err:     out std_logic
    );
END COMPONENT Top;

   -- Needed signals
   SIGNAL A_Signal, B_Signal :        SIGNED (N-1 DOWNTO 0);
   SIGNAL CLK_Signal, RST_Signal, Sel_Signal,ENABLE_Signal :    STD_LOGIC;

    -- Comb Outs
   SIGNAL BUSY_Signal, VALID_Signal, Erorr_Signal : STD_LOGIC;
   SIGNAL M_Signal, R_Signal :   SIGNED (N-1 DOWNTO 0);


 BEGIN
    -- Port Map
    DUT_Comb:  Top PORT MAP (A_Signal, B_Signal, CLK_Signal , RST_Signal, ENABLE_Signal, Sel_Signal, M_Signal, R_Signal, BUSY_Signal, VALID_Signal,Erorr_Signal);
    DUT_Seq :  Top PORT MAP (A_Signal, B_Signal, CLK_Signal , RST_Signal, ENABLE_Signal, Sel_Signal, M_Signal, R_Signal, BUSY_Signal, VALID_Signal,Erorr_Signal);

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
    FILE i_file: text OPEN READ_MODE IS "top_test2.txt";   
    FILE r_file: text OPEN WRITE_MODE IS "top_results2.txt";
 
     -- Needed vars.
    VARIABLE in_l,r_l: line; 
    -- Inputs    
    VARIABLE archf: STD_LOGIC;  -- 0 for combinational / 1 for sequential
    VARIABLE af: signed(N-1 DOWNTO 0);
    VARIABLE bf: signed(N-1 DOWNTO 0); 
    VARIABLE self: STD_LOGIC;

    -- Expected outputs
    VARIABLE errorf: STD_LOGIC;
    VARIABLE resultf: signed(2*N-1 DOWNTO 0);

    -- Counter
    VARIABLE SUCC_CNT        : NATURAL RANGE 0 TO 100 := 0;
    VARIABLE CNT        : NATURAL RANGE 0 TO 100 := 0;

    BEGIN     
    -- RESET
    A_Signal <= (OTHERS => '0');
    B_Signal <= (OTHERS => '0');
    Sel_Signal <= '1';

    ENABLE_Signal <= '0';
    RST_Signal <= '0';
    wait for 150 ps; -- Zero for 1.5 Cycles
    RST_Signal <= '1';

    WHILE NOT endfile (i_file) LOOP
     -- 
         CNT := CNT + 1;

         READLINE (i_file, in_l); 
         READ (in_l, archf);         
         READ (in_l, af);         
         READ (in_l, bf);           
         READ (in_l, self);       
         READ (in_l, errorf);           
         READ (in_l, resultf); 

        -- Driving Signals
        A_Signal <= af;
        B_Signal <= bf;
        Sel_Signal <= self;

        ENABLE_Signal <= '1';
        wait for 100 ps;
        ENABLE_Signal <= '0';
        wait for 450 PS; 

 
     -- Comparing Results and Writing into Results file
         -- Comparing
         IF (((M_Signal & R_Signal) /= resultf) or (Erorr_Signal /= errorf)) THEN
             WRITE (r_l, string'(". ->> Test failed!, DUT output does not match."));
         ELSE
             WRITE (r_l, string'(". ->> Test passed."));
             SUCC_CNT := SUCC_CNT + 1;
         END IF;
 
             -- Writing 
         WRITELINE (r_file, r_l);
         
         -- wait next edge
         wait for 50 ps;
    END LOOP;

    WRITE (r_l, string'("Success Ratio = ")); 			
    WRITE (r_l, SUCC_CNT);
    WRITE (r_l, string'(" / ")); 			
    WRITE (r_l, CNT);

    WRITELINE (r_file, r_l);


   -----------------
   -- Test Completed
   wait;
   END PROCESS Stimulus;   
  
END ARCHITECTURE TopComparisonFilesTB2;
          
          
        
        
      
  

