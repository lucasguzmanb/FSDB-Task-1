DROP TABLE users;
DROP TABLE bibuses;
DROP TABLE municipalities;
DROP TABLE copies;
DROP TABLE publications
DROP TABLE contributions;
DROP TABLE books;
DROP TABLE authors;

CREATE TABLE authors (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    surname VARCHAR2(255) NOT NULL
);

CREATE TABLE books (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    author_id NUMBER NOT NULL,
    publication_country VARCHAR2(255) NOT NULL,
    publication_date DATE NOT NULL,
    alternative_titles VARCHAR2(255) NOT NULL,
    subject VARCHAR2(255) NOT NULL,
    content_note VARCHAR2(2500) NOT NULL,
    awards VARCHAR2(255) NOT NULL,
    
    CONSTRAINT fk_author_id
        FOREIGN KEY (author_id)
        REFERENCES authors(id)
);

CREATE TABLE contributions (
    author_id NUMBER,
    book_id NUMBER,
    mention VARCHAR2(255) NOT NULL,
    
    CONSTRAINT fk_author_id
        FOREIGN KEY (author_id)
        REFERENCES authors(id),
    
    CONSTRAINT fk_book_id
        FOREIGN KEY (book_id)
        REFERENCES books(id),
    
    PRIMARY KEY (author_id, book_id)
);

CREATE TABLE publications (
    isbn NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    main_language VARCHAR2(50) NOT NULL,
    other_languages VARCHAR2(50) NOT NULL,
    edition VARCHAR2(50) NOT NULL,
    publisher VARCHAR2(255) NOT NULL,
    length NUMBER NOT NULL,
    series VARCHAR2(50) NOT NULL,
    legal_deposit VARCHAR2(50) NOT NULL,
    publication_place VARCHAR2(50) NOT NULL,
    dimensions VARCHAR2(50) NOT NULL,
    physical_chars VARCHAR2(255) NOT NULL,
    additional_material VARCHAR2(255) NULL,
    national_id NUMBER NOT NULL UNIQUE,
    url VARCHAR2(255) NOT NULL,

    CONSTRAINT fk_book_id
        FOREIGN KEY (book_id)
        REFERENCES books(id)
);

CREATE TABLE copies (
    signature NUMBER PRIMARY KEY,
    publication_id NUMBER NOT NULL,
    condition VARCHAR2(255) NOT NULL,
    comments VARCHAR2(500) NOT NULL,
    available BOOLEAN NOT NULL,
    derregistration_date DATE NULL,
);

CREATE TABLE municipalities (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    population NUMBER NOT NULL,
    has_library BOOLEAN NOT NULL
);

CREATE TABLE bibuses (
    id NUMBER PRIMARY KEY,
    plate VARCHAR2(255) NOT NULL UNIQUE,
    state VARCHAR2(255) NOT NULL
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    surname VARCHAR2(255) NOT NULL,
    passport NUMBER NOT NULL UNIQUE,
    birthdate DATE NOT NULL,
    municipality_id NUMBER NOT NULL,
    address VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NULL,
    telephone NUMBER NOT NULL,
    user_type VARCHAR2(255) NOT NULL,

    CONSTRAINT fk_municipality_id
        FOREIGN KEY (municipality_id)
        REFERENCES municipalities(id)
);