-- Load test data.
DELETE FROM DEPENDENCY_RULES WHERE UNIT_NBR IN (1,2,3,4);
DELETE FROM PROG_NAME WHERE UNIT_NBR IN (1,2,3,4);

-- Program Name - Data
INSERT INTO PROG_NAME VALUES
(1, 1, 'PKGIDS_CMMN_UTILITY.PROCIDS_JOB_START'),
(1, 2, 'pkgids_ptf_hrchy_processing.Procids_delete_job_set_nbr'),
(1, 3, 'PKGIDS_PTF_EXTR.ext_static_ptf_table'),
(1, 4, 'PKGIDS_PTF_EXTR.ext_eff_ptf_table'),
(1, 5, 'pkgids_ptf_hrchy_processing.procids_get_tree_a'),
(1, 6, 'pkgids_ptf_hrchy_processing.procids_get_tree_b'),
(1, 7, 'pkgids_ptf_hrchy_processing.procids_get_tree_c'),
(1, 8, 'pkgids_ptf_hrchy_processing.procids_get_tree_d'),
(1, 9, 'pkgids_ptf_hrchy_processing.procids_get_tree_e'),
(1, 10, 'pkgids_ptf_hrchy_processing.procids_get_active_portf'),
(1, 11, 'pkgids_ptf_lineage.procids_process_ptf_lineage'),
(1, 12, 'pkgids_ptf_lineage.procids_summary_to_bookable_rs'),
(1, 13, 'PKGIDS_CMMN_UTILITY.PROCIDS_JOB_END');
-- Dependency Rules - Data
INSERT INTO DEPENDENCY_RULES VALUES 
(1, 1, 1, 0), (1, 2, 2, 1), (1, 3, 3, 2), (1, 4, 4, 2),
(1, 5, 5, 3), (1, 6, 5, 4), (1, 7, 6, 3), (1, 8, 6, 4),
(1, 9, 7, 3), (1, 10, 7, 4), (1, 11, 8, 3), (1, 12, 9, 3),
(1, 13, 8, 4),  (1, 14, 9, 4), (1, 15, 10, 5), (1, 16, 10, 6),
(1, 17, 10, 7), (1, 18, 10, 8), (1, 19, 10, 9), (1, 20, 11, 10),
(1, 21, 12, 11), (1, 22, 13, 12);

-- Test Data 2 - Program unit with two program sources.
INSERT INTO PROG_NAME VALUES
(2, 1, 'A'), (2, 2, 'B'), (2, 3, 'C'), (2, 4, 'D');
INSERT INTO DEPENDENCY_RULES VALUES 
(2, 1, 1, 0), (2, 2, 2, 1), (2, 3, 3, 1), (2, 4, 3, 2);

-- Test Data 3 - Program unit with cycle to root. (1 and 3)
INSERT INTO PROG_NAME VALUES
(3, 1, 'A'), (3, 2, 'B'), (3, 3, 'C');
INSERT INTO DEPENDENCY_RULES VALUES 
(3, 1, 1, 0), (3, 2, 2, 1), (3, 3, 3, 2), (3, 4, 1, 3);

-- Test Data 4 - Program unit with cycle between programs. (2 and 3)
INSERT INTO PROG_NAME VALUES
(4, 1, 'A'), (4, 2, 'B'), (4, 3, 'C');
INSERT INTO DEPENDENCY_RULES VALUES 
(4, 1, 1, 0), (4, 2, 2, 1), (4, 3, 3, 2), (4, 4, 2, 3);
