library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mul is 
generic (n:integer:=4);
  port (
    a,b: in signed(n-1 downto 0);
    M, R: out signed(n-1 downto 0)
       );
end entity mul;
architecture bhv of mul is
signal b_in,a_in:signed(n-1 downto 0);
signal c_out:signed(2*n-1 downto 0);
begin
  a_in <= -a when a(n-1) = '1' else
        a;

  b_in <= -b when b(n-1) = '1' else
        b ;

  R <= -c_out(2*n-1 DOWNTO n) when (b(n-1) xor a(n-1)) = '1'else
        c_out(2*n-1 DOWNTO n);
        
  M <= -c_out(n-1 DOWNTO 0) when (b(n-1) xor a(n-1)) = '1'else
        c_out(n-1 DOWNTO 0);
  mul:process (a_in,b_in,c_out) is
  variable temp : signed(2*n-1 downto 0);
variable psum:signed(2*n-1 downto 0);

  begin
    psum:=(others=>'0');
    temp:=(2*n-1 downto n =>'0')&a_in;
    for i in b'range loop
      if b_in(i) = '1' then
        psum := psum + shift_left(temp,i);
      end if;
    end loop;
    c_out <= psum;
  end process mul;
end architecture bhv;

