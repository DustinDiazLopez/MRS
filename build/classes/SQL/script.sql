DROP SCHEMA IF EXISTS rental;
CREATE SCHEMA IF NOT EXISTS rental;
USE rental;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
	ID                 INT                     NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Username           VARCHAR(70)             NOT NULL UNIQUE,
	AccountPassword    VARCHAR(70)             NOT NULL,
	FirstName          VARCHAR(70)             NOT NULL,
    MiddleName         VARCHAR(70),
	LastName           VARCHAR(70)             NOT NULL,
	DateOfBirth        VARCHAR(70),
    Address            VARCHAR(70)             NOT NULL,
	City               VARCHAR(70)             NOT NULL,
	ZipCode            VARCHAR(70)             NOT NULL,
    Phone              VARCHAR(70),
    AccountType        ENUM ('ADMIN', 'USER')  NOT NULL,
    RentedHistory      VARCHAR(70)
);

DROP TABLE IF EXISTS Movie;
CREATE TABLE Movie(
	ID          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Title       VARCHAR(70)  NOT NULL,
	Directors   TEXT         NOT NULL,
	Writers     TEXT         NOT NULL,
    ReleaseDate VARCHAR(70)	 NOT NULL,
	Genre       VARCHAR(70)  NOT NULL,
    RunTime     VARCHAR(70)  NOT NULL,
	Rated       VARCHAR(70)  NOT NULL,
	Cast        TEXT         NOT NULL,
    Ratings     VARCHAR(70)  NOT NULL,
    Filename    VARCHAR(70)  NOT NULL
);

DROP TABLE IF EXISTS Rental;
CREATE TABLE Rental(
	ID          INT                     NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    CustomerID  INT                     NOT NULL,
	MovieID     INT                     NOT NULL,
	RentedOn    VARCHAR(70)             NOT NULL,
    Media       ENUM ('DVD', 'BLU-RAY') NOT NULL,
    ReturnedOn  VARCHAR(70),
    Returned    BOOLEAN,
    TotalDays   INT,
	TotalCost   FLOAT,
    CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    CONSTRAINT FK_MovieID FOREIGN KEY (MovieID) REFERENCES Movie(ID)
);

INSERT INTO Customer (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountType) VALUES ('dustindiaz', 'dustin123', 'Dustin', 'A.', 'Díaz', '1998-02-06', '1411 Calle Aleli Urb. Round Hill', 'Trujillo Alto', '00976', '7874782095', 'ADMIN');
INSERT INTO Customer (Username, AccountPassword, FirstName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountType) VALUES ('root', 'toor', 'Admin', 'Privelages', '1860-02-06', 'RA 0h 42m 44s | Dec +41° 16\' 9\"', 'Andromeda Galaxy', 'M31', 'Radio Waves', 'ADMIN');
INSERT INTO Customer (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountType) VALUES ('dustin123', 'dustin123', 'Pedro', 'D.', 'Campo', '1996-12-06', 'El Campo', 'Rio Campo', '00761', '1234567890', 'USER');

INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Jumanji: The Next Level','Jake Kasdan','Scott Rosenberg, Jeff Pinkner, Erik Sommers, Chris McKenna','2017-12-20','Fantasy/Action','1h 59m','PG-13','Dwayne Johnson, Jack Black, Kevin Hart, Karen Gillan, Nick Jonas, Awkwafina, Alex Wolff, Morgan Turner, SerDarius Blain, Madison Iseman, Danny Glover, Danny DeVito','6.8/10,71%','jumanjithenextlevel.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Frozen 2','Jennifer Lee, Chris Buck, Jennifer Lee','Jennifer Lee, Allison Schroeder','2019-11-22','Drama/Fantasy','1h 43m','PG','Kristen Bell, Idina Menzel, Josh Gad, Jonathan Groff','7/10,77%','frozen2.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Parasite','Bong Joon-ho','Bong Joon-ho, Han Jin-won','2019-10-5','Drama/Mystery','2h 12m','R','Song Kang-ho, Lee Sun-kyun, Cho Yeo-jeong, Choi Woo-shik, Park So-dam, Lee Jung-eun, Jang Hye-jin','8.6/10,99%','parasite2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Joker (2019 film)','Todd Phillips','Todd Phillips, Scott Silver','2019-10-4','Drama/Thriller','2h 2m','R','Joaquin Phoenix, Robert De Niro, Zazie Beetz, Frances Conroy','8.6/10,68%','joker2019film.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Knives Out','Rian Johnson','Rian Johnson','2019-11-27','Drama/Thriller','2h 10m','PG-13','Daniel Craig, Chris Evans, Ana de Armas, Jamie Lee Curtis, Michael Shannon, Don Johnson, Toni Collette, Lakeith Stanfield, Katherine Langford, Jaeden Martell, Christopher Plummer','8/10,87%','knivesout.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Avengers: Endgame','Joe Russo, Anthony Russo','Stephen McFeely, Christopher Markus','2019-04-26','Fantasy/Sci-fi','3h 2m','PG-13','Robert Downey Jr., Chris Evans, Mark Ruffalo, Chris Hemsworth, Scarlett Johansson, Jeremy Renner, Don Cheadle, Paul Rudd, Brie Larson, Karen Gillan, Danai Gurira, Benedict Wong, Jon Favreau, Bradley Cooper, Gwyneth Paltrow, Josh Brolin','8.5/10,94%','marvelavengersendgame.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Jojo Rabbit','Taika Waititi','Taika Waititi','2019-11-8','Drama/Comedy-drama','1h 48m','PG-13','Roman Griffin Davis, Thomasin McKenzie, Taika Waititi, Rebel Wilson, Stephen Merchant, Alfie Allen, Sam Rockwell, Scarlett Johansson','8/10,80%','jojorabbit.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Charlies Angels','Elizabeth Banks','Elizabeth Banks, David Auburn','2019-11-15','Action/Adventure','1h 58m','PG-13','Kristen Stewart, Naomi Scott, Ella Balinska, Elizabeth Banks, Djimon Hounsou, Sam Claflin, Noah Centineo, Nat Faxon, Patrick Stewart','4.4/10,52%','charliesangels2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('All the Bright Places','Brett Haley','Jennifer Niven, Elizabeth Hannah','2020-02-28','Drama/Romance','1h 48m','Not Yet Rated','Elle Fanning, Justice Smith, Alexandra Shipp, Kelli OHara, Lamar Johnson, Virginia Gardner, Felix Mallard, Sofia Hasmik, Keegan-Michael Key, Luke Wilson','6.5/10,77%','allthebrightplaces.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Ford v Ferrari','James Mangold','James Mangold, John-Henry Butterworth, Jez Butterworth, Jason Keller','2019-08-30','Drama/Sport','2h 32m','PG-13','Matt Damon, Christian Bale','8.1/10,92%','fordvferrari.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Midway','Roland Emmerich','Wes Tooke','2019-11-08','Drama/History','2h 18m','PG-13','Ed Skrein, Patrick Wilson, Luke Evans, Aaron Eckhart, Nick Jonas, Etsushi Toyokawa, Tadanobu Asano, Luke Kleintank, Jun Kunimura, Darren Criss, Keean Johnson, Mandy Moore, Dennis Quaid, Woody Harrelson','6.7/10,43%','midway2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('The Lion King','Jon Favreau','Jeff Nathanson','2019-07-19','Drama/Music','1h 58m','PG','Donald Glover, Seth Rogen, Chiwetel Ejiofor, Alfre Woodard, Billy Eichner, John Kani, John Oliver, Beyoncé Knowles-Carter, James Earl Jones','6.9/10,53%','lionking2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Terminator: Dark Fate','Tim Miller','David Ellison, David S. Goyer, Billy Ray, Justin Rhodes','2019-11-01','Fantasy/Sci-fi','2h 8m','R','Linda Hamilton, Arnold Schwarzenegger, Mackenzie Davis, Natalia Reyes, Gabriel Luna, Diego Boneta','6.3/10,70%','terminatordarkfate2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Bombshell','Jay Roach','Charles Randolph','2019-12-19','Drama','1h 49m','R','Charlize Theron, Nicole Kidman, Margot Robbie, John Lithgow, Kate McKinnon, Connie Britton, Malcolm McDowell, Allison Janney','6.8/10,70%','bombshell2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Once Upon a Time in Hollywood','Quentin Tarantino','Quentin Tarantino','2019-07-26','Drama/Comedy-drama','2h 40m','R','Leonardo DiCaprio, Brad Pitt, Margot Robbie, Emile Hirsch, Margaret Qualley, Timothy Olyphant, Austin Butler, Dakota Fanning, Bruce Dern, Al Pacino','7.7/10,85%','onceuponatimeinhollyword2019.jpg');
INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES ('Aladdin','Guy Ritchie','Guy Ritchie, John August','2019-05-24','Fantasy/Romance','2h 8m','PG','Will Smith, Mena Massoud, Naomi Scott, Marwan Kenzari, Navid Negahban, Nasim Pedrad, Billy Magnussen','7/10,57%','aladdin2019.jpg');

SELECT * FROM Customer;
SELECT * FROM Movie;
