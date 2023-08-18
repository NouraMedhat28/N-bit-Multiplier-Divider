----------------------------
-------- Configs -----------
----------------------------
CONFIGURATION Comb_Arch OF top IS
FOR combinational
    FOR COMBDIV : SignedDivisionComb
        USE ENTITY WORK.SignedDivisionComb(SignedDivCombBehave);
    END FOR;

    FOR COMBMUL : mul
        USE ENTITY WORK.mul(bhv);
    END FOR;

END FOR;
END CONFIGURATION Comb_Arch;

---------------------------
CONFIGURATION Seq_Arch OF top IS
FOR sequential
    FOR div1 : divider_seq
        USE ENTITY WORK.divider_seq(behv);
    END FOR;

    FOR mul1 : mulseq
        USE ENTITY WORK.mulseq(mulbehav);
    END FOR;

END FOR;
END CONFIGURATION Seq_Arch;
