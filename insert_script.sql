-- AUTHORS
INSERT INTO authors
SELECT DISTINCT main_author
FROM fsdb.acervus
WHERE main_author IS NOT NULL;

-- BOOKS
INSERT INTO books (
    title, 
    author_id, 
    pub_country, 
    pub_date, 
    original_language,
    alternative_titles, 
    subject, 
    content_notes, 
    awards,
    other_authors,
    mention_authors
)
SELECT 
    title,
    main_author,
    MAX(pub_country),
    TO_NUMBER(MAX(pub_date)),
    MAX(main_language),
    MAX(alt_title),
    MAX(topic),
    MAX(content_notes),
    MAX(awards),
    MAX(other_authors),
    MAX(mention_authors)
FROM fsdb.acervus
WHERE title IS NOT NULL AND main_author IS NOT NULL
GROUP BY title, main_author;

-- PUBLICATIONS
INSERT INTO publications (
    isbn, 
    book_title, 
    book_author_id, 
    main_language, 
    other_languages, 
    edition, 
    publisher, 
    length, 
    series, 
    publication_place, 
    dimensions, 
    physical_chars, 
    additional_material, 
    content_note, 
    national_id, 
    url
)
SELECT DISTINCT
    isbn, 
    title AS book_title, 
    main_author AS book_author_id, 
    main_language, 
    other_languages, 
    edition, 
    publisher, 
    extension AS length, 
    series, 
    pub_place AS publication_place, 
    dimensions, 
    physical_features AS physical_chars, 
    attached_materials AS additional_material, 
    notes AS content_note, 
    national_lib_id AS national_id, 
    URL
FROM fsdb.acervus
WHERE title IS NOT NULL 
    AND main_author IS NOT NULL
    AND isbn IS NOT NULL
    AND edition IS NOT NULL
    AND national_lib_id IS NOT NULL;

-- COPIES
INSERT INTO copies (
  id,
  isbn,
  edition,
  national_id,
  comments)
SELECT
  signature,
  isbn,
  edition,
  national_lib_id,
  notes
FROM fsdb.acervus
WHERE signature IS NOT NULL
  AND isbn IS NOT NULL
  AND edition IS NOT NULL
  AND national_lib_id IS NOT NULL;

-- MUNICIPALITIES
INSERT INTO municipalities (name, province, population, has_library)
SELECT DISTINCT  TOWN, province, TO_NUMBER(POPULATION), CASE WHEN HAS_LIBRARY = 'Y' THEN 1 ELSE 0 END FROM fsdb.busstops;

-- BIBUSES
insert into bibuses (plate, last_itv, next_itv)
SELECT plate, TO_DATE(MAX(TO_DATE(last_itv, 'DD.MM.YYYY // HH24:MI:SS')), 'DD.MM.YYYY // HH24:MI:SS'), 
TO_DATE(MIN(TO_DATE(next_itv, 'DD.MM.YYYY')), 'DD.MM.YYYY') FROM fsdb.busstops GROUP BY plate;

-- USERS
INSERT INTO users (
    id, 
    name, 
    surname1, 
    surname2, 
    passport, 
    birthdate, 
    town, 
    address, 
    email, 
    telephone
)
SELECT DISTINCT
       TO_NUMBER(user_id), 
       MAX(name), 
       MAX(surname1), 
       MAX(surname2), 
       MAX(passport), 
       MAX(CASE 
            WHEN INSTR(birthdate, '/') > 0 
            THEN TO_DATE(birthdate, 'DD/MM/YYYY') 
            WHEN INSTR(birthdate, '-') > 0 
            THEN TO_DATE(birthdate, 'DD-MM-YYYY') 
            ELSE NULL 
       END) AS birthdate,
       MAX(town),
       MAX(address),
       MAX(email),
       MAX(phone)
FROM fsdb.loans  
WHERE signature IS NOT NULL
AND name IS NOT NULL
AND UPPER(name) NOT LIKE '%BIBLIOTECA%'
AND surname1 IS NOT NULL
AND passport IS NOT NULL
AND birthdate IS NOT NULL
AND town IS NOT NULL
AND town IN (SELECT name FROM municipalities)
AND address IS NOT NULL
AND phone IS NOT NULL
AND user_id IS NOT NULL
GROUP BY user_id;

-- LOANS
INSERT INTO loans (
    id, 
    start_date, 
    return_date, 
    user_id, 
    comment_date, 
    body, 
    likes, 
    dislikes
)
SELECT DISTINCT
    SIGNATURE AS id, 
    TO_DATE(DATE_TIME, 'DD/MM/YYYY HH24:MI:SS') AS start_date, 
    TO_DATE(RETURN, 'DD/MM/YYYY HH24:MI:SS') AS return_date, 
    TO_NUMBER(USER_ID) AS user_id, 
    NULL AS comment_date,
    POST AS body,
    TO_NUMBER(LIKES) AS likes, 
    TO_NUMBER(DISLIKES) AS dislikes
FROM fsdb.loans
WHERE SIGNATURE IS NOT NULL 
AND NOT REGEXP_LIKE(SIGNATURE, '^\s*$')  -- This filters out empty or whitespace-only signatures
AND user_id IS NOT NULL
AND user_id IN (SELECT id FROM users)
AND RETURN IS NOT NULL;

-- SANCTIONS
INSERT INTO sanctions (
    loan_id, 
    user_id, 
    days, 
    start_date, 
    end_date
)
SELECT DISTINCT
    signature AS loan_id,
    user_id,
    (TO_DATE(return, 'DD/MM/YYYY HH24:MI:SS') - TO_DATE(date_time, 'DD/MM/YYYY HH24:MI:SS') - 14) AS days,
    TO_DATE(return, 'DD/MM/YYYY HH24:MI:SS') AS start_date,
    TO_DATE(return, 'DD/MM/YYYY HH24:MI:SS') + (TO_DATE(return, 'DD/MM/YYYY HH24:MI:SS') - TO_DATE(date_time, 'DD/MM/YYYY HH24:MI:SS') - 14) AS end_date
FROM fsdb.loans
WHERE (TO_DATE(return, 'DD/MM/YYYY HH24:MI:SS') - TO_DATE(date_time, 'DD/MM/YYYY HH24:MI:SS')) > 14
AND return IS NOT NULL
AND user_id IS NOT NULL
AND user_id IN (SELECT id FROM users)
AND signature IS NOT NULL
AND NOT REGEXP_LIKE(signature, '^\s*$');

-- BIBUSEROS
INSERT INTO bibuseros (passport, fullname, telephone, email, contract_start, contract_end)
SELECT DISTINCT lib_passport, lib_fullname,  lib_phone, lib_email, TO_DATE(cont_start, 'DD.MM.YYYY'), TO_DATE(cont_end, 'DD.MM.YYYY')  FROM fsdb.busstops;

-- ROUTES
INSERT INTO routes (id, stop_day, stop_time, town, bibus_id, bibusero_id)
SELECT route_id, TO_DATE(stopdate, 'DD.MM.YYYY'), TO_TIMESTAMP(stoptime, 'HH24:MI:SS'), town, plate, lib_passport FROM fsdb.busstops;

-- LIBRARIES
INSERT INTO libraries (CIF, name, foundation_date, town, address, email, telephone)
SELECT DISTINCT user_id, name, TO_DATE(birthdate, 'DD.MM.YYYY'), town, address, email, phone FROM fsdb.loans WHERE UPPER(name) LIKE '%BIBLIOTECA%' AND town IN (SELECT name FROM municipalities);