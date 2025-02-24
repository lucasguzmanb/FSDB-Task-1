CREATE TABLE `Libraries`(
    `CIF` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `foundation_date` DATE NOT NULL,
    `municipality_id` BIGINT NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `telephone` BIGINT NOT NULL,
    PRIMARY KEY(`CIF`)
);
CREATE TABLE `Municipalities`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `population` BIGINT NOT NULL,
    `has_library` BOOLEAN NOT NULL
);
ALTER TABLE
    `Municipalities` ADD UNIQUE `municipalities_name_unique`(`name`);
CREATE TABLE `Routes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `stop_date` DATE NOT NULL,
    `municipality_id` BIGINT NOT NULL,
    `bibus_id` BIGINT NOT NULL,
    `bibusero_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `state` VARCHAR(255) NOT NULL
);
CREATE TABLE `Bibus`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `plate` BIGINT NOT NULL,
    `state` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Bibus` ADD UNIQUE `bibus_plate_unique`(`plate`);
CREATE TABLE `Bibuseros`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `passport` BIGINT NOT NULL,
    `telephone` BIGINT NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `contract_start` DATE NOT NULL,
    `contract_end` DATE NULL
);
ALTER TABLE
    `Bibuseros` ADD UNIQUE `bibuseros_passport_unique`(`passport`);
CREATE TABLE `Reservations`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `copy_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `route_id` BIGINT NOT NULL
);
CREATE TABLE `Authors`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL
);
CREATE TABLE `Contributions`(
    `author_id` BIGINT NOT NULL,
    `book_id` BIGINT NOT NULL,
    `mention` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`author_id`)
);
ALTER TABLE
    `Contributions` ADD PRIMARY KEY(`book_id`);
CREATE TABLE `Books`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `author_id` BIGINT NOT NULL,
    `publication_country` VARCHAR(255) NOT NULL,
    `original_language` VARCHAR(255) NOT NULL,
    `publication_date` DATE NOT NULL,
    `alternative_titles` VARCHAR(255) NOT NULL,
    `subject` VARCHAR(255) NOT NULL,
    `content_note` VARCHAR(255) NOT NULL,
    `awards` VARCHAR(255) NOT NULL
);
CREATE TABLE `Users`(
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `passport` BIGINT NOT NULL,
    `birthdate` DATE NOT NULL,
    `municipality_id` BIGINT NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `telephone` BIGINT NOT NULL,
    `user_type` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Users` ADD UNIQUE `users_passport_unique`(`passport`);
CREATE TABLE `Comments`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `book_id` BIGINT NOT NULL,
    `body` TEXT NOT NULL,
    `likes` BIGINT NOT NULL,
    `dislikes` BIGINT NOT NULL
);
CREATE TABLE `Loans`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `start_date` DATE NOT NULL,
    `return_date` DATE NOT NULL,
    `user_id` BIGINT NOT NULL,
    `copy_id` BIGINT NOT NULL,
    `returned` BOOLEAN NOT NULL,
    `real_return_date` DATE NOT NULL
);
CREATE TABLE `Publications`(
    `ISBN` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `book_id` BIGINT NOT NULL,
    `main_language` VARCHAR(255) NOT NULL,
    `other_languages` VARCHAR(255) NOT NULL,
    `edition` BIGINT NOT NULL,
    `publisher` VARCHAR(255) NOT NULL,
    `length` BIGINT NOT NULL,
    `series` BIGINT NOT NULL,
    `legal_deposit` BIGINT NOT NULL,
    `publication_place` VARCHAR(255) NOT NULL,
    `dimensions` BIGINT NOT NULL,
    `physical_chars` BIGINT NOT NULL,
    `additional_material` VARCHAR(255) NOT NULL,
    `additional_notes` VARCHAR(255) NOT NULL,
    `national_id` BIGINT NOT NULL,
    `URL` BIGINT NOT NULL
);
ALTER TABLE
    `Publications` ADD UNIQUE `publications_national_id_unique`(`national_id`);
CREATE TABLE `Copies`(
    `signature` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `publication_id` BIGINT NOT NULL,
    `condition` VARCHAR(255) NOT NULL,
    `comments` VARCHAR(255) NOT NULL,
    `available` BOOLEAN NOT NULL,
    `derregistration_date` DATE NULL
);
CREATE TABLE `Sanctions`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `loan_id` BIGINT NOT NULL,
    `weeks` BIGINT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL
);
ALTER TABLE
    `Reservations` ADD CONSTRAINT `reservations_route_id_foreign` FOREIGN KEY(`route_id`) REFERENCES `Routes`(`id`);
ALTER TABLE
    `Comments` ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`);
ALTER TABLE
    `Routes` ADD CONSTRAINT `routes_bibusero_id_foreign` FOREIGN KEY(`bibusero_id`) REFERENCES `Bibuseros`(`id`);
ALTER TABLE
    `Libraries` ADD CONSTRAINT `libraries_municipality_id_foreign` FOREIGN KEY(`municipality_id`) REFERENCES `Municipalities`(`id`);
ALTER TABLE
    `Contributions` ADD CONSTRAINT `contributions_book_id_foreign` FOREIGN KEY(`book_id`) REFERENCES `Books`(`id`);
ALTER TABLE
    `Sanctions` ADD CONSTRAINT `sanctions_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`);
ALTER TABLE
    `Routes` ADD CONSTRAINT `routes_municipality_id_foreign` FOREIGN KEY(`municipality_id`) REFERENCES `Municipalities`(`id`);
ALTER TABLE
    `Sanctions` ADD CONSTRAINT `sanctions_loan_id_foreign` FOREIGN KEY(`loan_id`) REFERENCES `Loans`(`id`);
ALTER TABLE
    `Comments` ADD CONSTRAINT `comments_book_id_foreign` FOREIGN KEY(`book_id`) REFERENCES `Books`(`id`);
ALTER TABLE
    `Routes` ADD CONSTRAINT `routes_bibus_id_foreign` FOREIGN KEY(`bibus_id`) REFERENCES `Bibus`(`id`);
ALTER TABLE
    `Contributions` ADD CONSTRAINT `contributions_author_id_foreign` FOREIGN KEY(`author_id`) REFERENCES `Authors`(`id`);
ALTER TABLE
    `Users` ADD CONSTRAINT `users_municipality_id_foreign` FOREIGN KEY(`municipality_id`) REFERENCES `Municipalities`(`id`);
ALTER TABLE
    `Reservations` ADD CONSTRAINT `reservations_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`);
ALTER TABLE
    `Publications` ADD CONSTRAINT `publications_book_id_foreign` FOREIGN KEY(`book_id`) REFERENCES `Books`(`id`);
ALTER TABLE
    `Loans` ADD CONSTRAINT `loans_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`);
ALTER TABLE
    `Books` ADD CONSTRAINT `books_author_id_foreign` FOREIGN KEY(`author_id`) REFERENCES `Authors`(`id`);
ALTER TABLE
    `Copies` ADD CONSTRAINT `copies_publication_id_foreign` FOREIGN KEY(`publication_id`) REFERENCES `Publications`(`ISBN`);