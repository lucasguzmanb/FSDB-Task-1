COLUMN surname FORMAT A30
COLUMN name FORMAT A30
COLUMN birth_year FORMAT A30
COLUMN death_year FORMAT A30
COLUMN is_author FORMAT A10

SELECT DISTINCT
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

-- Municipalities
INSERT INTO municipalities (name, province, population, has_library)
SELECT DISTINCT  TOWN, province, TO_NUMBER(POPULATION), CASE WHEN HAS_LIBRARY = 'Y' THEN 1 ELSE 0 END FROM fsdb.busstops;

-- Libraries
insert into libraries (CIF, name, foundation_date, municipality_id, address, email, telephone)
select distinct user_id, name, TO_DATE(birthdate, 'DD.MM.YYYY'), town, address, email, phone from fsdb.loans where UPPER(name) like '%BIBLIOTECA%' AND town IN (SELECT name FROM municipalities);

-- Bibus
insert into bibuses (plate, last_itv, next_itv)
SELECT plate, TO_DATE(MAX(TO_DATE(last_itv, 'DD.MM.YYYY // HH24:MI:SS')), 'DD.MM.YYYY // HH24:MI:SS'), 
TO_DATE(MIN(TO_DATE(next_itv, 'DD.MM.YYYY')), 'DD.MM.YYYY') FROM fsdb.busstops GROUP BY plate;

--Bibuseros
insert into bibuseros (passport, fullname, telephone, email, contract_start, contract_end)
select distinct lib_passport, lib_fullname,  lib_phone, lib_email, TO_DATE(cont_start, 'DD.MM.YYYY'), TO_DATE(cont_end, 'DD.MM.YYYY')  from fsdb.busstops;

--Routes
INSERT INTO routes (id, stop_day, stop_time, municipality_id, bibus_id, bibusero_id)
SELECT route_id, TO_DATE(stopdate, 'DD.MM.YYYY'), TO_TIMESTAMP(stoptime, 'HH24:MI:SS'), town, plate, lib_passport FROM fsdb.busstops ;