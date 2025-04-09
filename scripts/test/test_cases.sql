-- Tests
DO $$
DECLARE
    RESULT VARCHAR;
BEGIN
    -- Test case 1
    SELECT * INTO RESULT FROM TOPO_SORT(1);
    ASSERT RESULT = E'Program ID: 1 Name: PKGIDS_CMMN_UTILITY.PROCIDS_JOB_START\nProgram ID: 2 Name: pkgids_ptf_hrchy_processing.Procids_delete_job_set_nbr\nProgram ID: 3 Name: PKGIDS_PTF_EXTR.ext_static_ptf_table\nProgram ID: 4 Name: PKGIDS_PTF_EXTR.ext_eff_ptf_table\nProgram ID: 6 Name: pkgids_ptf_hrchy_processing.procids_get_tree_b\nProgram ID: 8 Name: pkgids_ptf_hrchy_processing.procids_get_tree_d\nProgram ID: 9 Name: pkgids_ptf_hrchy_processing.procids_get_tree_e\nProgram ID: 7 Name: pkgids_ptf_hrchy_processing.procids_get_tree_c\nProgram ID: 5 Name: pkgids_ptf_hrchy_processing.procids_get_tree_a\nProgram ID: 10 Name: pkgids_ptf_hrchy_processing.procids_get_active_portf\nProgram ID: 11 Name: pkgids_ptf_lineage.procids_process_ptf_lineage\nProgram ID: 12 Name: pkgids_ptf_lineage.procids_summary_to_bookable_rs\nProgram ID: 13 Name: PKGIDS_CMMN_UTILITY.PROCIDS_JOB_END\n', 'Test case 1 failed.';
    RAISE NOTICE E'\nTest case 1 passed.\n';

    -- Test case 2
    SELECT * INTO RESULT FROM TOPO_SORT(2);
    ASSERT RESULT = E'Program ID: 1 Name: A\nProgram ID: 2 Name: B\nProgram ID: 3 Name: C\n', 'Test case 2 failed.';
    RAISE NOTICE E'\nTest case 2 passed.\n';

    -- Test case 3
    SELECT * INTO RESULT FROM TOPO_SORT(3);
    ASSERT RESULT IS NULL, 'Test case 3 failed.';
    RAISE NOTICE E'\nTest case 3 passed.\n';

    -- Test case 4
    SELECT * INTO RESULT FROM TOPO_SORT(4);
    ASSERT RESULT IS NULL, 'Test case 4 failed.';
    RAISE NOTICE E'\nTest case 4 passed.\n';

    RAISE NOTICE E'\nAll test cases passed.\n';
END$$;