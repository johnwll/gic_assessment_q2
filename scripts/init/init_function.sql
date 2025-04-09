CREATE OR REPLACE FUNCTION TOPO_SORT(PROCESS_UNIT INT) RETURNS VARCHAR
AS $$
    -- Input:
    -- PROCESS_UNIT - The current unit number to be processed.
    -- 
    -- Description:
    -- Topologically sort the program dependencies by the unit provided.
    -- Sort using Kahn's algorithm. 
    -- https://en.wikipedia.org/wiki/Topological_sorting
    -- Expects the program dependency to be a DAG.
    -- 
    -- Returns:
    -- If the program dependencies can be topologically sorted, 
    -- the output will be the sequence of programs of the unit number.
    -- If there is a dependency cycle, the program sequence will be
    -- empty and a message will be raised.
    --
    -- Assumption:
    -- Dependency rule of STEP_DEP_ID = 0, have no dependency.
DECLARE
    CURRENT_PROGRAM INT;     -- Current processing program.
    SEQUENCES       VARCHAR; -- Return sequences value.
    CYCLE_DETECTED  BOOLEAN; -- Boolean if cycle detected.
    REC             RECORD;  -- Record for cursor loop.
BEGIN
    -- Current vertex sources of the dependency tree.
    CREATE TEMPORARY TABLE IF NOT EXISTS SOURCE_PROGRAMS 
           ( PROGRAM INT );

    -- In-degree edge count of the programs.
    CREATE TEMPORARY TABLE IF NOT EXISTS DEPENDENCY_COUNTER 
           ( PROGRAM INT, COUNT INT );

    -- Program sequence result.
    CREATE TEMPORARY TABLE IF NOT EXISTS RESULT 
           ( PROGRAM INT );

    -- Populate root programs.
    INSERT INTO SOURCE_PROGRAMS
    SELECT DISTINCT PROG_NAME.STEP_SEQ_ID
           FROM PROG_NAME
           LEFT JOIN DEPENDENCY_RULES
           ON PROG_NAME.STEP_SEQ_ID = DEPENDENCY_RULES.STEP_SEQ_ID
           WHERE PROG_NAME.UNIT_NBR = PROCESS_UNIT AND 
                 ( STEP_DEP_ID = 0 OR STEP_DEP_ID IS NULL ); -- STEP_DEP_ID is 0 or null, then there is no dependency.

    -- No root programs found.
    IF NOT EXISTS ( SELECT 1 FROM SOURCE_PROGRAMS ) THEN
        RAISE NOTICE 'No program found for unit number %.', PROCESS_UNIT;
    END IF;

    -- Populate in-degree edge count of program dependencies.
    INSERT INTO DEPENDENCY_COUNTER
    SELECT STEP_SEQ_ID, COUNT(*)
           FROM DEPENDENCY_RULES
           WHERE UNIT_NBR    = PROCESS_UNIT AND
                 STEP_DEP_ID <> 0
           GROUP BY STEP_SEQ_ID;

    WHILE EXISTS ( SELECT 1 FROM SOURCE_PROGRAMS ) LOOP
        -- Process current program.
        SELECT PROGRAM INTO CURRENT_PROGRAM FROM SOURCE_PROGRAMS;
        DELETE FROM SOURCE_PROGRAMS WHERE PROGRAM = CURRENT_PROGRAM;

        -- Check if cycle to root exists.
        IF EXISTS ( SELECT PROGRAM FROM RESULT WHERE PROGRAM = CURRENT_PROGRAM ) THEN
            RAISE NOTICE 'Error: Cycle to program ID % detected.', CURRENT_PROGRAM;
            CYCLE_DETECTED := TRUE;
            EXIT;
        END IF;

        -- Insert current program into sequence result.
        INSERT INTO RESULT VALUES ( CURRENT_PROGRAM );

        -- Decrement in-edges of programs that has current program as a dependency.
        UPDATE DEPENDENCY_COUNTER 
        SET COUNT = COUNT - 1
        WHERE PROGRAM IN ( SELECT DISTINCT STEP_SEQ_ID 
                                  FROM  DEPENDENCY_RULES 
                                  WHERE UNIT_NBR    = PROCESS_UNIT AND
                                        STEP_DEP_ID = CURRENT_PROGRAM );

        -- Next programs to be processed.
        INSERT INTO SOURCE_PROGRAMS
        SELECT PROGRAM
               FROM  DEPENDENCY_COUNTER
               WHERE COUNT = 0;
        DELETE FROM DEPENDENCY_COUNTER WHERE COUNT = 0;
    END LOOP;

    -- If any dependency remaining, there must be a cycle.
    IF CYCLE_DETECTED OR EXISTS ( SELECT 1 FROM DEPENDENCY_COUNTER ) THEN
        RAISE NOTICE 'Error: Unit number % contains program circular dependency.',
                      PROCESS_UNIT;
    ELSE
        FOR REC IN
            SELECT * FROM RESULT
        LOOP
            SEQUENCES := FORMAT(E'%sProgram ID: %s Name: %s\n', 
                                  SEQUENCES,
                                  REC.PROGRAM,
                                  ( SELECT STEP_PROG_NAME FROM PROG_NAME WHERE UNIT_NBR    = PROCESS_UNIT AND 
                                                                               STEP_SEQ_ID = REC.PROGRAM  LIMIT 1 ));
        END LOOP;
    END IF;

    -- Drop temporary tables.
    DROP TABLE SOURCE_PROGRAMS;
    DROP TABLE DEPENDENCY_COUNTER;
    DROP TABLE RESULT;

    RETURN SEQUENCES;
END;
$$ LANGUAGE PLPGSQL;
