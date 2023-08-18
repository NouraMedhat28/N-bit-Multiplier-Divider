library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MULSEQ IS 
  GENERIC (
    N : INTEGER := 4
  );
  PORT (Q, M : IN SIGNED (N-1 DOWNTO 0);
        ENABLE,CLK, RST : IN STD_LOGIC;
        BUSY, VALID : OUT STD_LOGIC;
        MSB, LSB : OUT SIGNED (N-1 DOWNTO 0));
      END ENTITY;
      
ARCHITECTURE MULBEHAV OF MULSEQ IS
    SIGNAL CNT        : NATURAL RANGE 0 TO N;
    
    BEGIN

    PROCESS (CLK, RST) IS
      VARIABLE A   : SIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE QP  : SIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE Q_1 : STD_LOGIC := '0';
      VARIABLE ACC : SIGNED(2*N DOWNTO 0) := (OTHERS => '0');
    BEGIN 
      
      IF (RST = '0') THEN
        QP := (OTHERS => '0');
        A := (OTHERS => '0');
        MSB <= (OTHERS => '0');
        LSB <= (OTHERS => '0');
        Q_1 := '0';
        BUSY <= '0';
        VALID <= '0';
        CNT <= 0;
        
      ELSIF (RISING_EDGE(CLK) AND ENABLE = '1') THEN 
        QP := Q;
        MSB <= (OTHERS => '0');
        LSB <= (OTHERS => '0');
        Q_1 := '0';
        A := (OTHERS => '0');
        BUSY <= '1';
        VALID <= '0';
        CNT <= 0;

      ELSIF (RISING_EDGE(CLK) AND ENABLE = '0' AND CNT < N) THEN
       -- report("INSIDE, COUNT = " & integer'image(CNT));

        ACC := A & QP & Q_1;
        CASE (ACC(1 DOWNTO 0)) IS
          WHEN "00" | "11" =>
            ACC := ACC SRA 1;
            A := ACC (2*N DOWNTO N+1);
            QP := ACC(N DOWNTO 1);
            Q_1 := ACC(0);
            MSB <= ACC(2*N DOWNTO N+1);
            LSB <= ACC(N DOWNTO 1);
          WHEN "01" =>
            A := A + M;
            ACC (2*N DOWNTO N+1) := A;
            ACC := ACC SRA 1;
            A := ACC (2*N DOWNTO N+1);
            QP := ACC(N DOWNTO 1);
            Q_1 := ACC(0);
            MSB <= ACC(2*N DOWNTO N+1);
            LSB <= ACC(N DOWNTO 1);
          WHEN OTHERS =>
            A := A - M;
            ACC (2*N DOWNTO N+1) := A;
            ACC := ACC SRA 1;
            A := ACC (2*N DOWNTO N+1);
            QP := ACC(N DOWNTO 1);
            Q_1 := ACC(0);
            MSB <= ACC(2*N DOWNTO N+1);
            LSB <= ACC(N DOWNTO 1);
          END CASE;

          IF (CNT = N-1) THEN
            MSB <= ACC(2*N DOWNTO N+1);
            LSB <= ACC(N DOWNTO 1);
            BUSY <= '0';
            VALID <= '1';
            QP := (OTHERS => '0');
            A := (OTHERS => '0');
            
          ELSE 
            BUSY <= '1';
            VALID <= '0';
            MSB <= MSB;
            LSB <= LSB;
            BUSY <= BUSY;
            VALID <= VALID;
            QP := QP;
            A := A;
            ACC := ACC;
          END IF;

          --INC Counter
          CNT <= CNT + 1;

    ELSE 
      MSB <= MSB;
      LSB <= LSB;
      BUSY <= BUSY;
      VALID <= VALID;
      QP := QP;
      A := A;
      ACC := ACC;
    END IF;
  END PROCESS;
END ARCHITECTURE;
      
        
        

