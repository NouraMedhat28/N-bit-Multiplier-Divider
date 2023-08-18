----------------------------
-------- Configs -----------
----------------------------
CONFIGURATION tb_file_conf OF SignedDivisionComb_test IS
FOR testbench_SignedDivisionComb_file
    FOR DUT: SignedDivisionComb USE ENTITY WORK.SignedDivisionComb(SignedDivCombBehave);
    END FOR;
END FOR;
END CONFIGURATION tb_file_conf;

CONFIGURATION tb_assertions_conf OF SignedDivisionComb_test IS
FOR testbench_SignedDivisionComb_assertions
    FOR DUT: SignedDivisionComb USE ENTITY WORK.SignedDivisionComb(SignedDivCombBehave);
    END FOR;
END FOR;
END CONFIGURATION tb_assertions_conf;