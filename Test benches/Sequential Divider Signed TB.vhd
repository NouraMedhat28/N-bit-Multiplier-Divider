library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity divider_seq_tb is
end divider_seq_tb;
architecture test of divider_seq_tb is
    file infile:text open read_mode is "./inputs.txt";
    file outfile:text open write_mode is "./outputs.txt";

    signal test_a,test_b,test_f,test_c:signed(3 downto 0);
    signal clk,rst_n,start,valid,err,busy:std_logic;

begin
    u1:entity work.divider_seq(behv)
    port map(
        clk=>clk,
        rst_n=>rst_n,
        start=>start,
        a_in=>test_a,
        b_in=>test_b,
        c=>test_c,
        f=>test_f,
        valid=>valid,
        err=>err,
        busy=>busy

    );
    clk_generation:process is
    begin 
        for i in 1 to 100 loop
            clk <= '0';
            wait for 50 ns;
            clk<='1';
            wait for 50 ns;
        end loop;
        wait;
    end process;
    reset_generation:process is
    begin
        rst_n <= '0';
        wait until falling_edge(clk);
        rst_n<='1';
        wait;
    end process;
    stimulus:process is
        variable l_in,l_out:line;
        variable space:character;
        variable test_a_f,test_b_f:std_logic_vector(3 downto 0);
    begin
        test_a<=(others=>'0');
        test_b<=(others=>'0');
        start<='0';
        wait until rising_edge(rst_n);
        while not endfile(infile) loop
            readline(infile,l_in);
            read(l_in,test_a_f);
            read(l_in,space);
            read(l_in,test_b_f);
            test_a<=signed(test_a_f);
            test_b<=signed(test_b_f);
            start<='1';
            wait until falling_edge(clk);
            start<='0';
            if err = '1' then
                write(l_out,string'("division by zero"));
                writeline(outfile,l_out);
                wait until rising_edge(clk);
            else
                wait until rising_edge(valid) ;
                write(l_out,std_logic_vector(test_c)); --quatient 
                write(l_out,space);
                write(l_out,std_logic_vector(test_f)); --reminder
                writeline(outfile,l_out);
            end if;
            wait until falling_edge(clk);
        end loop;
        wait;
    end process;
end test;