library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- RESTORING DIVISION ALGORITHM FOR SIGNED NUMBERS
ENTITY SignedDivisionComb IS
  GENERIC (
    N : INTEGER := 4
  );
    PORT (
        Q, M : IN  SIGNED(N-1 DOWNTO 0);
        QO, R  : OUT SIGNED(N-1 DOWNTO 0);
        ERROR : OUT STD_LOGIC
    );
END ENTITY SignedDivisionComb;

ARCHITECTURE SignedDivCombBehave OF SignedDivisionComb IS
BEGIN

PROCESS (Q, M) IS
        VARIABLE A: SIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
        VARIABLE QP  : SIGNED(N-1 DOWNTO 0);
        VARIABLE ONES : SIGNED (N-1 DOWNTO 0) := (OTHERS => '1');
        VARIABLE ZEROS : SIGNED (N-1 DOWNTO 0) := (OTHERS => '0');
        VARIABLE ACC : SIGNED(2*N-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
  -- INITIALIZATIONS
  QP := Q;
  A := (OTHERS => '0');
  ACC := (OTHERS => '0');
  QO <= (OTHERS => '0');
  R <= (OTHERS => '0');
  ERROR <= '0';
  
  -- DIVISION BY ZERO
  IF (M = ZEROS) THEN 
    ERROR <= '1';
    QO <= (OTHERS => '0');
    R <= (OTHERS => '0');
    
  ELSE 
  -- LOADING
  QP := Q;
  
       -- EXTENDING THE SIGN
       IF (QP(N-1) = '1') THEN
         A := ONES;
       ELSE
         A := ZEROS;
       END IF;
        ACC := A & QP;
        QO <= ACC(N-1 DOWNTO 0);
        R <= ACC (2*N-1 DOWNTO N);


     
FOR I IN Q'RANGE LOOP
         ACC := ACC SLL 1;
                
         -- UPDATING A AND Q AFTER SHIFTING
         QP := ACC(N-1 DOWNTO 0);
         A := ACC (2*N-1 DOWNTO N);
         -- SUBTRACTING M FROM A
         
         IF (A(N-1) = M(N-1)) THEN
           A := A - M;
         ELSE
           A := A + M;
         END IF;
        
         -- CHECKING FOR THE SIGN OF "A" KNOWING THAT THE OLD VALUE OF "A" IS 
         -- STILL IN THE ACCUMULATOR AS THE SUBTRACTION WAS DONE DIRECTLY ON "A"
       IF(ACC(2*N-1) = A(N-1) OR A = ZEROS OR Q = ZEROS)  THEN
         ACC (2*N-1 DOWNTO N) := A;
         QP(0) := '1';
       ELSE
         A := ACC (2*N-1 DOWNTO N); -- RESTORING A
         QP(0) := '0';
       END IF;
       ACC := A & QP;
END LOOP;


 -- CORRECTION
     IF (Q(N-1) = M(N-1)) THEN 
      QO <= ACC(N-1 DOWNTO 0);
      R <= ACC (2*N-1 DOWNTO N);
     ELSE 
      QP := NOT(QP) + 1;
      QO <= QP;
      R <= ACC (2*N-1 DOWNTO N);
 END IF;
 ERROR <= '0';
 END IF;
END PROCESS;
END ARCHITECTURE;


