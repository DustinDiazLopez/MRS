DROP SCHEMA IF EXISTS rental;
CREATE SCHEMA IF NOT EXISTS rental;
USE rental;

DROP TABLE IF EXISTS User;
CREATE TABLE User(
	ID        INT          NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Username  VARCHAR(45)  NOT NULL,
	`Password` VARCHAR(45)  NOT NULL,
	FirstName  VARCHAR(70)  NOT NULL,
    MiddleName  VARCHAR(45),
	LastName VARCHAR(45)  NOT NULL,
	DateOfBirth  DATE,
    Address  VARCHAR(45)  NOT NULL,
	City VARCHAR(45)  NOT NULL,
	ZipCode  VARCHAR(70)  NOT NULL
    
);

INSERT INTO User (FirstName, LastName) VALUES ('Dustin', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Marlon', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Greta', 'Díaz');

SELECT * FROM User;