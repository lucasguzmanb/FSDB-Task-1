DROP TABLE libraries;
DROP TABLE reservation;
DROP TABLE routes;
DROP TABLE bibuseros;
DROP TABLE comments;
DROP TABLE sanctions;
DROP TABLE loans;
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
    surname VARCHAR2(255) NOT NULL,
    birthdate DATE NULL,
    death_date DATE NULL,
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

CREATE TABLE loans (
    id NUMBER PRIMARY KEY,
    start_date DATE NOT NULL,
    return_date DATE NOT NULL,
    user_id NUMBER NOT NULL,
    copy_id NUMBER NOT NULL,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    
    CONSTRAINT fk_copy_id
        FOREIGN KEY (copy_id)
        REFERENCES copies(id)

);

CREATE TABLE sanctions (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    loan_id NUMBER NOT NULL,
    weeks NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)

    CONSTRAINT fk_loan_id
        FOREIGN KEY (loan_id)
        REFERENCES loans(id)
);

CREATE TABLE comments (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    date DATE NOT NULL,
    book_id NUMBER NOT NULL,
    copy_id NUMBER NOT NULL,
    body VARCHAR2(500) NOT NULL,
    likes NUMBER NOT NULL,
    dislikes NUMBER NOT NULL,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)

    CONSTRAINT fk_book_id
        FOREIGN KEY (book_id)
        REFERENCES books(id)

);

CREATE TABLE bibuseros (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    surname VARCHAR2(255) NOT NULL,
    passport NUMBER NOT NULL UNIQUE,
    telephone NUMBER NOT NULL,
    email VARCHAR2(255) NOT NULL,
    contract_start DATE NOT NULL,
    contract_end DATE NULL,
    state VARCHAR2(255) NOT NULL,


);

CREATE TABLE routes (
    id NUMBER PRIMARY KEY,
    stop_day DATE NOT NULL,
    municipality_id NUMBER NOT NULL,
    bibus_id NUMBER NOT NULL,
    bibusero_id NUMBER NOT NULL,

    CONSTRAINT fk_municipality_id
        FOREIGN KEY (municipality_id)
        REFERENCES municipalities(id)

    CONSTRAINT fk_bibus_id
        FOREIGN KEY (bibus_id)
        REFERENCES bibuses(id)

    CONSTRAINT fk_bibusero_id
        FOREIGN KEY (bibusero_id)
        REFERENCES bibuseros(id)

);

CREATE TABLE reservation (
    id NUMBER PRIMARY KEY,
    copy_id NUMBER NOT NULL,
    user_id NUMBER NOT NULL,
    route_id NUMBER NOT NULL,
    date DATE NOT NULL,
    state VARCHAR2(255) NOT NULL,

    CONSTRAINT fk_copy_id
        FOREIGN KEY (copy_id)
        REFERENCES copies(id)

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)

    CONSTRAINT fk_route_id
        FOREIGN KEY (route_id)
        REFERENCES routes(id)

);

CREATE TABLE libraries (
    CIF NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    foundation_date DATE NOT NULL,
    municipality_id NUMBER NOT NULL,
    address VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL,
    telephone NUMBER NOT NULL,

    CONSTRAINT fk_municipality_id
        FOREIGN KEY (municipality_id)
        REFERENCES municipalities(id)
         
);