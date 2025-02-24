SELECT 
  TRIM(REGEXP_SUBSTR(main_author, '^[^,]+')) AS surname,
  TRIM(REGEXP_SUBSTR(main_author, ',\s*([^,]+)', 1, 1, NULL, 1)) AS name,
  TRIM(REGEXP_SUBSTR(main_author, '\((\d{4})', 1, 1, NULL, 1)) AS birth_year,
  TRIM(REGEXP_SUBSTR(main_author, '-\s*(\d{4})', 1, 1, NULL, 1)) AS death_year
FROM fsdb.acervus
FETCH FIRST 50 ROWS only;

SELECT 
  TRIM(REGEXP_SUBSTR(main_author, '^[^,]+')) AS surname,
  TRIM(REGEXP_SUBSTR(main_author, ',\s*([^,]+)', 1, 1, NULL, 1)) AS name,
  TRIM(REGEXP_SUBSTR(main_author, '\((\d{4})', 1, 1, NULL, 1)) AS birth_year,
  TRIM(REGEXP_SUBSTR(main_author, '-\s*(\d{4})', 1, 1, NULL, 1)) AS death_year,
  CASE 
    WHEN REGEXP_LIKE(main_author, '\(\s* *autor *\)') THEN 'autor'
    ELSE NULL 
  END AS role
FROM fsdb.acervus
FETCH FIRST 50 ROWS only;

COLUMN surname FORMAT A30
COLUMN name FORMAT A30
COLUMN birth_year FORMAT A30
COLUMN death_year FORMAT A30
COLUMN is_author FORMAT A10

SELECT 
  TRIM(REGEXP_SUBSTR(main_author, '^[^,]+')) AS surname,
  CASE 
    WHEN SUBSTR(TRIM(SUBSTR(main_author, INSTR(main_author, ',') + 1)), 1, 1) = '(' 
      THEN NULL
    ELSE TRIM(
           REGEXP_REPLACE(
             REGEXP_SUBSTR(main_author, ',\s*([^,]+)', 1, 1, NULL, 1),
             '\( *autor *\)',
             ''
           )
         )
  END AS name,
  TRIM(REGEXP_SUBSTR(main_author, '\(\s*(\d{4})', 1, 1, NULL, 1)) AS birth_year,
  TRIM(REGEXP_SUBSTR(main_author, '-\s*(\d{4})', 1, 1, NULL, 1)) AS death_year,
  CASE 
    WHEN REGEXP_LIKE(main_author, '\( *autor *\)') THEN 'author'
    ELSE NULL
  END AS role
FROM fsdb.acervus
FETCH FIRST 50 ROWS only;