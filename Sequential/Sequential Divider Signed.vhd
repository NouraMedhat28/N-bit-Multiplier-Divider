library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity divider_seq is
generic(n:integer:=4);
port (
    a_in,b_in:in signed(n-1 downto 0);
    clk,rst_n,start:in std_logic;
    c,f:out signed(n-1 downto 0);
    busy,valid,err:out std_logic
);
end divider_seq;

architecture behv of divider_seq is
signal a,b: signed(n-1 downto 0);

begin 
    process(a_in,b_in) is
    begin 
        if a_in(n-1) = '1' then
            a <= -a_in;
        else
            a<= a_in;
        end if;
        if b_in(n-1) = '1' then
            b<=-b_in;
        else
            b<=b_in;
        end if;
        
    end process;


    divider:process(clk,rst_n)
        variable r: signed(2*n-1 downto 0);
        variable d: signed(2*n-1 downto 0);
        variable q: signed(n-1 downto 0);
        variable counter:integer range n downto 0;
    begin
        if rst_n = '0' then
            counter := 0;
            r:= (others=>'0');
            q := (others=>'0');
            d := (others=>'0');
            f <= (others=>'0');
            c <= (others=>'0');
            valid <='0';
            busy <='0';
            err <='0';

        elsif rising_edge(clk)  then
            if start = '1' and counter = 0 then
                    if b_in = (n-1 downto 0 =>'0') then
                        err<='1';
                        valid<='0';
                        busy<='0';
                        counter := 0;
                    else
                        counter := n;
                        r := (2*n-1 downto n=>'0') & a;
                        d := b & (n-1 downto 0 => '0');
                        busy<='1';
                        err <= '0';
                        valid<='0';
			        end if;
		    end if;
            if start = '0' and counter = 0 then
                valid <= '0';
                busy <='0';
                err<='0';
            end if;
            if counter > 0 then
                counter := counter - 1;
                r := shift_left(r,1) - d;
                if r >= 0 then
                    q(counter) := '1';
                else
                    q(counter) := '0';
                    r := r + d;
                end if;
                if counter = 0 then
                    if (a_in(n-1) xor b_in(n-1)) = '1' then 
                        c<= -q;
                    else
                        c<= q; 
                    end if;

                    if a_in(n-1) = '1' then
                        f <= -r(2*n-1 downto n); 
                    else
                        f <= r(2*n-1 downto n); 
                    end if;
                    busy<='0';
                    valid <= '1';
                end if;
            end if;
        end if;
    end process divider;
end behv;

