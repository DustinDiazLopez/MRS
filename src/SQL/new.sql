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
  ID INT NOT NULL AUTO_INCREMENT,
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
  ID INT NOT NULL AUTO_INCREMENT,
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
INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('dustindiaz', 'dustin123', 'Dustin', 'A.', 'Díaz', '1998-02-06', '4 Calle Aleli Urb. Round Hill', 'Trujillo Alto', '00976', '7874782095', 2);

INSERT INTO Customers (Username, AccountPassword, FirstName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('root', 'toor', 'Admin', 'Privelages', '1860-02-06', 'RA 0h 42m 44s | Dec +4° 6\' 9\"', 'Andromeda Galaxy', 'M3', 'Radio Waves', 2);

INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('dustin123', 'asd', 'Pedro', 'A.', 'Díaza', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);

INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('dustina', 'asd', 'dustina', 'E.', 'Díaze', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);

INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('dustino', 'asd', 'dustino', 'I.', 'Díazo', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);

INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID)
VALUES ('dustine', 'asd', 'dustine', 'O.', 'Díazu', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);

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
INSERT INTO Directors (Name) VALUES ('Bong Joon-ho'); #3
INSERT INTO Directors (Name) VALUES ('Brett Haley'); #4
INSERT INTO Directors (Name) VALUES ('Elizabeth Banks'); #5
INSERT INTO Directors (Name) VALUES ('Guy Ritchie'); #6
INSERT INTO Directors (Name) VALUES ('Jake Kasdan'); #7
INSERT INTO Directors (Name) VALUES ('James Mangold'); #8
INSERT INTO Directors (Name) VALUES ('Jay Roach'); #9
INSERT INTO Directors (Name) VALUES ('Jennifer Lee'); #10
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

#################################################################################### INSERT MovieDirectors

INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (1, 7); # Jake Kasdan directs Jumanji: The Next Level
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (2, 2); #  Chris Buck directs Frozen 2
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (2, 10); # Jennifer Lee directs Frozen 2
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (3, 3); # Bong Joon-ho directs Parasite
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (4, 18); # Todd Phillips directs Joker (2019 film)
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (5, 14); # Rian Johnson directs Knives Out
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (6, 1); #  Anthony Russo directs Avengers: Endgame
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (6, 11); # Joe Russo directs Avengers: Endgame
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (6, 12); # Jon Favreau directs Avengers: Endgame
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (7, 16); # Taika Waititi directs Jojo Rabbit
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (8, 5); # Elizabeth Banks directs Charlie\'s Angels
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (9, 4); # Brett Haley directs All the Bright Places
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (10, 8); # James Mangold directs Ford v Ferrari
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (11, 15); # Roland Emmerich directs Midway
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (12, 12); # Jon Favreau directs The Lion King
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (13, 17); # Tim Miller directs Terminator: Dark Fate
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (14, 9); # Jay Roach directs Bombshell
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (15, 13); # Quentin Tarantino directs Once Upon a Time in Hollywood
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES (16, 6); # Guy Ritchie directs Aladdin

SELECT * FROM MovieDirectors ORDER BY MovieID ASC;
#################################################################################### INSERT Writers

INSERT INTO Writers (Name) VALUES ('Allison Schroeder'); #1
INSERT INTO Writers (Name) VALUES ('Billy Ray'); #2
INSERT INTO Writers (Name) VALUES ('Christopher Markus'); #3
INSERT INTO Writers (Name) VALUES ('David Auburn'); #4
INSERT INTO Writers (Name) VALUES ('David S. Goyer'); #5
INSERT INTO Writers (Name) VALUES ('Elizabeth Hannah'); #6
INSERT INTO Writers (Name) VALUES ('Erik Sommers'); #7
INSERT INTO Writers (Name) VALUES ('Han Jin-won'); #8
INSERT INTO Writers (Name) VALUES ('Jason Keller'); #9
INSERT INTO Writers (Name) VALUES ('Jeff Pinkner'); #10
INSERT INTO Writers (Name) VALUES ('Jez Butterworth'); #11
INSERT INTO Writers (Name) VALUES ('John August'); #12
INSERT INTO Writers (Name) VALUES ('John-Henry Butterworth'); #13
INSERT INTO Writers (Name) VALUES ('Justin Rhodes'); #14
INSERT INTO Writers (Name) VALUES ('Scott Silver'); #15
INSERT INTO Writers (Name) VALUES ('Bong Joon-ho'); #16
INSERT INTO Writers (Name) VALUES ('Charles Randolph'); #17
INSERT INTO Writers (Name) VALUES ('David Ellison'); #18
INSERT INTO Writers (Name) VALUES ('Elizabeth Banks'); #19
INSERT INTO Writers (Name) VALUES ('Guy Ritchie'); #20
INSERT INTO Writers (Name) VALUES ('James Mangold'); #21
INSERT INTO Writers (Name) VALUES ('Jeff Nathanson'); #22
INSERT INTO Writers (Name) VALUES ('Jennifer Lee'); #23
INSERT INTO Writers (Name) VALUES ('Jennifer Niven'); #24
INSERT INTO Writers (Name) VALUES ('Quentin Tarantino'); #25
INSERT INTO Writers (Name) VALUES ('Rian Johnson'); #26
INSERT INTO Writers (Name) VALUES ('Scott Rosenberg'); #27
INSERT INTO Writers (Name) VALUES ('Stephen McFeely'); #28
INSERT INTO Writers (Name) VALUES ('Taika Waititi'); #29
INSERT INTO Writers (Name) VALUES ('Todd Phillips'); #30
INSERT INTO Writers (Name) VALUES ('Wes Tooke'); #31

