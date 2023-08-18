library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
generic(n:integer := 4);
port(
    a,b:in signed(n-1 downto 0);
    clk,rst_n,start,s:in std_logic;
    m,r:out signed(n-1 downto 0);
    busy,valid,err:out std_logic
);
end top;

architecture sequential of top is
signal qm,qd,rm,rd:signed(n-1 downto 0);
signal busyd,validd,validm,busym,startm,startd:std_logic;
signal ad,bd,am,bm: signed(n-1 downto 0);

----
COMPONENT divider_seq IS
GENERIC (N : INTEGER := 4);
port (
    a_in,b_in:in signed(n-1 downto 0);
    clk,rst_n,start:in std_logic;
    c,f:out signed(n-1 downto 0);
    busy,valid,err:out std_logic
);
END COMPONENT divider_seq;
----
COMPONENT mulseq IS
GENERIC (N : INTEGER := 4);
PORT (
    Q, M : IN SIGNED (N-1 DOWNTO 0);
    ENABLE,CLK, RST : IN STD_LOGIC;
    BUSY, VALID : OUT STD_LOGIC;
    MSB, LSB : OUT SIGNED (N-1 DOWNTO 0)
);
END COMPONENT mulseq;


begin
    div1: divider_seq
    generic map(n=>n)
    port map(
        a_in=>ad,
        b_in=>bd,
        clk=>clk,
        rst_n=>rst_n,
        start=>startd,
        c=>qd,
        f=>rd,
        busy=>busyd,
        valid=>validd,
        err=>err
    );

    mul1: mulseq
    generic map(n=>n)
    port map(
        q=>am,
        m=>bm,
        clk=>clk,
        rst=>rst_n,
        enable=>startm,
        msb=>qm,
        lsb=>rm,
        busy=>busym,
        valid=>validm
    );
    m<=qm when s='1' else qd;
    r<=rm when s='1' else rd;

    valid<= validm when s='1' else validd;
    busy<= busym when s='1' else busyd;

    startm<=start and s;
    startd<=start and (not s);

    am<=a and s;
    ad<=a and (not s);
    bm<=b and s;
    bd<=b and (not s);

end sequential;

architecture combinational of top is
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
  
BEGIN
  
  -- DIVIDER PORT MAPPING
  COMBDIV : SignedDivisionComb
  PORT MAP(A, B, MD, RD, ERROR_INT);
  
  -- MULTIPLIER PORT MAPPING
  COMBMUL : mul
  PORT MAP (A, B, RM, MM);
    
    -- SELECTING THE OUTPUT BASED ON THE CHOSEN OPERATION
    M <= MD WHEN  S<= '0' ELSE MM;
       
    R <= RD WHEN  S<= '0' ELSE RM;
         
    err <= ERROR_INT WHEN  S<= '0' ELSE '0';  
  
end combinational;