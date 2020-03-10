DROP SCHEMA IF EXISTS rental;
CREATE SCHEMA IF NOT EXISTS rental;
USE rental;

DROP TABLE IF EXISTS User;
CREATE TABLE User(
	ID        BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
	FirstName VARCHAR(45)  NOT NULL,
	LastName  VARCHAR(70)  NOT NULL
);

INSERT INTO User (FirstName, LastName) VALUES ('Dustin', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Marlon', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Greta', 'Díaz');

SELECT * FROM User;