SELECT * FROM Writers ORDER BY ID ASC;

#################################################################################### INSERT MovieGenres
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (1, 1); # Jumanji: The Next Level is Action
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (1, 5); # Jumanji: The Next Level is Fantasy
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (2, 4); # Frozen 2 is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (2, 5); # Frozen 2 is Fantasy
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (3, 4); # Parasite is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (3, 8); # Parasite is Mystery
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (4, 4); # Joker (2019 film) is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (4, 12); # Joker (2019 film) is Thriller
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (5, 4); # Knives Out is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (5, 12); # Knives Out is Thriller
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (6, 5); # Avengers: Endgame is Fantasy
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (6, 10); # Avengers: Endgame is Sci-fi
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (7, 3); # Jojo Rabbit is Comedy-drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (7, 4); # Jojo Rabbit is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (8, 1); # Charlie\'s Angels is Action
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (8, 2); # Charlie\'s Angels is Adventure
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (9, 4); # All the Bright Places is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (9, 9); # All the Bright Places is Romance
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (10, 4); # Ford v Ferrari is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (10, 11); # Ford v Ferrari is Sport
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (11, 4); # Midway is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (11, 6); # Midway is History
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (12, 4); # The Lion King is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (12, 7); # The Lion King is Music
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (13, 5); # Terminator: Dark Fate is Fantasy
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (13, 10); # Terminator: Dark Fate is Sci-fi
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (14, 4); # Bombshell is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (15, 3); # Once Upon a Time in Hollywood is Comedy-drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (15, 4); # Once Upon a Time in Hollywood is Drama
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (16, 5); # Aladdin is Fantasy
INSERT INTO MovieGenres (MovieID, GenreID) VALUES (16, 9); # Aladdin is Romance

SELECT * FROM MovieGenres ORDER BY MovieID ASC;

#################################################################################### INSERT MovieWriters

INSERT INTO MovieWriters (MovieID, WriterID) VALUES (1, 7); # Jumanji: The Next Level is directed by Erik Sommers
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (1, 10); # Jumanji: The Next Level is directed by Jeff Pinkner
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (1, 27); # Jumanji: The Next Level is directed by Scott Rosenberg
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (2, 1); # Frozen 2 is directed by Allison Schroeder
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (2, 23); # Frozen 2 is directed by Jennifer Lee
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (3, 8); # Parasite is directed by Han Jin-won
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (3, 16); # Parasite is directed by Bong Joon-ho
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (4, 15); # Joker (2019 film) is directed by Scott Silver
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (4, 30); # Joker (2019 film) is directed by Todd Phillips
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (5, 26); # Knives Out is directed by Rian Johnson
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (6, 3); # Avengers: Endgame is directed by Christopher Markus
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (6, 28); # Avengers: Endgame is directed by Stephen McFeely
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (7, 29); # Jojo Rabbit is directed by Taika Waititi
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (8, 4); # Charlie\'s Angels is directed by David Auburn
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (8, 19); # Charlie\'s Angels is directed by Elizabeth Banks
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (9, 6); # All the Bright Places is directed by Elizabeth Hannah
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (9, 24); # All the Bright Places is directed by Jennifer Niven
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (10, 9); # Ford v Ferrari is directed by Jason Keller
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (10, 11); # Ford v Ferrari is directed by Jez Butterworth
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (10, 13); # Ford v Ferrari is directed by John-Henry Butterworth
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (10, 21); # Ford v Ferrari is directed by James Mangold
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (11, 31); # Midway is directed by Wes Tooke
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (12, 22); # The Lion King is directed by Jeff Nathanson
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (13, 2); # Terminator: Dark Fate is directed by Billy Ray
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (13, 5); # Terminator: Dark Fate is directed by David S. Goyer
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (13, 14); # Terminator: Dark Fate is directed by Justin Rhodes
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (13, 18); # Terminator: Dark Fate is directed by David Ellison
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (14, 17); # Bombshell is directed by Charles Randolph
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (15, 25); # Once Upon a Time in Hollywood is directed by Quentin Tarantino
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (16, 12); # Aladdin is directed by John August
INSERT INTO MovieWriters (MovieID, WriterID) VALUES (16, 20); # Aladdin is directed by Guy Ritchie

