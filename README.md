# GIC Test Q2 - SQL Test 1

## Index

- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Usage](#usage)
- [Unit Test](#unit-test)
- [Production Notes](#production-notes)

## Project Structure

Two main scripts:

| Script Name     | Description                              |
| --------------- | ---------------------------------------- |
| q2_run_init.sql | Initialization of tables and function.   |
| q2_run_test.sql | Initialize test data and run test cases. |

Initialization Scripts folder:

| Script Name                    | Description                                                            |
| ------------------------------ | ---------------------------------------------------------------------- |
| scripts/init/init_function.sql | Topological sort function to get sequence of programs by unit number. |
| scripts/init/init_table.sql    | Initialize database tables for PROG_NAME and DEPENDENCY_RULES.         |

Test Scripts folder:

| Script Name                 | Description                                              |
| --------------------------- | -------------------------------------------------------- |
| scripts/test/test_cases.sql | Test cases.                                              |
| scripts/test/test_data.sql  | Initialize test data for PROG_NAME and DEPENDENCY_RULES. |

## Requirements

[PostgreSQL database](https://www.postgresql.org/download/)

## Usage

Run initialization script:

```sh
psql -U <username> -d <database> -f "q2_run_init.sql"
```

## Unit Test

Run test script:

```sh
psql -U <username> -d <database> -f "q2_run_test.sql"
```

## Production Notes

For a production version, the SQL function can be parallelized to allow processing for multiple unit numbers of different programs.

For deployment, q2_run_init.sql script should be run in the production PostgreSQL server's respective database.
