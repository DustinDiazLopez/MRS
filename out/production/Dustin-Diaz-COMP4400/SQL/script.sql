DROP SCHEMA IF EXISTS rental;
CREATE SCHEMA IF NOT EXISTS rental;
USE rental;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
	ID                 INT          NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Username           VARCHAR(70)  NOT NULL,
	AccountPassword    VARCHAR(70)  NOT NULL,
	FirstName          VARCHAR(70)  NOT NULL,
    MiddleName         VARCHAR(70),
	LastName           VARCHAR(70)  NOT NULL,
	DateOfBirth        DATE,
    Address            VARCHAR(70)  NOT NULL,
	City               VARCHAR(70)  NOT NULL,
	ZipCode            VARCHAR(70)  NOT NULL,
    Phone              VARCHAR(70),
    AccountType        VARCHAR(70)  NOT NULL,
    RentedHistory      VARCHAR(70)
);

DROP TABLE IF EXISTS Movie;
CREATE TABLE Movie(
	ID          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Title       VARCHAR(70)  NOT NULL,
	Directors   VARCHAR(70)  NOT NULL,
	Writers     VARCHAR(70)  NOT NULL,
    ReleaseDate DATE	     NOT NULL,
	Genre       VARCHAR(70)  NOT NULL,
    RunTime     VARCHAR(70)  NOT NULL,
	Rated       VARCHAR(70)  NOT NULL,
	Cast        VARCHAR(70)  NOT NULL,
    Raitings    VARCHAR(70)  NOT NULL,
    FileName    VARCHAR(70)  NOT NULL
);

DROP TABLE IF EXISTS Rental;
CREATE TABLE Rental(
	ID          INT     NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    CustomerID  INT     NOT NULL,
	MovieID     INT     NOT NULL,
	RentedOn    DATE    NOT NULL,
    ReturnedOn  DATE    NOT NULL,
	IsDVD       BOOLEAN NOT NULL,
	CostPerDay  FLOAT   NOT NULL,
    TotalDays   INT     NOT NULL,
	TotalCost   FLOAT   NOT NULL,
    CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    CONSTRAINT FK_MovieID FOREIGN KEY (MovieID) REFERENCES Movie(ID)
);

INSERT INTO User (FirstName, LastName) VALUES ('Dustin', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Marlon', 'Díaz');
INSERT INTO User (FirstName, LastName) VALUES ('Greta', 'Díaz');

SELECT * FROM User;