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
WHERE signature IS NOT NULL;

-- CONTRIBUTIONS