-- AUTHORS
INSERT INTO authors (main_author, surname, name, birth_year, death_year)
  SELECT main_author, surname, name, birth_year, death_year FROM (
    SELECT DISTINCT
    main_author,
    TRIM(REGEXP_SUBSTR(main_author, '^[^,]+')) AS surname,
    CASE
        WHEN SUBSTR(TRIM(SUBSTR(main_author, INSTR(main_author, ',') + 1)), 1, 1) = '(' 
            THEN 'Unknown'
        ELSE TRIM(
              REGEXP_REPLACE(
                REGEXP_SUBSTR(main_author, ',\s*([^,]+)', 1, 1, NULL, 1),
                '\( *autor *\)',
                ''
              )
            )
    END AS name,
    TRIM(REGEXP_SUBSTR(main_author, '\(\s*(\d{4})', 1, 1, NULL, 1)) AS birth_year,
    TRIM(REGEXP_SUBSTR(main_author, '-\s*(\d{4})', 1, 1, NULL, 1)) AS death_year
    FROM fsdb.acervus
    WHERE main_author IS NOT NULL
  )
  WHERE name IS NOT NULL;

-- BOOKS
INSERT INTO books (
    title, 
    author_id, 
    pub_country, 
    pub_date, 
    alternative_titles, 
    subject, 
    content_note, 
    awards
)
SELECT DISTINCT
    ac.title AS title,
    a.id AS author_id,
    ac.pub_country AS pub_country,
    TO_NUMBER(ac.pub_date) AS pub_date,
    ac.alt_title AS alternative_titles,
    ac.topic AS subject,
    ac.content_notes AS content_note,
    ac.awards AS awards
FROM fsdb.acervus ac
JOIN authors a ON ac.main_author = a.main_author;

-- COMMENTS
INSERT INTO comments (user_id, comment_date, copy_id, body, likes, dislikes)
SELECT
    user_id,
    TO_DATE(post_date, 'DD/MM/YYYY HH24:MI:SS') AS post_date,
    signature,
    post,
    likes,
    dislikes 
FROM fsdb.loans
WHERE post IS NOT NULL;

-- COPIES
INSERT INTO copies (
  id,
  publication_id,
  comments)
SELECT
  signature,
  isbn,
  notes
FROM fsdb.acervus
FETCH FIRST 50 ROWS only;

-- Municipalities
INSERT INTO municipalities (name, province, population, has_library)
SELECT DISTINCT  TOWN, province TO_NUMBER(POPULATION), CASE WHEN HAS_LIBRARY = 'Y' THEN 1 ELSE 0 END FROM fsdb.busstops;

-- Libraries
insert into libraries (CIF, name, foundation_date, municipality_id, address, email, telephone)
select distinct user_id, name, birthdate, town, address, email, phone from fsdb.loans where UPPER(name) like '%BIBLIOTECA%';

-- Bibus
insert into bibuses (plate, last_itv, next_itv, state)
SELECT plate, TO_CHAR(MAX(TO_DATE(last_itv, 'DD.MM.YYYY // HH24:MI:SS')), 'DD.MM.YYYY // HH24:MI:SS'), 
TO_CHAR(MIN(TO_DATE(next_itv, 'DD.MM.YYYY')), 'DD.MM.YYYY') FROM fsdb.busstops GROUP BY plate;

--Bibuseros
insert into (passport, fullname, telephone, email, contract_start, contract_end, state)
select distinct lib_passport, lib_fullname,  lib_phone, lib_email, cont_start, cont_end  from fsdb.busstops;

--Routes
INSERT INTO routes (id, stop_day, stop_time, municipality_id, bibus_id, bibusero_id)
SELECT route_id, stopdate, stoptime, town, plate, lib_passport FROM fsdb.busstops ;