SELECT * FROM MovieWriters ORDER BY MovieID ASC;

#################################################################################### INSERT MovieCast

INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 3); # Alex Wolff is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 11); # Awkwafina is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 30); # Danny DeVito is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 31); # Danny Glover is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 47); # Jack Black is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 62); # Karen Gillan is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 68); # Kevin Hart is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 77); # Madison Iseman is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 86); # Morgan Turner is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 92); # Nick Jonas is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 104); # Ser\'Darius Blain is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (1, 119); # Dwayne Johnson is in Jumanji: The Next Level
INSERT INTO MovieCast (MovieID, CastID) VALUES (2, 46); # Idina Menzel is in Frozen 2
INSERT INTO MovieCast (MovieID, CastID) VALUES (2, 57); # Jonathan Groff is in Frozen 2
INSERT INTO MovieCast (MovieID, CastID) VALUES (2, 59); # Josh Gad is in Frozen 2
INSERT INTO MovieCast (MovieID, CastID) VALUES (2, 123); # Kristen Bell is in Frozen 2
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 21); # Cho Yeo-jeong is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 22); # Choi Woo-shik is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 51); # Jang Hye-jin is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 71); # Lee Jung-eun is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 72); # Lee Sun-kyun is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 95); # Park So-dam is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (3, 130); # Song Kang-ho is in Parasite
INSERT INTO MovieCast (MovieID, CastID) VALUES (4, 43); # Frances Conroy is in Joker (2019 film)
INSERT INTO MovieCast (MovieID, CastID) VALUES (4, 100); # Robert De Niro is in Joker (2019 film)
INSERT INTO MovieCast (MovieID, CastID) VALUES (4, 115); # Zazie Beetz is in Joker (2019 film)
INSERT INTO MovieCast (MovieID, CastID) VALUES (4, 122); # Joaquin Phoenix is in Joker (2019 film)
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 8); # Ana de Armas is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 23); # Chris Evans is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 26); # Christopher Plummer is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 37); # Don Johnson is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 48); # Jaeden Martell is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 50); # Jamie Lee Curtis is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 64); # Katherine Langford is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 69); # Lakeith Stanfield is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 85); # Michael Shannon is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 112); # Toni Collette is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (5, 117); # Daniel Craig is in Knives Out
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 12); # Benedict Wong is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 17); # Bradley Cooper is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 18); # Brie Larson is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 23); # Chris Evans is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 24); # Chris Hemsworth is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 29); # Danai Gurira is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 36); # Don Cheadle is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 45); # Gwyneth Paltrow is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 52); # Jeremy Renner is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 56); # Jon Favreau is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 58); # Josh Brolin is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 62); # Karen Gillan is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 82); # Mark Ruffalo is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 98); # Paul Rudd is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 103); # Scarlett Johansson is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (6, 128); # Robert Downey Jr. is in Avengers: Endgame
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 5); # Alfie Allen is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 99); # Rebel Wilson is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 102); # Sam Rockwell is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 103); # Scarlett Johansson is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 107); # Stephen Merchant is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 109); # Taika Waititi is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 110); # Thomasin McKenzie is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (7, 129); # Roman Griffin Davis is in Jojo Rabbit
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 35); # Djimon Hounsou is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 38); # Elizabeth Banks is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 39); # Ella Balinska is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 87); # Naomi Scott is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 89); # Nat Faxon is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 94); # Noah Centineo is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 96); # Patrick Stewart is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 101); # Sam Claflin is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 124); # Kristen Stewart is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 4); # Alexandra Shipp is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 42); # Felix Mallard is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 61); # Justice Smith is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 66); # Keegan-Michael Key is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 67); # Kelli O\'Hara is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 70); # Lamar Johnson is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 75); # Luke Wilson is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 106); # Sofia Hasmik is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 113); # Virginia Gardner is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 121); # Elle Fanning is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (10, 25); # Christian Bale is in Ford v Ferrari
INSERT INTO MovieCast (MovieID, CastID) VALUES (10, 127); # Matt Damon is in Ford v Ferrari
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 1); # Aaron Eckhart is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 32); # Darren Criss is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 33); # Dennis Quaid is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 41); # Etsushi Toyokawa is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 60); # Jun Kunimura is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 65); # Keean Johnson is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 73); # Luke Evans is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 74); # Luke Kleintank is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 79); # Mandy Moore is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 92); # Nick Jonas is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 97); # Patrick Wilson is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 108); # Tadanobu Asano is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 114); # Woody Harrelson is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (11, 120); # Ed Skrein is in Midway
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 6); # Alfre Woodard is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 13); # Beyoncé Knowles-Carter is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 14); # Billy Eichner is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 20); # Chiwetel Ejiofor is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 49); # James Earl Jones is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 53); # John Kani is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 55); # John Oliver is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 105); # Seth Rogen is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (12, 118); # Donald Glover is in The Lion King
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 9); # Arnold Schwarzenegger is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 34); # Diego Boneta is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 44); # Gabriel Luna is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 76); # Mackenzie Davis is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 90); # Natalia Reyes is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (13, 126); # Linda Hamilton is in Terminator: Dark Fate
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 7); # Allison Janney is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 27); # Connie Britton is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 54); # John Lithgow is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 63); # Kate McKinnon is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 78); # Malcolm McDowell is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 81); # Margot Robbie is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 93); # Nicole Kidman is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (14, 116); # Charlize Theron is in Bombshell
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 2); # Al Pacino is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 10); # Austin Butler is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 16); # Brad Pitt is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 19); # Bruce Dern is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 28); # Dakota Fanning is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 40); # Emile Hirsch is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 80); # Margaret Qualley is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 81); # Margot Robbie is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 111); # Timothy Olyphant is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (15, 125); # Leonardo DiCaprio is in Once Upon a Time in Hollywood
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 15); # Billy Magnussen is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 83); # Marwan Kenzari is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 84); # Mena Massoud is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 87); # Naomi Scott is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 88); # Nasim Pedrad is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 91); # Navid Negahban is in Aladdin
INSERT INTO MovieCast (MovieID, CastID) VALUES (16, 131); # Will Smith is in Aladdin

