----------------------------
-------- Configs -----------
----------------------------
CONFIGURATION tb_mul_file_conf OF MULSEQTB IS
FOR testbench_MULSEQ_file
    FOR DUT: MULSEQ USE ENTITY WORK.MULSEQ(MULBEHAV);
    END FOR;
END FOR;
END CONFIGURATION tb_mul_file_conf;

CONFIGURATION tb_mul_assertions_conf OF MULSEQTB IS
FOR MULSEQ_ASSERTIONS
    FOR DUT1: MULSEQ USE ENTITY WORK.MULSEQ(MULBEHAV);
    END FOR;
END FOR;
END CONFIGURATION tb_mul_assertions_conf;