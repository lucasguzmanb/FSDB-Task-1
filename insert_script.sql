-- AUTHORS
INSERT INTO authors
SELECT DISTINCT main_author
WHERE main_author IS NOT NULL;

-- BOOKS
INSERT INTO books (
    title, 
    author_id, 
    pub_country, 
    pub_date, 
    alternative_titles, 
    subject, 
    content_notes, 
    awards,
    other_authors,
    mention_authors
)
SELECT DISTINCT
    title,
    main_author,
    pub_country,
    TO_NUMBER(pub_date),
    alternative_titles,
    subject,
    content_notes,
    awards,
    other_authors,
    mention_authors
FROM fsdb.acervus
WHERE title IS NOT NULL;

-- COPIES
INSERT INTO copies (
  id,
  publication_id,
  comments)
SELECT
  signature,
  isbn,
  notes
FROM fsdb.acervus;

-- MUNICIPALITIES
INSERT INTO municipalities (name, province, population, has_library)
SELECT DISTINCT  TOWN, province TO_NUMBER(POPULATION), CASE WHEN HAS_LIBRARY = 'Y' THEN 1 ELSE 0 END FROM fsdb.busstops;

-- LIBRARIES
INSERT INTO libraries (CIF, name, foundation_date, municipality_id, address, email, telephone)
SELECT DISTINCT user_id, name, birthdate, town, address, email, phone from fsdb.loans where UPPER(name) LIKE '%BIBLIOTECA%';

-- BIBUS
INSERT INTO bibuses (plate, last_itv, next_itv, state)
SELECT plate, TO_CHAR(MAX(TO_DATE(last_itv, 'DD.MM.YYYY // HH24:MI:SS')), 'DD.MM.YYYY // HH24:MI:SS'), 
TO_CHAR(MIN(TO_DATE(next_itv, 'DD.MM.YYYY')), 'DD.MM.YYYY') FROM fsdb.busstops GROUP BY plate;

-- BIBUSEROS
INSERT INTO (passport, fullname, telephone, email, contract_start, contract_end, state)
SELECT DISTINCT lib_passport, lib_fullname,  lib_phone, lib_email, cont_start, cont_end  FROM fsdb.busstops;

-- ROUTES
INSERT INTO routes (id, stop_day, stop_time, municipality_id, bibus_id, bibusero_id)
SELECT route_id, stopdate, stoptime, town, plate, lib_passport FROM fsdb.busstops ;