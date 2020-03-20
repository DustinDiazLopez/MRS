#################################################################################### SCHEMA
DROP SCHEMA IF EXISTS MovieRentalSystem;
CREATE SCHEMA IF NOT EXISTS MovieRentalSystem;
USE MovieRentalSystem;
#################################################################################### MOVIE
DROP TABLE IF EXISTS Movie;
CREATE TABLE IF NOT EXISTS Movie (
  ID INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(70) NOT NULL,
  ReleaseDate VARCHAR(70) NOT NULL,
  RunTime VARCHAR(70) NOT NULL,
  Rated VARCHAR(70) NOT NULL,
  Ratings VARCHAR(70) NOT NULL,
  Filename VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Title_UNIQUE (Title ASC) VISIBLE,
  UNIQUE INDEX ID_UNIQUE (ID ASC) VISIBLE
  );
#################################################################################### DIRECTORS
DROP TABLE IF EXISTS Directors;
CREATE TABLE IF NOT EXISTS Directors (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(70) NOT NULL,
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
  );
#################################################################################### CAST
DROP TABLE IF EXISTS Cast;
CREATE TABLE IF NOT EXISTS Cast (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(70) NOT NULL,
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
  );
#################################################################################### GENRES
DROP TABLE IF EXISTS Genres;
CREATE TABLE IF NOT EXISTS Genres (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Genre VARCHAR(70) BINARY NOT NULL,
  UNIQUE INDEX Genre_UNIQUE (Genre ASC) VISIBLE
  );
#################################################################################### MOVIE DIRECTORS
DROP TABLE IF EXISTS MovieDirectors;
CREATE TABLE IF NOT EXISTS MovieDirectors (
  MovieID INT NOT NULL,
  DirectorID INT NOT NULL,
  PRIMARY KEY (MovieID, DirectorID),
  INDEX FK_Movie_Directors_Directors_idx (DirectorID ASC) VISIBLE,
  INDEX FK_Movie_Directors_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Directors_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movie (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Directors_Directors FOREIGN KEY (DirectorID) REFERENCES Directors (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### MOVIE GENRES
DROP TABLE IF EXISTS MovieGenres;
CREATE TABLE IF NOT EXISTS MovieGenres (
  MovieID INT NOT NULL,
  GenreID INT NOT NULL,
  PRIMARY KEY (MovieID, GenreID),
  INDEX FK_Movie_Genres_Genres_idx (GenreID ASC) VISIBLE,
  INDEX FK_Movie_Genres_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Genres_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movie (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Genres_Genres FOREIGN KEY (GenreID) REFERENCES Genres (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### WRITERS
DROP TABLE IF EXISTS Writers;
CREATE TABLE IF NOT EXISTS Writers (
  ID INT NOT NULL PRIMARY KEY,
  Name VARCHAR(70) NULL
  );
#################################################################################### MOVIE WRITERS
DROP TABLE IF EXISTS MovieWriters;
CREATE TABLE IF NOT EXISTS MovieWriters (
  MovieID INT NOT NULL,
  WriterID INT NOT NULL,
  PRIMARY KEY (MovieID, WriterID),
  INDEX FK_Movie_Writers_Writers_idx (WriterID ASC) VISIBLE,
  INDEX FK_Movie_Writers_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Writers_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movie (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Writers_Writers FOREIGN KEY (WriterID) REFERENCES Writers (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### MOVIE CAST
DROP TABLE IF EXISTS MovieCast;
CREATE TABLE IF NOT EXISTS MovieCast (
  MovieID INT NOT NULL,
  CastID INT NOT NULL,
  PRIMARY KEY (MovieID, CastID),
  INDEX FK_Movie_Cast_Cast_idx (CastID ASC) VISIBLE,
  INDEX FK_Movie_Cast_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Cast_Movie FOREIGN KEY (MovieID) REFERENCES Movie (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Cast_Cast FOREIGN KEY (CastID) REFERENCES Cast (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### ACCOUNT TYPE
DROP TABLE IF EXISTS AccountType;
CREATE TABLE IF NOT EXISTS AccountType (
  ID INT NOT NULL AUTO_INCREMENT,
  Type VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Type_UNIQUE (Type ASC) VISIBLE
  );
#################################################################################### CUSTOMER
DROP TABLE IF EXISTS Customer;
CREATE TABLE IF NOT EXISTS Customer (
  ID INT NOT NULL AUTO_INCREMENT,
  Username VARCHAR(70) NOT NULL,
  AccountPassword VARCHAR(70) NULL,
  AccountTypeID INT NOT NULL,
  FirstName VARCHAR(70) NOT NULL,
  MiddleName VARCHAR(70) NULL,
  LastName VARCHAR(70) NOT NULL,
  DateOfBirth VARCHAR(70) NULL,
  Address VARCHAR(70) NOT NULL,
  City VARCHAR(70) NOT NULL,
  ZipCode VARCHAR(70) NOT NULL,
  Phone VARCHAR(70) NULL,
  PRIMARY KEY (ID, AccountTypeID),
  UNIQUE INDEX Username_UNIQUE (Username ASC) VISIBLE,
  UNIQUE INDEX ID_UNIQUE (ID ASC) VISIBLE,
  INDEX FK_Customer_AccountType_idx (AccountTypeID ASC) VISIBLE,
  CONSTRAINT FK_Customer_AccountType FOREIGN KEY (AccountTypeID) REFERENCES AccountType (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### MEDIA
DROP TABLE IF EXISTS Media;
CREATE TABLE IF NOT EXISTS Media (
  ID INT NOT NULL PRIMARY KEY,
  Media ENUM('DVD', 'BLU-RAY') NULL
  );
#################################################################################### RENTAL
DROP TABLE IF EXISTS Rental;
CREATE TABLE IF NOT EXISTS Rental (
  ID INT NOT NULL AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  MovieID INT NOT NULL,
  MediaID INT NOT NULL,
  RentedOn VARCHAR(70) NULL,
  ReturnedOn VARCHAR(70) NULL,
  Returned TINYINT NOT NULL,
  TotalDays INT NULL,
  TotalCost FLOAT NULL,
  PRIMARY KEY (ID, CustomerID, MovieID, MediaID),
  INDEX FK_Rental_Customer_idx (CustomerID ASC) VISIBLE,
  INDEX FK_Rental_Movie_idx (MovieID ASC) VISIBLE,
  INDEX FK_Rental_Media_idx (MediaID ASC) VISIBLE,
  CONSTRAINT FK_Rental_Customer FOREIGN KEY (CustomerID) REFERENCES Customer (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Rental_Movie FOREIGN KEY (MovieID) REFERENCES Movie (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Rental_Media FOREIGN KEY (MediaID) REFERENCES Media (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );
#################################################################################### END
