----------------------------
-------- Configs -----------
----------------------------
CONFIGURATION Comparison_Arch OF TopTB IS
FOR TopComparisonFilesTB
    FOR DUT_Comb : Top
        USE ENTITY WORK.Top(combinational);
    END FOR;

    FOR DUT_Seq : Top
        USE ENTITY WORK.Top(sequential);
    END FOR;

END FOR;
END CONFIGURATION Comparison_Arch;
----------------------------------------
----------------------------------------
CONFIGURATION Comparison_Arch2 OF TopTB IS
FOR TopComparisonFilesTB2
    FOR DUT_Comb : Top
        USE ENTITY WORK.Top(combinational);
    END FOR;

    FOR DUT_Seq : Top
        USE ENTITY WORK.Top(sequential);
    END FOR;

END FOR;
END CONFIGURATION Comparison_Arch2;