SELECT * FROM MovieCast ORDER BY MovieID ASC;

#################################################################################### INSERT Medias

INSERT INTO Medias (Media) VALUES ('DVD');
INSERT INTO Medias (Media) VALUES ('BLU-RAY');

SELECT * FROM Medias;

#################################################################################### INSERT Rentals

INSERT INTO Rentals (CustomerID, MediaID, RentedOn, ReturnedOn, Returned, TotalDays, TotalCost)
VALUES (3, 1, '2020-3-15', '2020-3-20', true, 5, 10.0); #1

INSERT INTO Rentals (CustomerID, MediaID, RentedOn, ReturnedOn, Returned, TotalDays, TotalCost)
VALUES (3, 2, '2020-3-15', '2020-3-20', true, 5, 15.0); #2

SELECT * FROM Rentals;

#################################################################################### INSERT MovieRental

INSERT INTO MovieRental (MovieID, RentalID) VALUES (2, 1);
INSERT INTO MovieRental (MovieID, RentalID) VALUES (5, 2);

SELECT * FROM MovieRental ORDER BY MovieID ASC;

#################################################################################### SELECT JOINS

##### Customer and AccountType (ROLE) #####
SELECT c.ID, c.Username, c.AccountPassword, a.Type AS AccountType, c.FirstName, c.MiddleName, c.LastName, c.DateOfBirth,
c.Address, c.City, c.ZipCode, c.Phone FROM Customers c INNER JOIN AccountTypes a ON (c.AccountTypeID = a.ID);

##### table and table (ROLE) #####


#################################################################################### SELECT All from table
SELECT * FROM AccountTypes;
SELECT * FROM Customers;
SELECT * FROM Movies;
SELECT * FROM Directors ORDER BY ID ASC;
SELECT * FROM Writers ORDER BY ID ASC;
SELECT * FROM Cast ORDER BY ID ASC;
SELECT * FROM Genres ORDER BY ID ASC;
SELECT * FROM MovieDirectors ORDER BY MovieID ASC;
SELECT * FROM MovieGenres ORDER BY MovieID ASC;
SELECT * FROM MovieWriters ORDER BY MovieID ASC;
SELECT * FROM MovieCast ORDER BY MovieID ASC;
SELECT * FROM Medias;
SELECT * FROM Rentals;
SELECT * FROM MovieRental ORDER BY MovieID ASC;