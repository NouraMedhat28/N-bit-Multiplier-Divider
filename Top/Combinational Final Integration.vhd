library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY COMBINTEGRATION IS
  GENERIC (
    N : INTEGER := 4
  );
  PORT ( A, B : IN SIGNED (N-1 DOWNTO 0);
         S : IN STD_LOGIC; -- 0 Divider / 1 Multiplier
         M, R : OUT SIGNED (N-1 DOWNTO 0);
         ERROR : OUT STD_LOGIC
       );
     END ENTITY;
     
ARCHITECTURE COMBINTARC OF COMBINTEGRATION IS
  SIGNAL MD, RD, MM, RM : SIGNED (N-1 DOWNTO 0);
  SIGNAL ERROR_INT : STD_LOGIC;
  
  -- DIVIDER
  COMPONENT SignedDivisionComb IS
  GENERIC (
    N : INTEGER := 4
  );
    PORT (
        Q, M : IN  SIGNED(N-1 DOWNTO 0);
        QO, R  : OUT SIGNED(N-1 DOWNTO 0);
        ERROR : OUT STD_LOGIC
    );
END COMPONENT SignedDivisionComb;

-- MULTIPLIER
COMPONENT mul is 
generic (n:integer:=4);
  port (
    a,b: in signed(n-1 downto 0);
    M, R: out signed(n-1 downto 0)
       );
end COMPONENT mul;

FOR COMBDIV : SignedDivisionComb
  USE ENTITY WORK.SignedDivisionComb(SignedDivCombBehave);
  
FOR COMBMUL : mul
USE ENTITY WORK.mul(bhv);
  
BEGIN
  
  -- DIVIDER PORT MAPPING
  COMBDIV : SignedDivisionComb
  PORT MAP(A, B, MD, RD, ERROR_INT);
  
  -- MULTIPLIER PORT MAPPING
  COMBMUL : mul
  PORT MAP (A, B, MM, RM);
    
    -- SELECTING THE OUTPUT BASED ON THE CHOSEN OPERATION
    M <= MD WHEN  S<= '0' ELSE MM;
       
    R <= RD WHEN  S<= '0' ELSE RM;
         
    ERROR <= ERROR_INT WHEN  S<= '0' ELSE '0';  
  
END ARCHITECTURE;



  


