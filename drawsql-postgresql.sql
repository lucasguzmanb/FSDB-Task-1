CREATE TABLE "Publications"(
    "ISBN" BIGINT NOT NULL,
    "book_id" BIGINT NOT NULL,
    "main_language" VARCHAR(255) NOT NULL,
    "other_languages" VARCHAR(255) NOT NULL,
    "edition" BIGINT NOT NULL,
    "publisher" VARCHAR(255) NOT NULL,
    "length" BIGINT NOT NULL,
    "series" BIGINT NOT NULL,
    "legal_deposit" BIGINT NOT NULL,
    "publication_place" VARCHAR(255) NOT NULL,
    "dimensions" BIGINT NOT NULL,
    "physical_chars" BIGINT NOT NULL,
    "additional_material" VARCHAR(255) NULL,
    "additional_notes" VARCHAR(255) NULL,
    "national_id" BIGINT NOT NULL,
    "URL" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Publications" ADD PRIMARY KEY("ISBN");
ALTER TABLE
    "Publications" ADD CONSTRAINT "publications_national_id_unique" UNIQUE("national_id");
CREATE TABLE "Municipalities"(
    "id" BIGINT NOT NULL,
    "name" BIGINT NOT NULL,
    "population" BIGINT NOT NULL,
    "has_library" BOOLEAN NOT NULL
);
ALTER TABLE
    "Municipalities" ADD PRIMARY KEY("id");
ALTER TABLE
    "Municipalities" ADD CONSTRAINT "municipalities_name_unique" UNIQUE("name");
CREATE TABLE "Routes"(
    "id" BIGINT NOT NULL,
    "stop_date" DATE NOT NULL,
    "municipality_id" BIGINT NOT NULL,
    "bibus_id" BIGINT NOT NULL,
    "bibusero_id" BIGINT NOT NULL
);
ALTER TABLE
    "Routes" ADD PRIMARY KEY("id");
CREATE TABLE "Bibus"(
    "id" BIGINT NOT NULL,
    "plate" BIGINT NOT NULL,
    "state" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Bibus" ADD PRIMARY KEY("id");
ALTER TABLE
    "Bibus" ADD CONSTRAINT "bibus_plate_unique" UNIQUE("plate");
CREATE TABLE "Bibuseros"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "surname" VARCHAR(255) NOT NULL,
    "passport" BIGINT NOT NULL,
    "telephone" BIGINT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "contract_start" DATE NOT NULL,
    "contract_end" DATE NULL
);
ALTER TABLE
    "Bibuseros" ADD PRIMARY KEY("id");
ALTER TABLE
    "Bibuseros" ADD CONSTRAINT "bibuseros_passport_unique" UNIQUE("passport");
CREATE TABLE "Reservations"(
    "id" BIGINT NOT NULL,
    "copy_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "route_id" BIGINT NOT NULL
);
ALTER TABLE
    "Reservations" ADD PRIMARY KEY("id");
CREATE TABLE "Authors"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "surname" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Authors" ADD PRIMARY KEY("id");
CREATE TABLE "Contributions"(
    "author_id" BIGINT NOT NULL,
    "book_id" BIGINT NOT NULL,
    "mention" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Contributions" ADD PRIMARY KEY("author_id");
ALTER TABLE
    "Contributions" ADD PRIMARY KEY("book_id");
CREATE TABLE "Books"(
    "id" BIGINT NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "author_id" BIGINT NOT NULL,
    "publication_country" VARCHAR(255) NOT NULL,
    "original_language" VARCHAR(255) NOT NULL,
    "publication_date" DATE NOT NULL,
    "alternative_titles" VARCHAR(255) NOT NULL,
    "subject" VARCHAR(255) NOT NULL,
    "content_note" VARCHAR(255) NOT NULL,
    "awards" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Books" ADD PRIMARY KEY("id");
CREATE TABLE "Users"(
    "user_id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "surname" VARCHAR(255) NOT NULL,
    "passport" BIGINT NOT NULL,
    "birthdate" DATE NOT NULL,
    "municipality_id" BIGINT NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NULL,
    "telephone" BIGINT NOT NULL,
    "user_type" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Users" ADD PRIMARY KEY("user_id");
ALTER TABLE
    "Users" ADD CONSTRAINT "users_passport_unique" UNIQUE("passport");
CREATE TABLE "Comments"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "date" DATE NOT NULL,
    "book_id" BIGINT NOT NULL,
    "body" TEXT NOT NULL,
    "likes" BIGINT NOT NULL,
    "dislikes" BIGINT NOT NULL
);
ALTER TABLE
    "Comments" ADD PRIMARY KEY("id");
CREATE TABLE "Loans"(
    "id" BIGINT NOT NULL,
    "start__date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "user_id" BIGINT NOT NULL,
    "copy_id" BIGINT NOT NULL,
    "returned" BOOLEAN NOT NULL,
    "real_return_date" DATE NOT NULL
);
ALTER TABLE
    "Loans" ADD PRIMARY KEY("id");
CREATE TABLE "Libraries"(
    "CIF" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "foundation_date" DATE NOT NULL,
    "municipality_id" BIGINT NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "telephone" BIGINT NOT NULL
);
ALTER TABLE
    "Libraries" ADD PRIMARY KEY("CIF");
CREATE TABLE "Copies"(
    "signature" BIGINT NOT NULL,
    "publication_id" BIGINT NOT NULL,
    "condition" VARCHAR(255) NOT NULL,
    "comments" VARCHAR(255) NOT NULL,
    "available" BOOLEAN NOT NULL,
    "derregistration_date" DATE NULL
);
ALTER TABLE
    "Copies" ADD PRIMARY KEY("signature");
CREATE TABLE "Sanctions"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "loan_id" BIGINT NOT NULL,
    "weeks" BIGINT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL
);
ALTER TABLE
    "Sanctions" ADD PRIMARY KEY("id");
ALTER TABLE
    "Reservations" ADD CONSTRAINT "reservations_route_id_foreign" FOREIGN KEY("route_id") REFERENCES "Routes"("id");
ALTER TABLE
    "Publications" ADD CONSTRAINT "publications_book_id_foreign" FOREIGN KEY("book_id") REFERENCES "Books"("id");
ALTER TABLE
    "Books" ADD CONSTRAINT "books_author_id_foreign" FOREIGN KEY("author_id") REFERENCES "Authors"("id");
ALTER TABLE
    "Copies" ADD CONSTRAINT "copies_publication_id_foreign" FOREIGN KEY("publication_id") REFERENCES "Publications"("ISBN");
ALTER TABLE
    "Libraries" ADD CONSTRAINT "libraries_municipality_id_foreign" FOREIGN KEY("municipality_id") REFERENCES "Municipalities"("id");
ALTER TABLE
    "Loans" ADD CONSTRAINT "loans_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("user_id");
ALTER TABLE
    "Loans" ADD CONSTRAINT "loans_copy_id_foreign" FOREIGN KEY("copy_id") REFERENCES "Copies"("signature");
ALTER TABLE
    "Sanctions" ADD CONSTRAINT "sanctions_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("user_id");
ALTER TABLE
    "Contributions" ADD CONSTRAINT "contributions_book_id_foreign" FOREIGN KEY("book_id") REFERENCES "Books"("id");
ALTER TABLE
    "Reservations" ADD CONSTRAINT "reservations_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("user_id");
ALTER TABLE
    "Sanctions" ADD CONSTRAINT "sanctions_loan_id_foreign" FOREIGN KEY("loan_id") REFERENCES "Loans"("id");
ALTER TABLE
    "Reservations" ADD CONSTRAINT "reservations_copy_id_foreign" FOREIGN KEY("copy_id") REFERENCES "Copies"("signature");
ALTER TABLE
    "Comments" ADD CONSTRAINT "comments_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("user_id");
ALTER TABLE
    "Contributions" ADD CONSTRAINT "contributions_author_id_foreign" FOREIGN KEY("author_id") REFERENCES "Authors"("id");
ALTER TABLE
    "Users" ADD CONSTRAINT "users_municipality_id_foreign" FOREIGN KEY("municipality_id") REFERENCES "Municipalities"("id");
ALTER TABLE
    "Routes" ADD CONSTRAINT "routes_bibus_id_foreign" FOREIGN KEY("bibus_id") REFERENCES "Bibus"("id");
ALTER TABLE
    "Comments" ADD CONSTRAINT "comments_book_id_foreign" FOREIGN KEY("book_id") REFERENCES "Books"("id");
ALTER TABLE
    "Routes" ADD CONSTRAINT "routes_bibusero_id_foreign" FOREIGN KEY("bibusero_id") REFERENCES "Bibuseros"("id");
ALTER TABLE
    "Routes" ADD CONSTRAINT "routes_municipality_id_foreign" FOREIGN KEY("municipality_id") REFERENCES "Municipalities"("id");