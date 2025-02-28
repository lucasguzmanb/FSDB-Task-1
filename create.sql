DROP TABLE libraries;
DROP TABLE routes;
DROP TABLE bibuseros;
DROP TABLE sanctions;
DROP TABLE loans;
DROP TABLE users;
DROP TABLE bibuses;
DROP TABLE municipalities;
DROP TABLE copies;
DROP TABLE publications;
DROP TABLE books;
DROP TABLE authors;

CREATE TABLE authors (
    main_author VARCHAR2(255) PRIMARY KEY
);

CREATE TABLE books (
    title VARCHAR2(255) NOT NULL,
    author_id VARCHAR2(255) NOT NULL REFERENCES authors(main_author),
    pub_country VARCHAR2(255) NULL,
    pub_date NUMBER(4) NULL,
    original_language VARCHAR2(50) NULL,
    alternative_titles VARCHAR2(255) NULL,
    subject VARCHAR2(255) NULL,
    content_notes VARCHAR2(2500) NULL,
    awards VARCHAR2(255) NULL,
    other_authors VARCHAR2(255) NULL,
    mention_authors VARCHAR2(255) NULL,
    CONSTRAINT book_pk PRIMARY KEY(title, author_id)
);

CREATE TABLE publications (
    isbn VARCHAR2(255) NOT NULL,
    book_title VARCHAR2(255) NOT NULL,
    book_author_id VARCHAR2(255) NOT NULL,
    main_language VARCHAR2(50) NULL,
    other_languages VARCHAR2(50) NULL,
    edition VARCHAR2(50) NULL,
    publisher VARCHAR2(255) NULL,
    length VARCHAR2(50) NULL,
    series VARCHAR2(50) NULL,
    publication_place VARCHAR2(50) NULL,
    dimensions VARCHAR2(50) NULL,
    physical_chars VARCHAR2(255) NULL,
    additional_material VARCHAR2(255) NULL,
    content_note VARCHAR2(500) NULL,
    national_id VARCHAR2(255) NOT NULL UNIQUE,
    url VARCHAR2(255) NULL,
    CONSTRAINT publication_pk PRIMARY KEY(isbn, edition, national_id),
    CONSTRAINT publication_fk FOREIGN KEY (book_title, book_author_id)
        REFERENCES books(title, author_id)
);

CREATE TABLE copies (
    id VARCHAR2(255) PRIMARY KEY,
    isbn VARCHAR2(255) NOT NULL,
    edition VARCHAR2(50) DEFAULT 'unknown',
    national_id VARCHAR2(255) NOT NULL,
    condition VARCHAR2(255) DEFAULT 'unknown',
    comments VARCHAR2(500) NULL,
    available NUMBER(1) DEFAULT 1 NOT NULL,
    derregistration_date DATE NULL,
    CONSTRAINT copy_fk FOREIGN KEY (isbn, edition, national_id)
        REFERENCES publications(isbn, edition, national_id),
    CONSTRAINT condition_ct CHECK (condition IN ('new', 'good', 'worn', 'very used', 'deteriorated', 'unknown'))
);

CREATE TABLE municipalities (
    name VARCHAR2(255) PRIMARY KEY,
    province VARCHAR(255) NOT NULL,
    population NUMBER NOT NULL,
    has_library NUMBER(1) NOT NULL
);

CREATE TABLE bibuses (
    plate VARCHAR2(255) PRIMARY KEY,
    last_itv DATE NOT NULL,
    next_itv DATE NOT NULL,
    state VARCHAR2(255) DEFAULT 'available',
    CONSTRAINT correct_itv_date CHECK (last_itv < next_itv),
    CONSTRAINT state_bibus_ct CHECK (state IN ('available', 'assigned', 'maintenance'))
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    surname1 VARCHAR2(255) NOT NULL,
    surname2 VARCHAR2(255) NULL,
    passport VARCHAR2(20) NOT NULL UNIQUE,
    birthdate DATE NOT NULL,
    town VARCHAR2(255) NOT NULL REFERENCES municipalities(name),
    address VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NULL,
    telephone NUMBER(9) NOT NULL,
    CONSTRAINT email_users_ct CHECK (email IS NULL OR email LIKE '%@%.%')
);

CREATE TABLE loans (
    id VARCHAR2(255) PRIMARY KEY,
    start_date DATE NOT NULL,
    return_date DATE NOT NULL,
    user_id NUMBER NOT NULL REFERENCES users(id),
    is_reservation NUMBER(1) DEFAULT 0,
    comment_date DATE NULL,
    body VARCHAR2(2000) NULL,
    likes NUMBER DEFAULT 0,
    dislikes NUMBER DEFAULT 0,
    CONSTRAINT comment_date_ct CHECK (comment_date IS NULL OR comment_date > return_date)
);

CREATE TABLE sanctions (
    loan_id VARCHAR2(255) PRIMARY KEY REFERENCES loans(id),
    user_id NUMBER NOT NULL REFERENCES users(id),
    days NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE bibuseros (
    passport VARCHAR2(255) PRIMARY KEY,
    fullname VARCHAR2(255) NOT NULL,
    telephone NUMBER(9) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    contract_start DATE NOT NULL,
    contract_end DATE NULL,
    state VARCHAR2(255) DEFAULT 'assigned',
    CONSTRAINT state_bibusero_ct CHECK (state IN ('assigned', 'day off', 'occupied')),
    CONSTRAINT email_bibuseros_ct CHECK (email LIKE '%@%.%')
);

CREATE TABLE routes (
    id VARCHAR2(255) NOT NULL,
    stop_day DATE NOT NULL,
    town VARCHAR2(255) NOT NULL REFERENCES municipalities(name),
    bibus_id VARCHAR2(255) NOT NULL REFERENCES bibuses(plate),
    bibusero_id VARCHAR2(255) NOT NULL REFERENCES bibuseros(passport),
    CONSTRAINT route_pk PRIMARY KEY(id, town)
);

CREATE TABLE libraries (
    CIF NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    foundation_date DATE NOT NULL,
    town VARCHAR2(255) NOT NULL REFERENCES municipalities(name),
    address VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    telephone NUMBER(9) NOT NULL,
    CONSTRAINT email_libraries_ct CHECK (email LIKE '%@%.%')
);
