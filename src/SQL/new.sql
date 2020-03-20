#################################################################################### Schema MovieRentalSystem
DROP SCHEMA IF EXISTS MovieRentalSystem;
CREATE SCHEMA IF NOT EXISTS MovieRentalSystem;
USE MovieRentalSystem;

#################################################################################### Table Movies
DROP TABLE IF EXISTS Movies;
CREATE TABLE IF NOT EXISTS Movies (
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

#################################################################################### Table Directors

DROP TABLE IF EXISTS Directors;
CREATE TABLE IF NOT EXISTS Directors (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
  );

#################################################################################### Table Cast

DROP TABLE IF EXISTS Cast;
CREATE TABLE IF NOT EXISTS Cast (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
);

#################################################################################### Table Genres

DROP TABLE IF EXISTS Genres;
CREATE TABLE IF NOT EXISTS Genres (
  ID INT NOT NULL AUTO_INCREMENT,
  Genre VARCHAR(70) BINARY NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Genre_UNIQUE (Genre ASC) VISIBLE
);

#################################################################################### Table MovieDirectors
DROP TABLE IF EXISTS MovieDirectors;
CREATE TABLE IF NOT EXISTS MovieDirectors (
  MovieID INT NOT NULL,
  DirectorID INT NOT NULL,
  PRIMARY KEY (MovieID, DirectorID),
  INDEX FK_Movie_Directors_Directors_idx (DirectorID ASC) VISIBLE,
  INDEX FK_Movie_Directors_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Directors_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Directors_Directors
    FOREIGN KEY (DirectorID)
    REFERENCES Directors (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

#################################################################################### Table MovieGenres
DROP TABLE IF EXISTS MovieGenres;
CREATE TABLE IF NOT EXISTS MovieGenres (
  MovieID INT NOT NULL,
  GenreID INT NOT NULL,
  PRIMARY KEY (MovieID, GenreID),
  INDEX FK_Movie_Genres_Genres_idx (GenreID ASC) VISIBLE,
  INDEX FK_Movie_Genres_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Genres_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Genres_Genres
    FOREIGN KEY (GenreID)
    REFERENCES Genres (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

#################################################################################### Table Writers
DROP TABLE IF EXISTS Writers;
CREATE TABLE IF NOT EXISTS Writers (
  ID INT NOT NULL,
  Name VARCHAR(70) NULL,
  PRIMARY KEY (ID)
);

#################################################################################### Table MovieWriters
DROP TABLE IF EXISTS MovieWriters;
CREATE TABLE IF NOT EXISTS MovieWriters (
  MovieID INT NOT NULL,
  WriterID INT NOT NULL,
  PRIMARY KEY (MovieID, WriterID),
  INDEX FK_Movie_Writers_Writers_idx (WriterID ASC) VISIBLE,
  INDEX FK_Movie_Writers_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Writers_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Writers_Writers
    FOREIGN KEY (WriterID)
    REFERENCES Writers (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

#################################################################################### Table MovieCast
DROP TABLE IF EXISTS MovieCast;
CREATE TABLE IF NOT EXISTS MovieCast (
  MovieID INT NOT NULL,
  CastID INT NOT NULL,
  PRIMARY KEY (MovieID, CastID),
  INDEX FK_Movie_Cast_Cast_idx (CastID ASC) VISIBLE,
  INDEX FK_Movie_Cast_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Cast_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Cast_Cast
    FOREIGN KEY (CastID)
    REFERENCES Cast (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

#################################################################################### Table AccountTypes
DROP TABLE IF EXISTS AccountTypes;
CREATE TABLE IF NOT EXISTS AccountTypes (
  ID INT NOT NULL AUTO_INCREMENT,
  Type VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Type_UNIQUE (Type ASC) VISIBLE
);

#################################################################################### Table Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE IF NOT EXISTS Customers (
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
  CONSTRAINT FK_Customer_AccountType
    FOREIGN KEY (AccountTypeID)
    REFERENCES AccountTypes (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

#################################################################################### Table Medias
DROP TABLE IF EXISTS Medias;
CREATE TABLE IF NOT EXISTS Medias (
  ID INT NOT NULL,
  Media ENUM('DVD', 'BLU-RAY') NULL,
  PRIMARY KEY (ID)
);

#################################################################################### Table Rentals
DROP TABLE IF EXISTS Rentals;
CREATE TABLE IF NOT EXISTS Rentals (
  ID INT NOT NULL AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  MediaID INT NOT NULL,
  RentedOn VARCHAR(70) NULL,
  ReturnedOn VARCHAR(70) NULL,
  Returned TINYINT NOT NULL,
  TotalDays INT NULL,
  TotalCost FLOAT NULL,
  PRIMARY KEY (ID, CustomerID, MediaID),
  INDEX FK_Rental_Customer_idx (CustomerID ASC) VISIBLE,
  INDEX FK_Rental_Media_idx (MediaID ASC) VISIBLE,
  CONSTRAINT FK_Rental_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Rental_Media
    FOREIGN KEY (MediaID)
    REFERENCES Medias (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

####################################################################################
DROP TABLE IF EXISTS MovieRental;
CREATE TABLE IF NOT EXISTS MovieRental (
  MovieID INT NOT NULL,
  RentalID INT NOT NULL,
  PRIMARY KEY (MovieID, RentalID),
  INDEX FK_Movie_Rental_Rental_idx (RentalID ASC) VISIBLE,
  INDEX FK_Movie_Rental_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Rental_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Movie_Rental_Rental
    FOREIGN KEY (RentalID)
    REFERENCES Rentals (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
#################################################################################### SCHEMA END

#################################################################################### INSERT ACCOUNT TYPES
INSERT INTO AccountTypes (Type) VALUES ('USER');
INSERT INTO AccountTypes (Type) VALUES ('ADMIN');

SELECT * FROM AccountTypes WHERE ID = 1;
#################################################################################### INSERT CUSTOMERS
INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES ('dustindiaz', 'dustin123', 'Dustin', 'A.', 'Díaz', '1998-02-06', '4 Calle Aleli Urb. Round Hill', 'Trujillo Alto', '00976', '7874782095', 2);
INSERT INTO Customers (Username, AccountPassword, FirstName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES ('root', 'toor', 'Admin', 'Privelages', '1860-02-06', 'RA 0h 42m 44s | Dec +4° 6\' 9\"', 'Andromeda Galaxy', 'M3', 'Radio Waves', 2);
INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES ('dustin123', 'dustin123', 'Pedro', 'D.', 'Campo', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);

SELECT * FROM Customers;
#################################################################################### INSERT MOVIES
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Jumanji: The Next Level','2017-12-20','1h 59m','PG-13','6.8/10','jumanjithenextlevel.jpg'); #1
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Frozen 2','2019-11-22','1h 43m','PG','7/10','frozen2.jpg'); #2
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Parasite','2019-10-5','2h 12m','R','8.6/10','parasite2019.jpg'); #3
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Joker (2019 film)','2019-10-4','2h 2m','R','8.6/10','joker2019film.jpg'); #4
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Knives Out','2019-11-27','2h 10m','PG-13','8/10','knivesout.jpg'); #5
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Avengers: Endgame','2019-04-26','3h 2m','PG-13','8.5/10','marvelavengersendgame.jpg'); #6
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Jojo Rabbit','2019-11-8','1h 48m','PG-13','8/10','jojorabbit.jpg'); #7
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Charlie\'s Angels','2019-11-15','1h 58m','PG-13','4.4/10','charliesangels2019.jpg'); #8
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('All the Bright Places','2020-02-28','1h 48m','Not Yet Rated','6.5/10','allthebrightplaces.jpg'); #9
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Ford v Ferrari','2019-08-30','2h 32m','PG-13','8.1/10','fordvferrari.jpg'); #10
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Midway','2019-11-08','2h 18m','PG-13','6.7/10','midway2019.jpg'); #11
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('The Lion King','2019-07-19','1h 58m','PG','6.9/10','lionking2019.jpg'); #12
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Terminator: Dark Fate','2019-11-01','2h 8m','R','6.3/10','terminatordarkfate2019.jpg'); #13
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Bombshell','2019-12-19','1h 49m','R','6.8/10','bombshell2019.jpg'); #14
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Once Upon a Time in Hollywood','2019-07-26','2h 40m','R','7.7/10','onceuponatimeinhollyword2019.jpg'); #15
INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES ('Aladdin','2019-05-24','2h 8m','PG','7/10','aladdin2019.jpg'); #16

SELECT * FROM Movies;
#################################################################################### INSERT Directors
INSERT INTO Directors (Name) VALUES ('Anthony Russo'); #1
INSERT INTO Directors (Name) VALUES ('Chris Buck'); #2
INSERT INTO Directors (Name) VALUES ('Jennifer Lee'); #3
INSERT INTO Directors (Name) VALUES ('Bong Joon-ho'); #4
INSERT INTO Directors (Name) VALUES ('Brett Haley'); #5
INSERT INTO Directors (Name) VALUES ('Elizabeth Banks'); #6
INSERT INTO Directors (Name) VALUES ('Guy Ritchie'); #7
INSERT INTO Directors (Name) VALUES ('Jake Kasdan'); #8
INSERT INTO Directors (Name) VALUES ('James Mangold'); #9
INSERT INTO Directors (Name) VALUES ('Jay Roach'); #10
INSERT INTO Directors (Name) VALUES ('Joe Russo'); #11
INSERT INTO Directors (Name) VALUES ('Jon Favreau'); #12
INSERT INTO Directors (Name) VALUES ('Quentin Tarantino'); #13
INSERT INTO Directors (Name) VALUES ('Rian Johnson'); #14
INSERT INTO Directors (Name) VALUES ('Roland Emmerich'); #15
INSERT INTO Directors (Name) VALUES ('Taika Waititi'); #16
INSERT INTO Directors (Name) VALUES ('Tim Miller'); #17
INSERT INTO Directors (Name) VALUES ('Todd Phillips'); #18

SELECT * FROM Directors ORDER BY ID ASC;

#################################################################################### INSERT Directors
INSERT INTO Cast (Name) VALUES ('Aaron Eckhart'); #1
INSERT INTO Cast (Name) VALUES ('Al Pacino'); #2
INSERT INTO Cast (Name) VALUES ('Alex Wolff'); #3
INSERT INTO Cast (Name) VALUES ('Alexandra Shipp'); #4
INSERT INTO Cast (Name) VALUES ('Alfie Allen'); #5
INSERT INTO Cast (Name) VALUES ('Alfre Woodard'); #6
INSERT INTO Cast (Name) VALUES ('Allison Janney'); #7
INSERT INTO Cast (Name) VALUES ('Ana de Armas'); #8
INSERT INTO Cast (Name) VALUES ('Arnold Schwarzenegger'); #9
INSERT INTO Cast (Name) VALUES ('Austin Butler'); #10
INSERT INTO Cast (Name) VALUES ('Awkwafina'); #11
INSERT INTO Cast (Name) VALUES ('Benedict Wong'); #12
INSERT INTO Cast (Name) VALUES ('Beyoncé Knowles-Carter'); #13
INSERT INTO Cast (Name) VALUES ('Billy Eichner'); #14
INSERT INTO Cast (Name) VALUES ('Billy Magnussen'); #15
INSERT INTO Cast (Name) VALUES ('Brad Pitt'); #16
INSERT INTO Cast (Name) VALUES ('Bradley Cooper'); #17
INSERT INTO Cast (Name) VALUES ('Brie Larson'); #18
INSERT INTO Cast (Name) VALUES ('Bruce Dern'); #19
INSERT INTO Cast (Name) VALUES ('Chiwetel Ejiofor'); #20
INSERT INTO Cast (Name) VALUES ('Cho Yeo-jeong'); #21
INSERT INTO Cast (Name) VALUES ('Choi Woo-shik'); #22
INSERT INTO Cast (Name) VALUES ('Chris Evans'); #23
INSERT INTO Cast (Name) VALUES ('Chris Hemsworth'); #24
INSERT INTO Cast (Name) VALUES ('Christian Bale'); #25
INSERT INTO Cast (Name) VALUES ('Christopher Plummer'); #26
INSERT INTO Cast (Name) VALUES ('Connie Britton'); #27
INSERT INTO Cast (Name) VALUES ('Dakota Fanning'); #28
INSERT INTO Cast (Name) VALUES ('Danai Gurira'); #29
INSERT INTO Cast (Name) VALUES ('Danny DeVito'); #30
INSERT INTO Cast (Name) VALUES ('Danny Glover'); #31
INSERT INTO Cast (Name) VALUES ('Darren Criss'); #32
INSERT INTO Cast (Name) VALUES ('Dennis Quaid'); #33
INSERT INTO Cast (Name) VALUES ('Diego Boneta'); #34
INSERT INTO Cast (Name) VALUES ('Djimon Hounsou'); #35
INSERT INTO Cast (Name) VALUES ('Don Cheadle'); #36
INSERT INTO Cast (Name) VALUES ('Don Johnson'); #37
INSERT INTO Cast (Name) VALUES ('Elizabeth Banks'); #38
INSERT INTO Cast (Name) VALUES ('Ella Balinska'); #39
INSERT INTO Cast (Name) VALUES ('Emile Hirsch'); #40
INSERT INTO Cast (Name) VALUES ('Etsushi Toyokawa'); #41
INSERT INTO Cast (Name) VALUES ('Felix Mallard'); #42
INSERT INTO Cast (Name) VALUES ('Frances Conroy'); #43
INSERT INTO Cast (Name) VALUES ('Gabriel Luna'); #44
INSERT INTO Cast (Name) VALUES ('Gwyneth Paltrow'); #45
INSERT INTO Cast (Name) VALUES ('Idina Menzel'); #46
INSERT INTO Cast (Name) VALUES ('Jack Black'); #47
INSERT INTO Cast (Name) VALUES ('Jaeden Martell'); #48
INSERT INTO Cast (Name) VALUES ('James Earl Jones'); #49
INSERT INTO Cast (Name) VALUES ('Jamie Lee Curtis'); #50
INSERT INTO Cast (Name) VALUES ('Jang Hye-jin'); #51
INSERT INTO Cast (Name) VALUES ('Jeremy Renner'); #52
INSERT INTO Cast (Name) VALUES ('John Kani'); #53
INSERT INTO Cast (Name) VALUES ('John Lithgow'); #54
INSERT INTO Cast (Name) VALUES ('John Oliver'); #55
INSERT INTO Cast (Name) VALUES ('Jon Favreau'); #56
INSERT INTO Cast (Name) VALUES ('Jonathan Groff'); #57
INSERT INTO Cast (Name) VALUES ('Josh Brolin'); #58
INSERT INTO Cast (Name) VALUES ('Josh Gad'); #59
INSERT INTO Cast (Name) VALUES ('Jun Kunimura'); #60
INSERT INTO Cast (Name) VALUES ('Justice Smith'); #61
INSERT INTO Cast (Name) VALUES ('Karen Gillan'); #62
INSERT INTO Cast (Name) VALUES ('Kate McKinnon'); #63
INSERT INTO Cast (Name) VALUES ('Katherine Langford'); #64
INSERT INTO Cast (Name) VALUES ('Keean Johnson'); #65
INSERT INTO Cast (Name) VALUES ('Keegan-Michael Key'); #66
INSERT INTO Cast (Name) VALUES ('Kelli O\'Hara'); #67
INSERT INTO Cast (Name) VALUES ('Kevin Hart'); #68
INSERT INTO Cast (Name) VALUES ('Lakeith Stanfield'); #69
INSERT INTO Cast (Name) VALUES ('Lamar Johnson'); #70
INSERT INTO Cast (Name) VALUES ('Lee Jung-eun'); #71
INSERT INTO Cast (Name) VALUES ('Lee Sun-kyun'); #72
INSERT INTO Cast (Name) VALUES ('Luke Evans'); #73
INSERT INTO Cast (Name) VALUES ('Luke Kleintank'); #74
INSERT INTO Cast (Name) VALUES ('Luke Wilson'); #75
INSERT INTO Cast (Name) VALUES ('Mackenzie Davis'); #76
INSERT INTO Cast (Name) VALUES ('Madison Iseman'); #77
INSERT INTO Cast (Name) VALUES ('Malcolm McDowell'); #78
INSERT INTO Cast (Name) VALUES ('Mandy Moore'); #79
INSERT INTO Cast (Name) VALUES ('Margaret Qualley'); #80
INSERT INTO Cast (Name) VALUES ('Margot Robbie'); #81
INSERT INTO Cast (Name) VALUES ('Mark Ruffalo'); #82
INSERT INTO Cast (Name) VALUES ('Marwan Kenzari'); #83
INSERT INTO Cast (Name) VALUES ('Mena Massoud'); #84
INSERT INTO Cast (Name) VALUES ('Michael Shannon'); #85
INSERT INTO Cast (Name) VALUES ('Morgan Turner'); #86
INSERT INTO Cast (Name) VALUES ('Naomi Scott'); #87
INSERT INTO Cast (Name) VALUES ('Nasim Pedrad'); #88
INSERT INTO Cast (Name) VALUES ('Nat Faxon'); #89
INSERT INTO Cast (Name) VALUES ('Natalia Reyes'); #90
INSERT INTO Cast (Name) VALUES ('Navid Negahban'); #91
INSERT INTO Cast (Name) VALUES ('Nick Jonas'); #92
INSERT INTO Cast (Name) VALUES ('Nicole Kidman'); #93
INSERT INTO Cast (Name) VALUES ('Noah Centineo'); #94
INSERT INTO Cast (Name) VALUES ('Park So-dam'); #95
INSERT INTO Cast (Name) VALUES ('Patrick Stewart'); #96
INSERT INTO Cast (Name) VALUES ('Patrick Wilson'); #97
INSERT INTO Cast (Name) VALUES ('Paul Rudd'); #98
INSERT INTO Cast (Name) VALUES ('Rebel Wilson'); #99
INSERT INTO Cast (Name) VALUES ('Robert De Niro'); #100
INSERT INTO Cast (Name) VALUES ('Sam Claflin'); #101
INSERT INTO Cast (Name) VALUES ('Sam Rockwell'); #102
INSERT INTO Cast (Name) VALUES ('Scarlett Johansson'); #103
INSERT INTO Cast (Name) VALUES ('Ser\'Darius Blain'); #104
INSERT INTO Cast (Name) VALUES ('Seth Rogen'); #105
INSERT INTO Cast (Name) VALUES ('Sofia Hasmik'); #106
INSERT INTO Cast (Name) VALUES ('Stephen Merchant'); #107
INSERT INTO Cast (Name) VALUES ('Tadanobu Asano'); #108
INSERT INTO Cast (Name) VALUES ('Taika Waititi'); #109
INSERT INTO Cast (Name) VALUES ('Thomasin McKenzie'); #110
INSERT INTO Cast (Name) VALUES ('Timothy Olyphant'); #111
INSERT INTO Cast (Name) VALUES ('Toni Collette'); #112
INSERT INTO Cast (Name) VALUES ('Virginia Gardner'); #113
INSERT INTO Cast (Name) VALUES ('Woody Harrelson'); #114
INSERT INTO Cast (Name) VALUES ('Zazie Beetz'); #115
INSERT INTO Cast (Name) VALUES ('Charlize Theron'); #116
INSERT INTO Cast (Name) VALUES ('Daniel Craig'); #117
INSERT INTO Cast (Name) VALUES ('Donald Glover'); #118
INSERT INTO Cast (Name) VALUES ('Dwayne Johnson'); #119
INSERT INTO Cast (Name) VALUES ('Ed Skrein'); #120
INSERT INTO Cast (Name) VALUES ('Elle Fanning'); #121
INSERT INTO Cast (Name) VALUES ('Joaquin Phoenix'); #122
INSERT INTO Cast (Name) VALUES ('Kristen Bell'); #123
INSERT INTO Cast (Name) VALUES ('Kristen Stewart'); #124
INSERT INTO Cast (Name) VALUES ('Leonardo DiCaprio'); #125
INSERT INTO Cast (Name) VALUES ('Linda Hamilton'); #126
INSERT INTO Cast (Name) VALUES ('Matt Damon'); #127
INSERT INTO Cast (Name) VALUES ('Robert Downey Jr.'); #128
INSERT INTO Cast (Name) VALUES ('Roman Griffin Davis'); #129
INSERT INTO Cast (Name) VALUES ('Song Kang-ho'); #130
INSERT INTO Cast (Name) VALUES ('Will Smith'); #131

SELECT * FROM Cast ORDER BY ID ASC;

#################################################################################### INSERT Genre
INSERT INTO Genres (Genre) VALUES ('Action'); #1
INSERT INTO Genres (Genre) VALUES ('Adventure'); #2
INSERT INTO Genres (Genre) VALUES ('Comedy-drama'); #3
INSERT INTO Genres (Genre) VALUES ('Drama'); #4
INSERT INTO Genres (Genre) VALUES ('Fantasy'); #5
INSERT INTO Genres (Genre) VALUES ('History'); #6
INSERT INTO Genres (Genre) VALUES ('Music'); #7
INSERT INTO Genres (Genre) VALUES ('Mystery'); #8
INSERT INTO Genres (Genre) VALUES ('Romance'); #9
INSERT INTO Genres (Genre) VALUES ('Sci-fi'); #10
INSERT INTO Genres (Genre) VALUES ('Sport'); #11
INSERT INTO Genres (Genre) VALUES ('Thriller'); #12

SELECT * FROM Genres ORDER BY ID ASC;

#################################################################################### INSERT Table