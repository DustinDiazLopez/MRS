SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

#################################################################################### Schema MovieRentalSystem
drop SCHEMA IF EXISTS MovieRentalSystem;
create SCHEMA IF NOT EXISTS MovieRentalSystem;
USE MovieRentalSystem;

#################################################################################### Table Movies
drop table IF EXISTS Movies;
create TABLE IF NOT EXISTS Movies (
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

drop table IF EXISTS Directors;
create TABLE IF NOT EXISTS Directors (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
  );

#################################################################################### Table Cast

drop table IF EXISTS Cast;
create TABLE IF NOT EXISTS Cast (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
);

#################################################################################### Table Genres

drop table IF EXISTS Genres;
create TABLE IF NOT EXISTS Genres (
  ID INT NOT NULL AUTO_INCREMENT,
  Genre VARCHAR(70) BINARY NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Genre_UNIQUE (Genre ASC) VISIBLE
);

#################################################################################### Table MovieDirectors
drop table IF EXISTS MovieDirectors;
create TABLE IF NOT EXISTS MovieDirectors (
  MovieID INT NOT NULL,
  DirectorID INT NOT NULL,
  PRIMARY KEY (MovieID, DirectorID),
  INDEX FK_Movie_Directors_Directors_idx (DirectorID ASC) VISIBLE,
  INDEX FK_Movie_Directors_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Directors_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Movie_Directors_Directors
    FOREIGN KEY (DirectorID)
    REFERENCES Directors (ID)
    ON delete NO ACTION
    ON update NO ACTION
);

#################################################################################### Table MovieGenres
drop table IF EXISTS MovieGenres;
create TABLE IF NOT EXISTS MovieGenres (
  MovieID INT NOT NULL,
  GenreID INT NOT NULL,
  PRIMARY KEY (MovieID, GenreID),
  INDEX FK_Movie_Genres_Genres_idx (GenreID ASC) VISIBLE,
  INDEX FK_Movie_Genres_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Genres_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Movie_Genres_Genres
    FOREIGN KEY (GenreID)
    REFERENCES Genres (ID)
    ON delete NO ACTION
    ON update NO ACTION
);

#################################################################################### Table Writers
drop table IF EXISTS Writers;
create TABLE IF NOT EXISTS Writers (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(70) NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Name_UNIQUE (Name ASC) VISIBLE
);

#################################################################################### Table MovieWriters
drop table IF EXISTS MovieWriters;
create TABLE IF NOT EXISTS MovieWriters (
  MovieID INT NOT NULL,
  WriterID INT NOT NULL,
  PRIMARY KEY (MovieID, WriterID),
  INDEX FK_Movie_Writers_Writers_idx (WriterID ASC) VISIBLE,
  INDEX FK_Movie_Writers_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Writers_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Movie_Writers_Writers
    FOREIGN KEY (WriterID)
    REFERENCES Writers (ID)
    ON delete NO ACTION
    ON update NO ACTION
);

#################################################################################### Table MovieCast
drop table IF EXISTS MovieCast;
create TABLE IF NOT EXISTS MovieCast (
  MovieID INT NOT NULL,
  CastID INT NOT NULL,
  PRIMARY KEY (MovieID, CastID),
  INDEX FK_Movie_Cast_Cast_idx (CastID ASC) VISIBLE,
  INDEX FK_Movie_Cast_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Cast_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Movie_Cast_Cast
    FOREIGN KEY (CastID)
    REFERENCES Cast (ID)
    ON delete NO ACTION
    ON update NO ACTION
);

#################################################################################### Table AccountTypes
drop table IF EXISTS AccountTypes;
create TABLE IF NOT EXISTS AccountTypes (
  ID INT NOT NULL AUTO_INCREMENT,
  Type VARCHAR(70) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE INDEX Type_UNIQUE (Type ASC) VISIBLE
);

#################################################################################### Table Customers
drop table IF EXISTS Customers;
create TABLE IF NOT EXISTS Customers (
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
    ON delete NO ACTION
    ON update NO ACTION
);

#################################################################################### Table Medias
drop table IF EXISTS Medias;
create TABLE IF NOT EXISTS Medias (
  ID INT NOT NULL AUTO_INCREMENT,
  Media ENUM('DVD', 'BLU-RAY') NULL,
  PRIMARY KEY (ID)
);

#################################################################################### Table Rentals
drop table IF EXISTS Rentals;
create TABLE IF NOT EXISTS Rentals (
  ID INT NOT NULL AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  MediaID INT NOT NULL,
  RentedOn VARCHAR(70) NOT NULL,
  Returned TINYINT NOT NULL,
  Held TINYINT DEFAULT 0,
  ReturnedOn VARCHAR(70) NULL,
  TotalDays INT NULL,
  TotalCost FLOAT NULL,
  PRIMARY KEY (ID, CustomerID, MediaID),
  INDEX FK_Rental_Customer_idx (CustomerID ASC) VISIBLE,
  INDEX FK_Rental_Media_idx (MediaID ASC) VISIBLE,
  CONSTRAINT FK_Rental_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Rental_Media
    FOREIGN KEY (MediaID)
    REFERENCES Medias (ID)
    ON delete NO ACTION
    ON update NO ACTION
);

####################################################################################
drop table IF EXISTS MovieRental;
create TABLE IF NOT EXISTS MovieRental (
  MovieID INT NOT NULL,
  RentalID INT NOT NULL,
  PRIMARY KEY (MovieID, RentalID),
  INDEX FK_Movie_Rental_Rental_idx (RentalID ASC) VISIBLE,
  INDEX FK_Movie_Rental_Movie_idx (MovieID ASC) VISIBLE,
  CONSTRAINT FK_Movie_Rental_Movie
    FOREIGN KEY (MovieID)
    REFERENCES Movies (ID)
    ON delete NO ACTION
    ON update NO ACTION,
  CONSTRAINT FK_Movie_Rental_Rental
    FOREIGN KEY (RentalID)
    REFERENCES Rentals (ID)
    ON delete NO ACTION
    ON update NO ACTION
);
#################################################################################### SCHEMA END

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

#################################################################################### insert ACCOUNT TYPES
insert into AccountTypes (Type) values ('USER');
insert into AccountTypes (Type) values ('ADMIN');

select * from AccountTypes;
#################################################################################### insert CUSTOMERS
INSERT INTO Customers (Username,AccountPassword,FirstName,MiddleName,LastName,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("dustindiaz", "dustin123", "Dustin", "A.", "Díaz", "1998-02-06", "4 Calle Aleli Urb. Round Hill", "Trujillo Alto", "00976", "787-478-2095", "2");
INSERT INTO Customers (Username,AccountPassword,FirstName,MiddleName,LastName,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("root", "toor", "Root", "", "Account", "1860-02-06", "RA 0h 42m 44s | Dec +4° 6\' 9\"", "Andromeda Galaxy", "M3", "Radio Waves", "2");
INSERT INTO Customers (Username,AccountPassword,FirstName,MiddleName,LastName,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("dustin123", "asd", 'Pedro', 'D.', 'Campo', '1996-2-06', "Villas De Rio Grande", 'Río Grande', '00745', '237-067-8900', "1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Clinton","Elvis","Holloway","Jayme Mann","ante","1992-12-13","P.O. Box 138, 5925 Odio. St.","Savona","4583","596-186-9323","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Inga","Len","Barker","Ezra Mccray","volutpat","1997-07-07","744-5001 Eleifend Ave","Nogales","352006","285-770-7714","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hedley","Brett","Watkins","Forrest Mejia","sapien","1991-03-04","654-3869 Velit Street","Enines","785185","421-270-5443","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zena","Aurelia","Aguirre","Elton Kinney","vulputate","2001-11-22","P.O. Box 455, 4139 Lobortis Ave","Timkur","Z4229","792-657-3108","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lillian","Hillary","Love","Dominique Kinney","Nunc","1993-01-06","Ap #337-1384 Nullam Road","Geertruidenberg","245499","566-788-6198","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kaseem","Ivan","Chang","Phillip Moody","amet","2000-02-22","P.O. Box 316, 551 Tempus Rd.","McCallum","64439","241-235-2158","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Eric","Quyn","Hess","Ivor Dale","in,","1993-03-12","7236 Fusce Rd.","Renlies","949183","186-415-5313","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Daryl","Nita","Bates","Brady Moon","laoreet","1989-11-20","Ap #945-7550 Ut, Rd.","Kozhikode","025010","900-357-5113","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Noble","Hu","Jacobson","Sybil Albert","non","2001-07-18","3596 Dolor, St.","Châlons-en-Champagne","3849","750-929-1086","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Thaddeus","Teegan","Mcdonald","Aaron Patel","vitae,","1995-07-29","8258 Mauris. Road","Campobasso","92809","439-496-3567","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Edward","Wallace","Sweeney","Piper Klein","hendrerit","2003-11-04","Ap #347-4389 Nec St.","Rochester","820496","240-782-9105","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Courtney","Karyn","Glenn","Hilda Chang","bibendum","2001-05-10","7678 Quisque Road","Tiverton","432192","730-936-9541","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gregory","Lacota","Whitfield","Kai Crane","dolor.","2002-05-04","P.O. Box 206, 2574 Ac Avenue","Combarbalá","2710","819-598-0166","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("David","Byron","Wynn","Gillian Moon","a,","1996-08-09","Ap #379-5260 Montes, Road","Herne","57494","702-918-0146","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kylee","Lilah","Strong","Nora Dickerson","ornare.","1996-05-12","4205 Mi Road","Giurdignano","5566","431-674-2080","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lisandra","Rajah","Mckay","Sydney Dorsey","faucibus","1995-04-14","P.O. Box 518, 3155 Euismod Av.","Norderstedt","73125","511-589-3384","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Marvin","Arthur","Whitehead","Burton Maynard","Phasellus","1991-11-05","Ap #444-1229 Pharetra St.","Uijeongbu","2101","294-503-7380","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Carlos","Leo","Lindsay","Haviva Trevino","mi","2000-09-07","Ap #165-2664 Tempus St.","Boise","844173","834-971-7943","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Clementine","Ivana","Spence","Dante Coleman","felis","1999-11-15","Ap #800-9065 Tempus Avenue","Walsall","20616","902-100-1440","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Norman","Lee","Kim","Latifah Sanford","Aliquam","1999-08-12","P.O. Box 701, 8542 Egestas, St.","Penticton","79766","578-409-9957","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Emma","Halee","Kelly","Britanni Dennis","erat","2002-12-21","P.O. Box 741, 5042 Vitae, Road","Marzabotto","6008","874-811-4242","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hanae","Constance","Porter","Amir Garrison","Nunc","2004-09-30","P.O. Box 116, 9837 Aliquam St.","Thorembais-les-BŽguines","31090","518-434-5638","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lisandra","Geraldine","Prince","Quyn Stewart","enim,","1989-11-13","685-5455 Amet, St.","Körfez","Z5081","104-346-2036","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Victoria","Sydney","Charles","Germane Sanchez","Proin","2003-07-06","Ap #562-576 Lorem Av.","Anzegem","60708","644-625-9653","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Noah","Luke","Harvey","Susan Allen","nec","2002-12-26","Ap #832-1899 Non, Ave","Nadrin","395915","532-780-9113","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Montana","Duncan","Brooks","Olga Dejesus","Mauris","1989-09-06","P.O. Box 943, 8980 Malesuada Av.","Paternopoli","71258","946-494-9844","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jaime","Nicholas","Vance","Brynne Rollins","lectus,","2003-08-26","4117 Ac Avenue","Kargopol","57623","439-767-6348","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zahir","Ori","Farmer","Hasad Carroll","Morbi","1991-02-04","P.O. Box 103, 4948 Donec Ave","San Isidro de El General","1577","895-690-8814","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jared","Peter","Burris","Rinah Osborn","mattis","1989-09-12","219 Tellus St.","Patos","Y3P 1V4","501-267-7506","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Richard","Sybill","Robertson","Channing Soto","non","1990-10-08","P.O. Box 414, 411 Bibendum Rd.","Saravena","30059","522-750-0987","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jerry","Lareina","Madden","Macon Huff","ipsum.","2000-03-22","Ap #941-7482 Non Street","Gore","20406","250-464-6316","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Montana","Craig","Shields","Dana Morrison","dolor","1990-10-18","161-9840 Dui Av.","Montoggio","45264-73645","522-233-9008","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Emerald","Nehru","Wagner","Flavia Franklin","Donec","1994-12-29","Ap #405-607 Iaculis Ave","Koningshooikt","3713","608-461-5209","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ruth","Hedley","Ortega","Alana Chapman","eget","1999-05-16","952 Enim. Rd.","Ponti","66784","402-142-9977","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Madaline","Madeson","Pace","Valentine Lewis","ante.","1992-12-23","Ap #156-7892 Nulla St.","Turbo","98-286","521-727-1864","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("MacKensie","Kirby","Miranda","Nicholas Washington","ipsum.","1991-09-02","Ap #898-1132 Faucibus Rd.","Tarzo","3606","402-252-7783","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kennan","Louis","Brooks","Lareina Reyes","Integer","1994-03-20","Ap #452-6650 A Street","Saint-Malo","56447","377-496-0718","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rylee","Jack","Marshall","Petra Gibbs","Quisque","1990-10-11","Ap #908-1802 Vitae, Rd.","Palmira","H5G 3GV","587-672-2591","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alana","Richard","Dominguez","Oleg Hughes","lorem","1995-04-24","9813 Curabitur Rd.","Bacabal","1260","802-604-1317","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yuli","Juliet","Stokes","Nichole Figueroa","Integer","1989-11-22","Ap #262-7655 Elit, Road","Rhayader","1972","478-930-0669","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Adria","Leo","Mcguire","Ashely Merritt","a","1999-08-10","526 Ipsum. St.","Ripalta Guerina","60700","316-899-7997","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Candace","Gareth","Hardin","Shoshana Golden","cursus","2004-08-20","Ap #793-9374 Eu Road","Amelia","8903","875-377-9445","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sacha","Dahlia","Dodson","Diana Love","euismod","1990-07-09","8039 Quis Avenue","Torino","37728","196-405-9215","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Edward","Chaim","Kramer","Sean Mccullough","arcu","1998-11-08","5814 Imperdiet, St.","Gießen","5850","895-508-4156","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Beau","Chandler","Dorsey","Malik Williams","tempus","1998-07-30","648-9709 Vivamus Av.","Tramatza","66730","419-970-3187","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Guinevere","Fay","Harmon","Dylan Fulton","Proin","2003-12-24","3581 Donec Av.","Gondiya","3244","233-648-4550","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Leandra","Eaton","Gonzalez","Ivan Rich","erat","2002-08-08","Ap #372-4398 Tincidunt, Road","Branchon","993654","682-167-3254","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Faith","Alden","Hester","Ryan Galloway","Donec","1999-02-23","851-7639 In Rd.","Porirua","47936","577-932-1832","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rooney","Victoria","Melendez","Nehru Lowe","consectetuer","2002-06-19","606-3472 Urna Ave","Picinisco","Z8703","171-952-7432","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Darius","Blossom","Silva","Tamara Emerson","cursus","2000-03-02","P.O. Box 613, 9215 Arcu. St.","Sylvan Lake","44-635","447-273-9222","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tarik","Keegan","Porter","Bruce Mendoza","placerat","2002-10-19","Ap #904-9551 Aliquam St.","Dundee","70215","837-522-7700","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lynn","James","Chase","Joan Mcgee","vel","2004-11-12","131-8662 Class Road","Bowden","DC06 8XZ","313-209-4347","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Joy","Fitzgerald","Holmes","Nero Hartman","lorem,","1994-03-22","Ap #120-9925 Eu Rd.","New Sarepta","44784-181","965-100-2986","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hamish","Reece","Maddox","Todd Rojas","condimentum","2002-07-15","Ap #625-3573 Egestas St.","Tando Muhammad Khan","97270","285-796-7883","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Denise","Colin","Nichols","Carter Branch","tincidunt","1989-09-23","P.O. Box 486, 9981 Aenean Street","Pergola","5837","407-934-4397","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rhiannon","Christen","Roth","Violet Gregory","et","2003-08-04","P.O. Box 431, 8119 Sem Av.","South Dum Dum","16839","701-970-4761","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Bianca","Isabelle","Hodges","Isabella Rose","consectetuer","1994-12-02","P.O. Box 980, 7265 Lacus St.","Guelph","825129","657-206-8602","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hillary","Nigel","Avery","Kaitlin Tillman","pede,","1998-05-06","2575 Magna. St.","Papudo","11947","772-568-2845","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Basil","Cedric","Black","Abbot Bean","dapibus","1998-03-26","5323 Quis Av.","Curridabat","39252","131-275-2026","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Brynne","Pearl","Holloway","Jane Koch","nec,","1989-12-24","P.O. Box 213, 1484 Massa Avenue","Burnaby","07976","670-454-0247","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Stone","Ivory","Rivers","Colt Morris","eu","2001-10-02","591-6691 Mollis Rd.","Sitapur","44803","264-247-1110","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ronan","Xena","Clark","Larissa Christian","consectetuer","1995-02-23","Ap #916-4685 Interdum. Av.","Saint John","50415","625-825-0923","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kristen","Elvis","Travis","Xyla Le","mauris","1993-05-22","838-7386 Justo Avenue","Waardamme","9245","453-358-7468","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ahmed","Cyrus","Alford","Odysseus Vincent","odio,","2005-01-24","904-4865 Purus. Avenue","Geelong","83791","881-132-5898","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Duncan","Petra","Madden","Rowan Lyons","convallis,","1996-04-09","9513 Sociis Avenue","Saint Louis","15692","453-363-1163","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lavinia","Amir","Yates","Allegra Newton","non,","1991-02-07","473-2349 Luctus St.","Garzón","44756","416-289-1179","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Catherine","Teegan","Cervantes","Troy Levy","mi","2002-09-04","7939 Nec Rd.","Portsmouth","62624","627-159-7887","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ebony","Wing","Petty","Blair Horton","Aliquam","1996-07-27","P.O. Box 686, 199 Aliquam Rd.","Omaha","948867","666-106-4177","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Xenos","Destiny","Perry","Ori Charles","Nullam","2002-07-05","383-9344 Donec St.","Ramenskoye","586212","672-978-1514","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yoshio","Cruz","Roberson","Mikayla Morrison","pharetra,","2000-02-20","Ap #582-8582 Magna. St.","Grimsby","711125","495-150-4306","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tarik","Trevor","Sparks","Quintessa Johnston","Nam","1999-02-03","P.O. Box 843, 2387 Arcu. Rd.","Blackwood","SR6 1BF","844-200-5594","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Indigo","Sybill","Olsen","Quon Hansen","elementum,","1993-10-01","9118 Dapibus St.","C�te-Saint-Luc","067340","504-363-5329","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yoshi","Maile","Lee","Sydney Woodard","mauris","1998-06-16","993-1079 Id, Ave","Rekem","731711","533-727-8623","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Delilah","Samantha","Burke","Ivor Daniels","ut,","1998-12-24","Ap #984-8209 Suspendisse Rd.","Martelange","04976","549-984-4029","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Shad","Ainsley","Velez","Armando Mcdaniel","id,","2001-12-22","386-7883 Maecenas Avenue","Tollembeek","39205","265-699-6406","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gay","Travis","Greene","Bell Day","tincidunt","2003-10-16","Ap #605-7498 Donec St.","Haddington","B3 1PF","535-216-6880","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Vernon","Nathan","Mercer","Jaden Roth","fermentum","1996-07-12","P.O. Box 696, 9190 Malesuada. Ave","Duluth","87930","619-623-7307","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Oliver","Blythe","Tyler","Finn Bartlett","ac","1999-12-02","5810 Aliquam Avenue","Mirpur","532210","168-739-9430","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Anne","August","Bartlett","Eve Beck","lorem","2002-11-11","113-6447 Turpis Road","Fontecchio","1147 WH","477-852-9012","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sandra","William","Woodard","Astra Knowles","malesuada","1993-08-26","Ap #830-7279 Placerat, Rd.","Peine","941269","399-923-5873","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Brett","Perry","Vasquez","Octavia Monroe","odio.","1995-05-02","830-4369 Ante Rd.","Vastogirardi","479217","381-200-7667","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Armando","Odette","Mcfarland","Plato Ellison","in,","1997-04-03","538-8075 Cursus Rd.","Charny","459667","713-310-7991","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Beau","Carlos","Carr","Harper Camacho","blandit","2000-07-02","P.O. Box 187, 9655 Eu Rd.","Chantemelle","35958-54368","895-837-9945","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Briar","Arden","Cortez","Montana Beck","ante","1996-01-18","P.O. Box 878, 8711 Vitae St.","Villanovafranca","87675-631","180-122-2244","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Owen","Genevieve","Lambert","Mercedes Daugherty","mollis","2000-04-27","Ap #906-6169 Vel Av.","Poviglio","30505","665-140-6526","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tamekah","Tiger","Glass","Hakeem Lamb","nec,","1994-03-31","Ap #276-6711 Tellus Road","Cambridge","88919-97300","662-738-1034","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Cheryl","Hamilton","Woodard","Matthew Case","ut","1997-10-18","Ap #913-310 Gravida Rd.","Astrakhan","654122","342-911-1279","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jeanette","Heather","Hawkins","Scarlett Logan","adipiscing.","1994-12-23","6316 Proin Ave","Stratford","576183","393-420-2977","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jillian","Octavius","Golden","Lee Hart","eget","1998-08-02","8873 Fermentum Road","Glovertown","41658-11894","223-814-9570","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Cecilia","Colleen","Benson","Hayley May","Maecenas","1994-02-05","Ap #331-7959 Est Avenue","Allentown","1846 FH","983-334-4552","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Pandora","Victor","Cooke","Caesar Clemons","lobortis","1998-10-21","Ap #303-3787 Vitae St.","LouveignŽ","37890","527-790-5595","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Pamela","Edward","Arnold","Winifred Richardson","parturient","1993-05-15","6588 Mollis Av.","Tampa","19808","193-903-0796","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kasimir","Lillith","Bradford","Unity Walsh","consequat","1994-09-07","822-8749 Ultrices Ave","Wolfville","74702","925-652-7816","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jonas","Merrill","Le","Kenyon Jacobson","felis,","1990-01-01","773 Eros Street","Kakinada","194465","667-704-9701","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Baker","Sarah","Kramer","Kato Wiggins","Morbi","2002-01-23","9672 Nisi Ave","Caruaru","78266","946-357-1405","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Travis","Skyler","Swanson","Beatrice Kelly","rhoncus.","2001-05-13","P.O. Box 293, 1635 Nulla. Rd.","San Damiano al Colle","60001","674-160-7297","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ryder","Rinah","Tate","Jerry Sharp","eget,","1998-03-10","3533 Curae; St.","Saint-GŽry","90651","390-219-4674","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Nigel","Catherine","Osborne","Allistair Albert","Pellentesque","2003-09-13","560-2972 Libero. Rd.","Rothesay","45506","495-207-7089","1");


SELECT * FROM Customers;

#################################################################################### INSERT Movies

INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Aliens','1986-08-29','2h 17m','15','8.3/10','524650ab-d460-4aab-aa26-8dbad70fbf99.jpg'); #1
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('One Flew Over the Cuckoo\'s Nest','1976-02-26','2h 13m','X','8.7/10','2d7e201b-e4d8-41ef-8605-45e7a0f4096f.jpg'); #2
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Kid','null','1h 8m','U','8.3/10','bafb7b28-203d-48fb-b7cd-781227eba566.jpg'); #3
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Life Is Beautiful','1999-02-12','1h 56m','PG','8.6/10','41a652d1-da42-4c5b-9ebd-827116cd962a.jpg'); #4
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Princess Mononoke','2001-10-19','2h 14m','PG','8.4/10','ed1d29f2-b218-4449-b89b-8b671d6a44cd.jpg'); #5
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Witness for the Prosecution','1958-02-06','1h 56m','U','8.4/10','be1ff571-619e-4317-9ccd-0666a8f6b2b7.jpg'); #6
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Usual Suspects','1995-08-25','1h 46m','18','8.5/10','0de6cf4d-907f-43bc-bee3-1ed03b522411.jpg'); #7
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Pianist','2003-01-24','2h 30m','15','8.5/10','1745f694-8b2e-4450-8333-c1102e4dc0ed.jpg'); #8
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Avengers: Infinity War','2018-04-26','2h 29m','12A','8.5/10','85b8387f-ff87-4863-bc1c-15a923d9c165.jpg'); #9
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Lord of the Rings: The Return of the King','2003-12-17','3h 21m','12A','8.9/10','33faa3af-fd4f-4d55-9b4b-085911d0871d.jpg'); #10
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Amélie','2001-10-05','2h 2m','15','8.3/10','b9de665a-c88d-4b7e-93bf-5f279549bab0.jpg'); #11
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Matrix','1999-06-11','2h 16m','15','8.7/10','ff9db5fb-faa6-4fe6-8e16-94516fdce052.jpg'); #12
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('2001: A Space Odyssey','1968-05-12','2h 29m','U','8.3/10','70336f12-8c83-4792-b962-52568dedd1bb.jpg'); #13
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Lord of the Rings: The Two Towers','2002-12-18','2h 59m','12A','8.7/10','b5b3df95-5ec5-4f91-bbfc-22c4738a5a3b.jpg'); #14
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Star Wars: Episode V - The Empire Strikes Back','1980-05-21','2h 4m','U','8.7/10','1ade8e67-4091-4b29-88e0-380ba650f470.jpg'); #15
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Apocalypse Now','1979-12-19','2h 27m','X','8.4/10','a663f66f-5515-4ee1-9e76-a87362e872e6.jpg'); #16
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('North by Northwest','1959-11-20','2h 16m','A','8.3/10','47facc3b-7e8d-4822-afd6-a8e43f95b349.jpg'); #17
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Shining','1980-10-05','2h 26m','15','8.4/10','c5fcfdba-8b8c-43ee-aaa3-d7564d744c02.jpg'); #18
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('3 Idiots','2009-12-24','2h 50m','12A','8.4/10','6a2f58fb-3f63-44e8-956b-e77ed6015db0.jpg'); #19
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Avengers: Endgame','2019-04-25','3h 1m','12A','8.4/10','0943d9ca-b39d-43b4-96cb-0e77ade3a2db.jpg'); #20
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Once Upon a Time in America','1984-10-05','3h 49m','R','8.4/10','8b38a0b5-922f-47b4-b404-b3fdd678a168.jpg'); #21
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Dark Knight','2008-07-24','2h 32m','12A','9/10','540eb947-ec80-4619-871a-2fa05d06d011.jpg'); #22
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Untouchable','2012-09-21','1h 52m','15','8.5/10','13d5ae24-9d08-4f23-9416-aaf013b884ae.jpg'); #23
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Casablanca','1943-01-23','1h 42m','U','8.5/10','5b543f92-3041-437c-b359-df2f35940de6.jpg'); #24
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Vertigo','1958-05-22','2h 8m','A','8.3/10','b8a5d759-67af-4b72-af8d-4a05566ecc82.jpg'); #25
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Interstellar','2014-11-07','2h 49m','12A','8.6/10','d1266c0e-756f-4f8c-85f5-e59d9f199e4c.jpg'); #26
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Harakiri','1964-08-04','2h 13m','X','8.7/10','2430cb2e-ecac-49c5-bd01-7c9722332f2f.jpg'); #27
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Star Wars: Episode IV - A New Hope','1978-01-29','2h 1m','U','8.6/10','d33cad96-355b-4ff0-85be-cd53f339cbf8.jpg'); #28
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Good Will Hunting','1998-03-06','2h 6m','15','8.3/10','be856e2d-acb3-4603-b754-c7e14b8d0630.jpg'); #29
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Dangal','2016-12-22','2h 41m','PG','8.4/10','07ac66d8-b173-4999-8570-b496d894eb01.jpg'); #30
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('A Clockwork Orange','1972-01-13','2h 16m','X','8.3/10','943ff360-b13e-4853-9134-fe92787392cc.jpg'); #31
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Eternal Sunshine of the Spotless Mind','2004-04-30','1h 48m','15','8.3/10','734597ed-7956-492e-80fe-ec273c5dd691.jpg'); #32
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Coco','2018-01-19','1h 45m','PG','8.4/10','0b5161bc-378e-4f02-a5f9-ce95fc2c0714.jpg'); #33
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Like Stars on Earth','2007-12-21','2h 45m','PG','8.4/10','c1fbc338-e4fa-4374-a3d5-f063c62ba42d.jpg'); #34
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('12 Angry Men','1957-04-10','1h 36m','U','8.9/10','9d9bd45b-2bbb-475b-9f96-bb02e3dd8024.jpg'); #35
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Departed','2006-10-06','2h 31m','18','8.5/10','02a06250-c5be-40bf-baf5-07ebb12883ef.jpg'); #36
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Inception','2010-07-16','2h 28m','12A','8.8/10','b3567e47-d596-4694-aa5a-8737f6a1dcd1.jpg'); #37
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Hunt','2013-01-10','1h 55m','15','8.3/10','dcf41b10-c8bc-4614-bfc4-5c30816ca7b7.jpg'); #38
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Requiem for a Dream','2001-01-19','1h 42m','18','8.3/10','bb58c5fe-d5f4-4a94-b77c-5fec219902ee.jpg'); #39
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('WALL·E','2008-07-18','1h 38m','U','8.4/10','e00a101d-4f02-4416-a14b-1b6c3e7e9d20.jpg'); #40
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('It\'s a Wonderful Life','1947-01-07','2h 10m','U','8.6/10','275723de-d59d-4992-a25d-14d12c40dbe9.jpg'); #41
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Alien','1979-09-06','1h 57m','X','8.4/10','07012bc6-8a0e-4ccb-b568-1a92bf675a3c.jpg'); #42
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('American History X','1999-03-26','1h 59m','18','8.5/10','2068fdc9-a33e-4db3-9943-2c24f3e1448c.jpg'); #43
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Toy Story','1996-03-22','1h 21m','PG','8.3/10','785fb93f-8149-4483-90c7-765ee031e5b2.jpg'); #44
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Seven Samurai','1956-11-19','3h 27m','A','8.6/10','fbb34e62-7ea5-47cd-ae6b-b89883dab0da.jpg'); #45
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Modern Times','1936-02-11','1h 27m','U','8.5/10','448bcddc-6fa6-4dc5-b3b2-1a78d1258871.jpg'); #46
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Green Mile','2000-03-03','3h 9m','18','8.6/10','a20e9d45-b698-463f-9950-5c627ff4d649.jpg'); #47
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Schindler\'s List','1994-02-18','3h 15m','15','8.9/10','d7d0b229-d83e-45d8-a392-998acc36d2e4.jpg'); #48
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Rear Window','1954-11-15','1h 52m','A','8.4/10','2e8fd3e6-b268-453a-804e-fb31fbd602f2.jpg'); #49
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Full Metal Jacket','1987-09-11','1h 56m','15','8.3/10','fe35e5b9-dba7-4c18-8dc5-46ccebf5cb6c.jpg'); #50
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('City Lights','1931-03-07','1h 27m','U','8.5/10','eadeb9d4-47cf-4e2e-a630-6f1edc471a55.jpg'); #51
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Great Dictator','1941-03-07','2h 5m','U','8.4/10','08da4760-c681-43c4-9d24-645063d30d18.jpg'); #52
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('M','1931-08-31','1h 39m','A','8.3/10','b948987e-a2be-40c7-953f-19d3099b12d9.jpg'); #53
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Grave of the Fireflies','1989-04-07','1h 29m','12A','8.5/10','40943a9f-8368-400d-a37e-b57212faaa81.jpg'); #54
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Silence of the Lambs','1991-05-31','1h 58m','18','8.6/10','3b7c0814-b084-4b44-a091-131842d926fb.jpg'); #55
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Gladiator','2000-05-12','2h 35m','15','8.5/10','f6fc68dc-40e5-4ee7-be73-b6bb9deb6c07.jpg'); #56
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Back to the Future','1985-12-04','1h 56m','PG','8.5/10','2340d6dd-9d37-46a5-a36d-efb729a34293.jpg'); #57
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Braveheart','1995-09-08','2h 58m','15','8.3/10','7a2724c7-1441-4ae9-a244-dad483a65919.jpg'); #58
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Leon','1995-02-03','1h 50m','18','8.5/10','61c8edaf-928f-41f1-ae10-7ef0460c2a97.jpg'); #59
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Inglourious Basterds','2009-08-19','2h 33m','18','8.3/10','402caf09-b956-433f-84d4-fa1270bdc352.jpg'); #60
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Shawshank Redemption','1995-02-17','2h 22m','15','9.3/10','8c092028-6cd4-4ce5-a3e1-da67c9358493.jpg'); #61
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Oldboy','2004-10-15','2h','18','8.4/10','4c67d2df-f2fc-4a62-baed-ba6c7d651b2a.jpg'); #62
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('City of God','2003-01-03','2h 10m','18','8.6/10','889b2f93-7d0f-447e-88b6-1c0124fc05c0.jpg'); #63
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Forrest Gump','1994-10-07','2h 22m','12','8.8/10','10024a21-4748-4b90-8c48-da25e5131bf1.jpg'); #64
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Reservoir Dogs','1993-01-15','1h 39m','18','8.3/10','a863903e-5f54-4f1a-aaa7-5acaeeb97193.jpg'); #65
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Lord of the Rings: The Fellowship of the Ring','2001-12-19','2h 58m','PG','8.8/10','8e27f219-759a-401b-ad14-698c21d68398.jpg'); #66
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Joker','2019-10-04','2h 2m','15','8.5/10','fbf98850-c11c-4b18-b4d0-0227621d6368.jpg'); #67
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Memento','2000-10-20','1h 53m','15','8.4/10','88e5c7ce-29cb-49af-b2e7-3722822772e2.jpg'); #68
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Prestige','2006-11-10','2h 10m','12A','8.5/10','7c05b6fb-097a-48ea-a574-b94b628463b3.jpg'); #69
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Your Name.','2016-11-18','1h 46m','12A','8.4/10','1b1f9a1e-67b9-4c28-91aa-82c6aaea1366.jpg'); #70
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('American Beauty','2000-02-04','2h 2m','18','8.3/10','7e74f813-e5d9-4371-8d65-860f0637d692.jpg'); #71
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Lives of Others','2007-04-13','2h 17m','15','8.4/10','0ec3509d-7e33-4a63-9c3f-86cb8b6817aa.jpg'); #72
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Saving Private Ryan','1998-09-11','2h 49m','15','8.6/10','27425015-1ec3-40c1-bb27-b33b62faa59b.jpg'); #73
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Raiders of the Lost Ark','1981-07-30','1h 55m','A','8.4/10','5b02cfdc-00c2-4a2a-98a7-cef0beafcb41.jpg'); #74
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Once Upon a Time in the West','1969-08-31','2h 45m','AA','8.5/10','99f82a2a-3ef1-46e9-913d-856de7e6c0ae.jpg'); #75
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Godfather','1972-08-24','2h 55m','X','9.2/10','dd655f46-0f52-4293-91f5-f2924684601f.jpg'); #76
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Terminator 2: Judgment Day','1991-08-16','2h 17m','R','8.5/10','57dc000a-d7ce-4f2d-9d7b-93bab75bef65.jpg'); #77
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Lion King','1994-10-07','1h 28m','U','8.5/10','4db6809f-f697-4822-aedb-8ccec95d61fd.jpg'); #78
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Star Wars: Episode VI - Return of the Jedi','1983-06-02','2h 11m','U','8.3/10','b61bc901-d119-4f04-8baa-ab9dab69b3b3.jpg'); #79
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Seven','1996-01-05','2h 7m','18','8.6/10','73fe9d63-ca9c-46d1-94e6-08f825f4fac2.jpg'); #80
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Sunset Blvd.','1950-09-29','1h 50m','PG','8.4/10','59d839c0-3f25-4ee5-ab2b-6d65fd728886.jpg'); #81
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Spirited Away','2003-09-12','2h 5m','PG','8.6/10','f7effd23-7afe-4df4-8803-63f6eedc9608.jpg'); #82
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Pulp Fiction','1994-10-21','2h 34m','18','8.9/10','78a3a07a-fe5d-48d6-a33c-6dbc9029f235.jpg'); #83
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Snatch','2000-09-01','1h 42m','18','8.3/10','d1790c09-dd35-4367-bd8e-d3ce1cd906b7.jpg'); #84
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Fight Club','1999-11-12','2h 19m','18','8.8/10','d4ed9d56-4c44-4e06-929e-ca603b55115d.jpg'); #85
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Psycho','1960-09-15','1h 49m','X','8.5/10','0c91a115-00fd-4ecb-bc68-017c47d8cca6.jpg'); #86
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Citizen Kane','1942-01-24','1h 59m','A','8.3/10','5a1b704a-0bea-4d3b-929a-76f5b372227c.jpg'); #87
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Das Boot','1982-02-10','2h 29m','AA','8.3/10','d188a74e-e1c4-4321-a6a4-ba700deec845.jpg'); #88
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Paths of Glory','1957-12-20','1h 28m','PG','8.4/10','35af5639-b311-40e8-aefa-38b11e41481f.jpg'); #89
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Spider-Man: Into the Spider-Verse','2018-12-12','1h 57m','PG','8.4/10','abe74a16-85d2-4120-9579-2280c5e3ce27.jpg'); #90
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Amadeus','1985-01-17','2h 40m','R','8.3/10','26e02539-c29b-41d1-9e0d-5d6bb2aa0871.jpg'); #91
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Django Unchained','2013-01-18','2h 45m','18','8.4/10','162de5a1-08e2-4a5b-b864-f1c175193f04.jpg'); #92
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Good, the Bad and the Ugly','1967-12-29','2h 28m','X','8.8/10','f29ef06e-5c5e-4453-afee-93452d721664.jpg'); #93
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Goodfellas','1990-10-26','2h 26m','18','8.7/10','775d2bcb-1438-4846-ab7b-12b444529b02.jpg'); #94
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Whiplash','2015-01-16','1h 46m','15','8.5/10','d262e2ab-8a2a-4879-94e4-58217369cd4c.jpg'); #95
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Godfather: Part II','1975-05-15','3h 22m','X','9/10','a55ceea0-feb8-4dc4-9696-da5409954d85.jpg'); #96
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Parasite','2020-02-07','2h 12m','15','8.6/10','f8efd07e-b712-48fe-9ef8-1e2af9acf211.jpg'); #97
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb','1964-01-29','1h 35m','A','8.4/10','8c79aad0-c6c4-467c-b2d9-b2702df9a62a.jpg'); #98
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('Cinema Paradiso','1990-02-23','2h 35m','PG','8.5/10','bf573bf3-9a0b-4f04-9421-8b2869ff146c.jpg'); #99
INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES ('The Dark Knight Rises','2012-07-20','2h 44m','12A','8.4/10','dcc63c2b-c3d6-4bde-9897-6428be67a28b.jpg'); #100

UPDATE Movies SET ReleaseDate = '2019-05-16' WHERE ID = 3;

select * from Movies;

#################################################################################### insert Directors

INSERT INTO Directors (Name) VALUES ('Aamir Khan'); #1
INSERT INTO Directors (Name) VALUES ('Adrian Molina (co-director)'); #2
INSERT INTO Directors (Name) VALUES ('Alfred Hitchcock'); #3
INSERT INTO Directors (Name) VALUES ('Amole Gupte'); #4
INSERT INTO Directors (Name) VALUES ('Andrew Stanton'); #5
INSERT INTO Directors (Name) VALUES ('Anthony Russo'); #6
INSERT INTO Directors (Name) VALUES ('Billy Wilder'); #7
INSERT INTO Directors (Name) VALUES ('Bob Persichetti'); #8
INSERT INTO Directors (Name) VALUES ('Bong Joon Ho'); #9
INSERT INTO Directors (Name) VALUES ('Bryan Singer'); #10
INSERT INTO Directors (Name) VALUES ('Chan-wook Park'); #11
INSERT INTO Directors (Name) VALUES ('Charles Chaplin'); #12
INSERT INTO Directors (Name) VALUES ('Christopher Nolan'); #13
INSERT INTO Directors (Name) VALUES ('Damien Chazelle'); #14
INSERT INTO Directors (Name) VALUES ('Darren Aronofsky'); #15
INSERT INTO Directors (Name) VALUES ('David Fincher'); #16
INSERT INTO Directors (Name) VALUES ('Fernando Meirelles'); #17
INSERT INTO Directors (Name) VALUES ('Florian Henckel von Donnersmarck'); #18
INSERT INTO Directors (Name) VALUES ('Francis Ford Coppola'); #19
INSERT INTO Directors (Name) VALUES ('Frank Capra'); #20
INSERT INTO Directors (Name) VALUES ('Frank Darabont'); #21
INSERT INTO Directors (Name) VALUES ('Fritz Lang'); #22
INSERT INTO Directors (Name) VALUES ('George Lucas'); #23
INSERT INTO Directors (Name) VALUES ('Giuseppe Tornatore'); #24
INSERT INTO Directors (Name) VALUES ('Gus Van Sant'); #25
INSERT INTO Directors (Name) VALUES ('Guy Ritchie'); #26
INSERT INTO Directors (Name) VALUES ('Hayao Miyazaki'); #27
INSERT INTO Directors (Name) VALUES ('Irvin Kershner'); #28
INSERT INTO Directors (Name) VALUES ('Isao Takahata'); #29
INSERT INTO Directors (Name) VALUES ('James Cameron'); #30
INSERT INTO Directors (Name) VALUES ('Jean-Pierre Jeunet'); #31
INSERT INTO Directors (Name) VALUES ('Joe Russo'); #32
INSERT INTO Directors (Name) VALUES ('John Lasseter'); #33
INSERT INTO Directors (Name) VALUES ('Jonathan Demme'); #34
INSERT INTO Directors (Name) VALUES ('Kátia Lund'); #35
INSERT INTO Directors (Name) VALUES ('Lana Wachowski'); #36
INSERT INTO Directors (Name) VALUES ('Lee Unkrich'); #37
INSERT INTO Directors (Name) VALUES ('Lilly Wachowski'); #38
INSERT INTO Directors (Name) VALUES ('Luc Besson'); #39
INSERT INTO Directors (Name) VALUES ('Makoto Shinkai'); #40
INSERT INTO Directors (Name) VALUES ('Martin Scorsese'); #41
INSERT INTO Directors (Name) VALUES ('Masaki Kobayashi'); #42
INSERT INTO Directors (Name) VALUES ('Mel Gibson'); #43
INSERT INTO Directors (Name) VALUES ('Michael Curtiz'); #44
INSERT INTO Directors (Name) VALUES ('Michel Gondry'); #45
INSERT INTO Directors (Name) VALUES ('Milos Forman'); #46
INSERT INTO Directors (Name) VALUES ('Nitesh Tiwari'); #47
INSERT INTO Directors (Name) VALUES ('Olivier Nakache'); #48
INSERT INTO Directors (Name) VALUES ('Orson Welles'); #49
INSERT INTO Directors (Name) VALUES ('Peter Jackson'); #50
INSERT INTO Directors (Name) VALUES ('Peter Ramsey'); #51
INSERT INTO Directors (Name) VALUES ('Quentin Tarantino'); #52
INSERT INTO Directors (Name) VALUES ('Rajkumar Hirani'); #53
INSERT INTO Directors (Name) VALUES ('Richard Marquand'); #54
INSERT INTO Directors (Name) VALUES ('Ridley Scott'); #55
INSERT INTO Directors (Name) VALUES ('Rob Minkoff'); #56
INSERT INTO Directors (Name) VALUES ('Robert Zemeckis'); #57
INSERT INTO Directors (Name) VALUES ('Roberto Benigni'); #58
INSERT INTO Directors (Name) VALUES ('Roger Allers'); #59
INSERT INTO Directors (Name) VALUES ('Roman Polanski'); #60
INSERT INTO Directors (Name) VALUES ('Sam Mendes'); #61
INSERT INTO Directors (Name) VALUES ('Sergio Leone'); #62
INSERT INTO Directors (Name) VALUES ('Sidney Lumet'); #63
INSERT INTO Directors (Name) VALUES ('Stanley Kubrick'); #64
INSERT INTO Directors (Name) VALUES ('Steven Spielberg'); #65
INSERT INTO Directors (Name) VALUES ('Thomas Vinterberg'); #66
INSERT INTO Directors (Name) VALUES ('Todd Phillips'); #67
INSERT INTO Directors (Name) VALUES ('Tony Kaye'); #68
INSERT INTO Directors (Name) VALUES ('Wolfgang Petersen'); #69
INSERT INTO Directors (Name) VALUES ('Éric Toledano'); #70

select * from Directors order by ID asc;

#################################################################################### insert Cast

INSERT INTO Cast (Name) VALUES ('Aamir Khan'); #1
INSERT INTO Cast (Name) VALUES ('Aaron Eckhart'); #2
INSERT INTO Cast (Name) VALUES ('Adolphe Menjou'); #3
INSERT INTO Cast (Name) VALUES ('Adrien Brody'); #4
INSERT INTO Cast (Name) VALUES ('Akemi Yamaguchi'); #5
INSERT INTO Cast (Name) VALUES ('Akira Ishihama'); #6
INSERT INTO Cast (Name) VALUES ('Al Pacino'); #7
INSERT INTO Cast (Name) VALUES ('Alexandre Rodrigues'); #8
INSERT INTO Cast (Name) VALUES ('Anne Hathaway'); #9
INSERT INTO Cast (Name) VALUES ('Anne Le Ny'); #10
INSERT INTO Cast (Name) VALUES ('Annette Bening'); #11
INSERT INTO Cast (Name) VALUES ('Annika Wedderkopp'); #12
INSERT INTO Cast (Name) VALUES ('Anthony Gonzalez'); #13
INSERT INTO Cast (Name) VALUES ('Anthony Hopkins'); #14
INSERT INTO Cast (Name) VALUES ('Anthony Perkins'); #15
INSERT INTO Cast (Name) VALUES ('Antonella Attili'); #16
INSERT INTO Cast (Name) VALUES ('Arnold Schwarzenegger'); #17
INSERT INTO Cast (Name) VALUES ('Audrey Tautou'); #18
INSERT INTO Cast (Name) VALUES ('Ayano Shiraishi'); #19
INSERT INTO Cast (Name) VALUES ('Barbara Bel Geddes'); #20
INSERT INTO Cast (Name) VALUES ('Ben Affleck'); #21
INSERT INTO Cast (Name) VALUES ('Ben Burtt'); #22
INSERT INTO Cast (Name) VALUES ('Ben Kingsley'); #23
INSERT INTO Cast (Name) VALUES ('Benicio Del Toro'); #24
INSERT INTO Cast (Name) VALUES ('Benjamin Bratt'); #25
INSERT INTO Cast (Name) VALUES ('Beverly D\'Angelo'); #26
INSERT INTO Cast (Name) VALUES ('Bob Gunton'); #27
INSERT INTO Cast (Name) VALUES ('Brad Pitt'); #28
INSERT INTO Cast (Name) VALUES ('Carrie Fisher'); #29
INSERT INTO Cast (Name) VALUES ('Carrie Henn'); #30
INSERT INTO Cast (Name) VALUES ('Carrie-Anne Moss'); #31
INSERT INTO Cast (Name) VALUES ('Cary Grant'); #32
INSERT INTO Cast (Name) VALUES ('Charles Bronson'); #33
INSERT INTO Cast (Name) VALUES ('Charles Chaplin'); #34
INSERT INTO Cast (Name) VALUES ('Charles Laughton'); #35
INSERT INTO Cast (Name) VALUES ('Chazz Palminteri'); #36
INSERT INTO Cast (Name) VALUES ('Chris Evans'); #37
INSERT INTO Cast (Name) VALUES ('Chris Hemsworth'); #38
INSERT INTO Cast (Name) VALUES ('Christian Bale'); #39
INSERT INTO Cast (Name) VALUES ('Christoph Waltz'); #40
INSERT INTO Cast (Name) VALUES ('Christopher Lloyd'); #41
INSERT INTO Cast (Name) VALUES ('Claudia Cardinale'); #42
INSERT INTO Cast (Name) VALUES ('Clint Eastwood'); #43
INSERT INTO Cast (Name) VALUES ('Connie Nielsen'); #44
INSERT INTO Cast (Name) VALUES ('Danny Lloyd'); #45
INSERT INTO Cast (Name) VALUES ('Darsheel Safary'); #46
INSERT INTO Cast (Name) VALUES ('Daveigh Chase'); #47
INSERT INTO Cast (Name) VALUES ('David Morse'); #48
INSERT INTO Cast (Name) VALUES ('Diane Kruger'); #49
INSERT INTO Cast (Name) VALUES ('Don Rickles'); #50
INSERT INTO Cast (Name) VALUES ('Donna Reed'); #51
INSERT INTO Cast (Name) VALUES ('Dorothy Comingore'); #52
INSERT INTO Cast (Name) VALUES ('Edna Purviance'); #53
INSERT INTO Cast (Name) VALUES ('Edward Furlong'); #54
INSERT INTO Cast (Name) VALUES ('Edward Norton'); #55
INSERT INTO Cast (Name) VALUES ('Eli Roth'); #56
INSERT INTO Cast (Name) VALUES ('Eli Wallach'); #57
INSERT INTO Cast (Name) VALUES ('Elijah Wood'); #58
INSERT INTO Cast (Name) VALUES ('Elissa Knight'); #59
INSERT INTO Cast (Name) VALUES ('Elizabeth Berridge'); #60
INSERT INTO Cast (Name) VALUES ('Elizabeth McGovern'); #61
INSERT INTO Cast (Name) VALUES ('Ellen Burstyn'); #62
INSERT INTO Cast (Name) VALUES ('Ellen Page'); #63
INSERT INTO Cast (Name) VALUES ('Ellen Widmann'); #64
INSERT INTO Cast (Name) VALUES ('Enzo Cannavale'); #65
INSERT INTO Cast (Name) VALUES ('Erich von Stroheim'); #66
INSERT INTO Cast (Name) VALUES ('Eva Marie Saint'); #67
INSERT INTO Cast (Name) VALUES ('F. Murray Abraham'); #68
INSERT INTO Cast (Name) VALUES ('Fatima Sana Shaikh'); #69
INSERT INTO Cast (Name) VALUES ('Florence Lee'); #70
INSERT INTO Cast (Name) VALUES ('Frank Finlay'); #71
INSERT INTO Cast (Name) VALUES ('François Cluzet'); #72
INSERT INTO Cast (Name) VALUES ('Gabriel Byrne'); #73
INSERT INTO Cast (Name) VALUES ('Gael García Bernal'); #74
INSERT INTO Cast (Name) VALUES ('Gary Lockwood'); #75
INSERT INTO Cast (Name) VALUES ('Gary Oldman'); #76
INSERT INTO Cast (Name) VALUES ('Gary Sinise'); #77
INSERT INTO Cast (Name) VALUES ('George C. Scott'); #78
INSERT INTO Cast (Name) VALUES ('Giorgio Cantarini'); #79
INSERT INTO Cast (Name) VALUES ('Gloria Swanson'); #80
INSERT INTO Cast (Name) VALUES ('Grace Kelly'); #81
INSERT INTO Cast (Name) VALUES ('Guy Pearce'); #82
INSERT INTO Cast (Name) VALUES ('Hailee Steinfeld'); #83
INSERT INTO Cast (Name) VALUES ('Harrison Ford'); #84
INSERT INTO Cast (Name) VALUES ('Harvey Keitel'); #85
INSERT INTO Cast (Name) VALUES ('Heath Ledger'); #86
INSERT INTO Cast (Name) VALUES ('Henry Bergman'); #87
INSERT INTO Cast (Name) VALUES ('Henry Fonda'); #88
INSERT INTO Cast (Name) VALUES ('Herbert Grönemeyer'); #89
INSERT INTO Cast (Name) VALUES ('Hugh Jackman'); #90
INSERT INTO Cast (Name) VALUES ('Humphrey Bogart'); #91
INSERT INTO Cast (Name) VALUES ('Hye-jeong Kang'); #92
INSERT INTO Cast (Name) VALUES ('Ian McKellen'); #93
INSERT INTO Cast (Name) VALUES ('Inge Landgut'); #94
INSERT INTO Cast (Name) VALUES ('Ingrid Bergman'); #95
INSERT INTO Cast (Name) VALUES ('J.K. Simmons'); #96
INSERT INTO Cast (Name) VALUES ('Jack Nicholson'); #97
INSERT INTO Cast (Name) VALUES ('Jack Oakie'); #98
INSERT INTO Cast (Name) VALUES ('Jackie Coogan'); #99
INSERT INTO Cast (Name) VALUES ('Jake Johnson'); #100
INSERT INTO Cast (Name) VALUES ('James Caan'); #101
INSERT INTO Cast (Name) VALUES ('James Earl Jones'); #102
INSERT INTO Cast (Name) VALUES ('James Mason'); #103
INSERT INTO Cast (Name) VALUES ('James Stewart'); #104
INSERT INTO Cast (Name) VALUES ('James Woods'); #105
INSERT INTO Cast (Name) VALUES ('Jamie Foxx'); #106
INSERT INTO Cast (Name) VALUES ('Janet Leigh'); #107
INSERT INTO Cast (Name) VALUES ('Jared Leto'); #108
INSERT INTO Cast (Name) VALUES ('Jason Statham'); #109
INSERT INTO Cast (Name) VALUES ('Jean Reno'); #110
INSERT INTO Cast (Name) VALUES ('Jeff Garlin'); #111
INSERT INTO Cast (Name) VALUES ('Jennifer Connelly'); #112
INSERT INTO Cast (Name) VALUES ('Jeremy Irons'); #113
INSERT INTO Cast (Name) VALUES ('Jessica Chastain'); #114
INSERT INTO Cast (Name) VALUES ('Ji-Tae Yoo'); #115
INSERT INTO Cast (Name) VALUES ('Jim Carrey'); #116
INSERT INTO Cast (Name) VALUES ('Joaquin Phoenix'); #117
INSERT INTO Cast (Name) VALUES ('Jodie Foster'); #118
INSERT INTO Cast (Name) VALUES ('Joe Pantoliano'); #119
INSERT INTO Cast (Name) VALUES ('Joe Pesci'); #120
INSERT INTO Cast (Name) VALUES ('John Hurt'); #121
INSERT INTO Cast (Name) VALUES ('John Travolta'); #122
INSERT INTO Cast (Name) VALUES ('Joseph Cotten'); #123
INSERT INTO Cast (Name) VALUES ('Joseph Gordon-Levitt'); #124
INSERT INTO Cast (Name) VALUES ('Jürgen Prochnow'); #125
INSERT INTO Cast (Name) VALUES ('Kang-ho Song'); #126
INSERT INTO Cast (Name) VALUES ('Karen Allen'); #127
INSERT INTO Cast (Name) VALUES ('Kate Winslet'); #128
INSERT INTO Cast (Name) VALUES ('Keanu Reeves'); #129
INSERT INTO Cast (Name) VALUES ('Keiko Tsushima'); #130
INSERT INTO Cast (Name) VALUES ('Keir Dullea'); #131
INSERT INTO Cast (Name) VALUES ('Kevin Spacey'); #132
INSERT INTO Cast (Name) VALUES ('Kim Novak'); #133
INSERT INTO Cast (Name) VALUES ('Kirk Douglas'); #134
INSERT INTO Cast (Name) VALUES ('Klaus Wennemann'); #135
INSERT INTO Cast (Name) VALUES ('Laurence Fishburne'); #136
INSERT INTO Cast (Name) VALUES ('Lawrence A. Bonney'); #137
INSERT INTO Cast (Name) VALUES ('Lea Thompson'); #138
INSERT INTO Cast (Name) VALUES ('Leandro Firmino'); #139
INSERT INTO Cast (Name) VALUES ('Lee J. Cobb'); #140
INSERT INTO Cast (Name) VALUES ('Lee Van Cleef'); #141
INSERT INTO Cast (Name) VALUES ('Leonardo DiCaprio'); #142
INSERT INTO Cast (Name) VALUES ('Liam Neeson'); #143
INSERT INTO Cast (Name) VALUES ('Linda Hamilton'); #144
INSERT INTO Cast (Name) VALUES ('Lionel Barrymore'); #145
INSERT INTO Cast (Name) VALUES ('Louise Fletcher'); #146
INSERT INTO Cast (Name) VALUES ('Madhavan'); #147
INSERT INTO Cast (Name) VALUES ('Mads Mikkelsen'); #148
INSERT INTO Cast (Name) VALUES ('Malcolm McDowell'); #149
INSERT INTO Cast (Name) VALUES ('Mark Hamill'); #150
INSERT INTO Cast (Name) VALUES ('Mark Ruffalo'); #151
INSERT INTO Cast (Name) VALUES ('Marlene Dietrich'); #152
INSERT INTO Cast (Name) VALUES ('Marlon Brando'); #153
INSERT INTO Cast (Name) VALUES ('Martin Balsam'); #154
INSERT INTO Cast (Name) VALUES ('Martin Sheen'); #155
INSERT INTO Cast (Name) VALUES ('Martina Gedeck'); #156
INSERT INTO Cast (Name) VALUES ('Matheus Nachtergaele'); #157
INSERT INTO Cast (Name) VALUES ('Mathieu Kassovitz'); #158
INSERT INTO Cast (Name) VALUES ('Matt Damon'); #159
INSERT INTO Cast (Name) VALUES ('Matthew Broderick'); #160
INSERT INTO Cast (Name) VALUES ('Matthew McConaughey'); #161
INSERT INTO Cast (Name) VALUES ('Matthew Modine'); #162
INSERT INTO Cast (Name) VALUES ('Meat Loaf'); #163
INSERT INTO Cast (Name) VALUES ('Mel Gibson'); #164
INSERT INTO Cast (Name) VALUES ('Melissa Benoist'); #165
INSERT INTO Cast (Name) VALUES ('Michael Bates'); #166
INSERT INTO Cast (Name) VALUES ('Michael Biehn'); #167
INSERT INTO Cast (Name) VALUES ('Michael Clarke Duncan'); #168
INSERT INTO Cast (Name) VALUES ('Michael J. Fox'); #169
INSERT INTO Cast (Name) VALUES ('Michael Madsen'); #170
INSERT INTO Cast (Name) VALUES ('Miles Teller'); #171
INSERT INTO Cast (Name) VALUES ('Min-sik Choi'); #172
INSERT INTO Cast (Name) VALUES ('Miyu Irino'); #173
INSERT INTO Cast (Name) VALUES ('Mona Singh'); #174
INSERT INTO Cast (Name) VALUES ('Mone Kamishiraishi'); #175
INSERT INTO Cast (Name) VALUES ('Morgan Freeman'); #176
INSERT INTO Cast (Name) VALUES ('Natalie Portman'); #177
INSERT INTO Cast (Name) VALUES ('Nicoletta Braschi'); #178
INSERT INTO Cast (Name) VALUES ('Omar Sy'); #179
INSERT INTO Cast (Name) VALUES ('Orlando Bloom'); #180
INSERT INTO Cast (Name) VALUES ('Orson Welles'); #181
INSERT INTO Cast (Name) VALUES ('Patrick Magee'); #182
INSERT INTO Cast (Name) VALUES ('Patrick McGoohan'); #183
INSERT INTO Cast (Name) VALUES ('Paul Freeman'); #184
INSERT INTO Cast (Name) VALUES ('Paul Henreid'); #185
INSERT INTO Cast (Name) VALUES ('Paulette Goddard'); #186
INSERT INTO Cast (Name) VALUES ('Peter Lorre'); #187
INSERT INTO Cast (Name) VALUES ('Peter Sellers'); #188
INSERT INTO Cast (Name) VALUES ('Philippe Noiret'); #189
INSERT INTO Cast (Name) VALUES ('R. Lee Ermey'); #190
INSERT INTO Cast (Name) VALUES ('Ralph Fiennes'); #191
INSERT INTO Cast (Name) VALUES ('Ralph Meeker'); #192
INSERT INTO Cast (Name) VALUES ('Ray Liotta'); #193
INSERT INTO Cast (Name) VALUES ('Robert De Niro'); #194
INSERT INTO Cast (Name) VALUES ('Robert Downey Jr.'); #195
INSERT INTO Cast (Name) VALUES ('Robert Duvall'); #196
INSERT INTO Cast (Name) VALUES ('Roberto Benigni'); #197
INSERT INTO Cast (Name) VALUES ('Robin Williams'); #198
INSERT INTO Cast (Name) VALUES ('Robin Wright'); #199
INSERT INTO Cast (Name) VALUES ('Rufus'); #200
INSERT INTO Cast (Name) VALUES ('Russell Crowe'); #201
INSERT INTO Cast (Name) VALUES ('Ryô Narita'); #202
INSERT INTO Cast (Name) VALUES ('Ryûnosuke Kamiki'); #203
INSERT INTO Cast (Name) VALUES ('Sakshi Tanwar'); #204
INSERT INTO Cast (Name) VALUES ('Samuel L. Jackson'); #205
INSERT INTO Cast (Name) VALUES ('Scarlett Johansson'); #206
INSERT INTO Cast (Name) VALUES ('Sebastian Koch'); #207
INSERT INTO Cast (Name) VALUES ('Shameik Moore'); #208
INSERT INTO Cast (Name) VALUES ('Shelley Duvall'); #209
INSERT INTO Cast (Name) VALUES ('Shima Iwashita'); #210
INSERT INTO Cast (Name) VALUES ('Sigourney Weaver'); #211
INSERT INTO Cast (Name) VALUES ('Sophie Marceau'); #212
INSERT INTO Cast (Name) VALUES ('Sterling Hayden'); #213
INSERT INTO Cast (Name) VALUES ('Sun-kyun Lee'); #214
INSERT INTO Cast (Name) VALUES ('Suzanne Pleshette'); #215
INSERT INTO Cast (Name) VALUES ('Takashi Shimura'); #216
INSERT INTO Cast (Name) VALUES ('Tatsuya Nakadai'); #217
INSERT INTO Cast (Name) VALUES ('Thomas Bo Larsen'); #218
INSERT INTO Cast (Name) VALUES ('Thomas Kretschmann'); #219
INSERT INTO Cast (Name) VALUES ('Thora Birch'); #220
INSERT INTO Cast (Name) VALUES ('Tim Allen'); #221
INSERT INTO Cast (Name) VALUES ('Tim Robbins'); #222
INSERT INTO Cast (Name) VALUES ('Tim Roth'); #223
INSERT INTO Cast (Name) VALUES ('Tisca Chopra'); #224
INSERT INTO Cast (Name) VALUES ('Tom Hanks'); #225
INSERT INTO Cast (Name) VALUES ('Tom Hardy'); #226
INSERT INTO Cast (Name) VALUES ('Tom Hulce'); #227
INSERT INTO Cast (Name) VALUES ('Tom Sizemore'); #228
INSERT INTO Cast (Name) VALUES ('Tom Skerritt'); #229
INSERT INTO Cast (Name) VALUES ('Tom Wilkinson'); #230
INSERT INTO Cast (Name) VALUES ('Toshirô Mifune'); #231
INSERT INTO Cast (Name) VALUES ('Tsutomu Tatsumi'); #232
INSERT INTO Cast (Name) VALUES ('Tyrone Power'); #233
INSERT INTO Cast (Name) VALUES ('Ulrich Mühe'); #234
INSERT INTO Cast (Name) VALUES ('Uma Thurman'); #235
INSERT INTO Cast (Name) VALUES ('Vera Miles'); #236
INSERT INTO Cast (Name) VALUES ('Viggo Mortensen'); #237
INSERT INTO Cast (Name) VALUES ('Vincent D\'Onofrio'); #238
INSERT INTO Cast (Name) VALUES ('Virginia Cherrill'); #239
INSERT INTO Cast (Name) VALUES ('Wendell Corey'); #240
INSERT INTO Cast (Name) VALUES ('Will Sampson'); #241
INSERT INTO Cast (Name) VALUES ('William Holden'); #242
INSERT INTO Cast (Name) VALUES ('William Sylvester'); #243
INSERT INTO Cast (Name) VALUES ('Yeo-jeong Jo'); #244
INSERT INTO Cast (Name) VALUES ('Yuriko Ishida'); #245
INSERT INTO Cast (Name) VALUES ('Yôji Matsuda'); #246
INSERT INTO Cast (Name) VALUES ('Yûko Tanaka'); #247
INSERT INTO Cast (Name) VALUES ('Zazie Beetz'); #248

select * from Cast order by ID asc;

#################################################################################### insert Genre

INSERT INTO Genres (Genre) VALUES ('Action'); #1
INSERT INTO Genres (Genre) VALUES ('Adventure'); #2
INSERT INTO Genres (Genre) VALUES ('Animation'); #3
INSERT INTO Genres (Genre) VALUES ('Biography'); #4
INSERT INTO Genres (Genre) VALUES ('Comedy'); #5
INSERT INTO Genres (Genre) VALUES ('Crime'); #6
INSERT INTO Genres (Genre) VALUES ('Drama'); #7
INSERT INTO Genres (Genre) VALUES ('Family'); #8
INSERT INTO Genres (Genre) VALUES ('Fantasy'); #9
INSERT INTO Genres (Genre) VALUES ('Film-Noir'); #10
INSERT INTO Genres (Genre) VALUES ('History'); #11
INSERT INTO Genres (Genre) VALUES ('Horror'); #12
INSERT INTO Genres (Genre) VALUES ('Music'); #13
INSERT INTO Genres (Genre) VALUES ('Musical'); #14
INSERT INTO Genres (Genre) VALUES ('Mystery'); #15
INSERT INTO Genres (Genre) VALUES ('Romance'); #16
INSERT INTO Genres (Genre) VALUES ('Sci-Fi'); #17
INSERT INTO Genres (Genre) VALUES ('Sport'); #18
INSERT INTO Genres (Genre) VALUES ('Thriller'); #19
INSERT INTO Genres (Genre) VALUES ('War'); #20
INSERT INTO Genres (Genre) VALUES ('Western'); #21

select * from Genres order by ID asc;

#################################################################################### insert MovieDirectors

INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (1,30); # James Cameron is the director of Aliens
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (2,46); # Milos Forman is the director of One Flew Over the Cuckoo\'s Nest
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (3,12); # Charles Chaplin is the director of The Kid
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (4,58); # Roberto Benigni is the director of Life Is Beautiful
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (5,27); # Hayao Miyazaki is the director of Princess Mononoke
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (6,7); # Billy Wilder is the director of Witness for the Prosecution
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (7,10); # Bryan Singer is the director of The Usual Suspects
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (8,60); # Roman Polanski is the director of The Pianist
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (9,6); # Anthony Russo is the director of Avengers: Infinity War
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (9,32); # Joe Russo is the director of Avengers: Infinity War
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (10,50); # Peter Jackson is the director of The Lord of the Rings: The Return of the King
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (11,31); # Jean-Pierre Jeunet is the director of Amélie
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (12,36); # Lana Wachowski is the director of The Matrix
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (12,38); # Lilly Wachowski is the director of The Matrix
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (13,64); # Stanley Kubrick is the director of 2001: A Space Odyssey
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (14,50); # Peter Jackson is the director of The Lord of the Rings: The Two Towers
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (15,28); # Irvin Kershner is the director of Star Wars: Episode V - The Empire Strikes Back
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (16,19); # Francis Ford Coppola is the director of Apocalypse Now
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (17,3); # Alfred Hitchcock is the director of North by Northwest
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (18,64); # Stanley Kubrick is the director of The Shining
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (19,1); # Aamir Khan is the director of 3 Idiots
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (19,53); # Rajkumar Hirani is the director of 3 Idiots
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (20,6); # Anthony Russo is the director of Avengers: Endgame
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (20,32); # Joe Russo is the director of Avengers: Endgame
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (21,62); # Sergio Leone is the director of Once Upon a Time in America
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (22,13); # Christopher Nolan is the director of The Dark Knight
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (23,48); # Olivier Nakache is the director of Untouchable
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (23,70); # Éric Toledano is the director of Untouchable
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (24,44); # Michael Curtiz is the director of Casablanca
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (25,3); # Alfred Hitchcock is the director of Vertigo
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (26,13); # Christopher Nolan is the director of Interstellar
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (27,42); # Masaki Kobayashi is the director of Harakiri
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (28,23); # George Lucas is the director of Star Wars: Episode IV - A New Hope
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (29,25); # Gus Van Sant is the director of Good Will Hunting
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (30,1); # Aamir Khan is the director of Dangal
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (30,47); # Nitesh Tiwari is the director of Dangal
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (31,64); # Stanley Kubrick is the director of A Clockwork Orange
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (32,45); # Michel Gondry is the director of Eternal Sunshine of the Spotless Mind
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (33,2); # Adrian Molina (co-director) is the director of Coco
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (33,37); # Lee Unkrich is the director of Coco
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (33,70); # director is the director of Coco
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (34,1); # Aamir Khan is the director of Like Stars on Earth
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (34,4); # Amole Gupte is the director of Like Stars on Earth
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (35,63); # Sidney Lumet is the director of 12 Angry Men
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (36,41); # Martin Scorsese is the director of The Departed
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (37,13); # Christopher Nolan is the director of Inception
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (38,66); # Thomas Vinterberg is the director of The Hunt
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (39,15); # Darren Aronofsky is the director of Requiem for a Dream
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (40,5); # Andrew Stanton is the director of WALL·E
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (41,20); # Frank Capra is the director of It\'s a Wonderful Life
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (42,55); # Ridley Scott is the director of Alien
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (43,68); # Tony Kaye is the director of American History X
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (44,33); # John Lasseter is the director of Toy Story
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (46,12); # Charles Chaplin is the director of Modern Times
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (47,21); # Frank Darabont is the director of The Green Mile
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (48,65); # Steven Spielberg is the director of Schindler\'s List
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (49,3); # Alfred Hitchcock is the director of Rear Window
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (50,64); # Stanley Kubrick is the director of Full Metal Jacket
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (51,12); # Charles Chaplin is the director of City Lights
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (52,12); # Charles Chaplin is the director of The Great Dictator
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (53,22); # Fritz Lang is the director of M
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (54,29); # Isao Takahata is the director of Grave of the Fireflies
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (55,34); # Jonathan Demme is the director of The Silence of the Lambs
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (56,55); # Ridley Scott is the director of Gladiator
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (57,57); # Robert Zemeckis is the director of Back to the Future
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (58,43); # Mel Gibson is the director of Braveheart
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (59,39); # Luc Besson is the director of Leon
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (60,52); # Quentin Tarantino is the director of Inglourious Basterds
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (61,21); # Frank Darabont is the director of The Shawshank Redemption
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (62,11); # Chan-wook Park is the director of Oldboy
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (63,17); # Fernando Meirelles is the director of City of God
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (63,35); # Kátia Lund (co-director) is the director of City of God
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (64,57); # Robert Zemeckis is the director of Forrest Gump
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (65,52); # Quentin Tarantino is the director of Reservoir Dogs
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (66,50); # Peter Jackson is the director of The Lord of the Rings: The Fellowship of the Ring
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (67,67); # Todd Phillips is the director of Joker
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (68,13); # Christopher Nolan is the director of Memento
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (69,13); # Christopher Nolan is the director of The Prestige
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (70,40); # Makoto Shinkai is the director of Your Name.
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (71,61); # Sam Mendes is the director of American Beauty
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (72,18); # Florian Henckel von Donnersmarck is the director of The Lives of Others
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (73,65); # Steven Spielberg is the director of Saving Private Ryan
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (74,23); # George Lucas is the director of Raiders of the Lost Ark
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (74,65); # Steven Spielberg is the director of Raiders of the Lost Ark
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (75,62); # Sergio Leone is the director of Once Upon a Time in the West
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (76,19); # Francis Ford Coppola is the director of The Godfather
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (77,30); # James Cameron is the director of Terminator 2: Judgment Day
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (78,56); # Rob Minkoff is the director of The Lion King
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (78,59); # Roger Allers is the director of The Lion King
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (79,23); # George Lucas is the director of Star Wars: Episode VI - Return of the Jedi
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (79,54); # Richard Marquand is the director of Star Wars: Episode VI - Return of the Jedi
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (80,16); # David Fincher is the director of Seven
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (81,7); # Billy Wilder is the director of Sunset Blvd.
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (82,27); # Hayao Miyazaki is the director of Spirited Away
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (83,52); # Quentin Tarantino is the director of Pulp Fiction
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (84,26); # Guy Ritchie is the director of Snatch
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (85,16); # David Fincher is the director of Fight Club
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (86,3); # Alfred Hitchcock is the director of Psycho
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (87,49); # Orson Welles is the director of Citizen Kane
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (88,69); # Wolfgang Petersen is the director of Das Boot
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (89,64); # Stanley Kubrick is the director of Paths of Glory
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (90,8); # Bob Persichetti is the director of Spider-Man: Into the Spider-Verse
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (90,51); # Peter Ramsey is the director of Spider-Man: Into the Spider-Verse
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (91,46); # Milos Forman is the director of Amadeus
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (92,52); # Quentin Tarantino is the director of Django Unchained
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (93,62); # Sergio Leone is the director of The Good, the Bad and the Ugly
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (94,41); # Martin Scorsese is the director of Goodfellas
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (95,14); # Damien Chazelle is the director of Whiplash
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (96,19); # Francis Ford Coppola is the director of The Godfather: Part II
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (97,9); # Bong Joon Ho is the director of Parasite
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (98,64); # Stanley Kubrick is the director of Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (99,24); # Giuseppe Tornatore is the director of Cinema Paradiso
INSERT INTO MovieDirectors (MovieID,DirectorID) VALUES (100,13); # Christopher Nolan is the director of The Dark Knight Rises

SELECT * FROM MovieDirectors ORDER BY MovieID ASC;

#################################################################################### INSERT Writers

INSERT INTO Writers (Name) VALUES ('Abhijat Joshi'); #1
INSERT INTO Writers (Name) VALUES ('Agatha Christie'); #2
INSERT INTO Writers (Name) VALUES ('Akiyuki Nosaka'); #3
INSERT INTO Writers (Name) VALUES ('Alan Ball'); #4
INSERT INTO Writers (Name) VALUES ('Alan Mak'); #5
INSERT INTO Writers (Name) VALUES ('Albert Hackett'); #6
INSERT INTO Writers (Name) VALUES ('Alec Coppel'); #7
INSERT INTO Writers (Name) VALUES ('Amole Gupte'); #8
INSERT INTO Writers (Name) VALUES ('Andrew Kevin Walker'); #9
INSERT INTO Writers (Name) VALUES ('Andrew Stanton'); #10
INSERT INTO Writers (Name) VALUES ('Anthony Burgess'); #11
INSERT INTO Writers (Name) VALUES ('Arthur C. Clarke'); #12
INSERT INTO Writers (Name) VALUES ('Ben Affleck'); #13
INSERT INTO Writers (Name) VALUES ('Billy Wilder'); #14
INSERT INTO Writers (Name) VALUES ('Bo Goldman'); #15
INSERT INTO Writers (Name) VALUES ('Bob Gale'); #16
INSERT INTO Writers (Name) VALUES ('Bong Joon Ho'); #17
INSERT INTO Writers (Name) VALUES ('Bráulio Mantovani'); #18
INSERT INTO Writers (Name) VALUES ('Calder Willingham'); #19
INSERT INTO Writers (Name) VALUES ('Charles Brackett'); #20
INSERT INTO Writers (Name) VALUES ('Charles Chaplin'); #21
INSERT INTO Writers (Name) VALUES ('Charlie Kaufman'); #22
INSERT INTO Writers (Name) VALUES ('Christopher Markus'); #23
INSERT INTO Writers (Name) VALUES ('Christopher McQuarrie'); #24
INSERT INTO Writers (Name) VALUES ('Christopher Nolan'); #25
INSERT INTO Writers (Name) VALUES ('Chuck Palahniuk'); #26
INSERT INTO Writers (Name) VALUES ('Cornell Woolrich'); #27
INSERT INTO Writers (Name) VALUES ('Damien Chazelle'); #28
INSERT INTO Writers (Name) VALUES ('Dan O\'Bannon'); #29
INSERT INTO Writers (Name) VALUES ('David Franzoni'); #30
INSERT INTO Writers (Name) VALUES ('David Giler'); #31
INSERT INTO Writers (Name) VALUES ('David McKenna'); #32
INSERT INTO Writers (Name) VALUES ('Eric Roth'); #33
INSERT INTO Writers (Name) VALUES ('Ernest Lehman'); #34
INSERT INTO Writers (Name) VALUES ('Florian Henckel von Donnersmarck'); #35
INSERT INTO Writers (Name) VALUES ('Fran Walsh'); #36
INSERT INTO Writers (Name) VALUES ('Frances Goodrich'); #37
INSERT INTO Writers (Name) VALUES ('Francis Ford Coppola'); #38
INSERT INTO Writers (Name) VALUES ('Frank Darabont'); #39
INSERT INTO Writers (Name) VALUES ('Fritz Lang'); #40
INSERT INTO Writers (Name) VALUES ('Garon Tsuchiya'); #41
INSERT INTO Writers (Name) VALUES ('George Lucas'); #42
INSERT INTO Writers (Name) VALUES ('Giuseppe Tornatore'); #43
INSERT INTO Writers (Name) VALUES ('Guillaume Laurant'); #44
INSERT INTO Writers (Name) VALUES ('Guy Ritchie'); #45
INSERT INTO Writers (Name) VALUES ('Harry Grey'); #46
INSERT INTO Writers (Name) VALUES ('Hayao Miyazaki'); #47
INSERT INTO Writers (Name) VALUES ('Herman J. Mankiewicz'); #48
INSERT INTO Writers (Name) VALUES ('Hubert Selby Jr.'); #49
INSERT INTO Writers (Name) VALUES ('Irene Mecchi'); #50
INSERT INTO Writers (Name) VALUES ('Isao Takahata'); #51
INSERT INTO Writers (Name) VALUES ('J.R.R. Tolkien'); #52
INSERT INTO Writers (Name) VALUES ('James Cameron'); #53
INSERT INTO Writers (Name) VALUES ('Jason Katz'); #54
INSERT INTO Writers (Name) VALUES ('Jean-Pierre Jeunet'); #55
INSERT INTO Writers (Name) VALUES ('Jim Uhls'); #56
INSERT INTO Writers (Name) VALUES ('John Lasseter'); #57
INSERT INTO Writers (Name) VALUES ('John Michael Hayes'); #58
INSERT INTO Writers (Name) VALUES ('John Milius'); #59
INSERT INTO Writers (Name) VALUES ('Jonathan Nolan'); #60
INSERT INTO Writers (Name) VALUES ('Jonathan Roberts'); #61
INSERT INTO Writers (Name) VALUES ('Joseph Stefano'); #62
INSERT INTO Writers (Name) VALUES ('Julius J. Epstein'); #63
INSERT INTO Writers (Name) VALUES ('Lana Wachowski'); #64
INSERT INTO Writers (Name) VALUES ('Lawrence Hauben'); #65
INSERT INTO Writers (Name) VALUES ('Lawrence Kasdan'); #66
INSERT INTO Writers (Name) VALUES ('Lee Unkrich'); #67
INSERT INTO Writers (Name) VALUES ('Leigh Brackett'); #68
INSERT INTO Writers (Name) VALUES ('Leonardo Benvenuti'); #69
INSERT INTO Writers (Name) VALUES ('Lilly Wachowski'); #70
INSERT INTO Writers (Name) VALUES ('Lothar G. Buchheim'); #71
INSERT INTO Writers (Name) VALUES ('Luc Besson'); #72
INSERT INTO Writers (Name) VALUES ('Luciano Vincenzoni'); #73
INSERT INTO Writers (Name) VALUES ('Makoto Shinkai'); #74
INSERT INTO Writers (Name) VALUES ('Mario Puzo'); #75
INSERT INTO Writers (Name) VALUES ('Matt Damon'); #76
INSERT INTO Writers (Name) VALUES ('Michael Herr'); #77
INSERT INTO Writers (Name) VALUES ('Michel Gondry'); #78
INSERT INTO Writers (Name) VALUES ('Neil Gaiman'); #79
INSERT INTO Writers (Name) VALUES ('Nicholas Pileggi'); #80
INSERT INTO Writers (Name) VALUES ('Nobuaki Minegishi'); #81
INSERT INTO Writers (Name) VALUES ('Olivier Nakache'); #82
INSERT INTO Writers (Name) VALUES ('Orson Welles'); #83
INSERT INTO Writers (Name) VALUES ('Paulo Lins'); #84
INSERT INTO Writers (Name) VALUES ('Pete Docter'); #85
INSERT INTO Writers (Name) VALUES ('Peter Shaffer'); #86
INSERT INTO Writers (Name) VALUES ('Phil Lord'); #87
INSERT INTO Writers (Name) VALUES ('Philip G. Epstein'); #88
INSERT INTO Writers (Name) VALUES ('Philippe Pozzo di Borgo'); #89
INSERT INTO Writers (Name) VALUES ('Piyush Gupta'); #90
INSERT INTO Writers (Name) VALUES ('Quentin Tarantino'); #91
INSERT INTO Writers (Name) VALUES ('Rajkumar Hirani'); #92
INSERT INTO Writers (Name) VALUES ('Randall Wallace'); #93
INSERT INTO Writers (Name) VALUES ('Reginald Rose'); #94
INSERT INTO Writers (Name) VALUES ('Robert Bloch'); #95
INSERT INTO Writers (Name) VALUES ('Robert Rodat'); #96
INSERT INTO Writers (Name) VALUES ('Robert Zemeckis'); #97
INSERT INTO Writers (Name) VALUES ('Roberto Benigni'); #98
INSERT INTO Writers (Name) VALUES ('Rodney Rothman'); #99
INSERT INTO Writers (Name) VALUES ('Roger Avary'); #100
INSERT INTO Writers (Name) VALUES ('Ronald Harwood'); #101
INSERT INTO Writers (Name) VALUES ('Samuel A. Taylor'); #102
INSERT INTO Writers (Name) VALUES ('Scott Silver'); #103
INSERT INTO Writers (Name) VALUES ('Sergio Donati'); #104
INSERT INTO Writers (Name) VALUES ('Sergio Leone'); #105
INSERT INTO Writers (Name) VALUES ('Shinobu Hashimoto'); #106
INSERT INTO Writers (Name) VALUES ('Shreyas Jain'); #107
INSERT INTO Writers (Name) VALUES ('Stanley Kubrick'); #108
INSERT INTO Writers (Name) VALUES ('Stephen King'); #109
INSERT INTO Writers (Name) VALUES ('Stephen McFeely'); #110
INSERT INTO Writers (Name) VALUES ('Steven Zaillian'); #111
INSERT INTO Writers (Name) VALUES ('Ted Tally'); #112
INSERT INTO Writers (Name) VALUES ('Terry Southern'); #113
INSERT INTO Writers (Name) VALUES ('Thea von Harbou'); #114
INSERT INTO Writers (Name) VALUES ('Thomas Harris'); #115
INSERT INTO Writers (Name) VALUES ('Thomas Keneally'); #116
INSERT INTO Writers (Name) VALUES ('Thomas Vinterberg'); #117
INSERT INTO Writers (Name) VALUES ('Tobias Lindholm'); #118
INSERT INTO Writers (Name) VALUES ('Todd Phillips'); #119
INSERT INTO Writers (Name) VALUES ('Vincenzo Cerami'); #120
INSERT INTO Writers (Name) VALUES ('William Monahan'); #121
INSERT INTO Writers (Name) VALUES ('William Wisher'); #122
INSERT INTO Writers (Name) VALUES ('Winston Groom'); #123
INSERT INTO Writers (Name) VALUES ('Wladyslaw Szpilman'); #124
INSERT INTO Writers (Name) VALUES ('Wolfgang Petersen'); #125
INSERT INTO Writers (Name) VALUES ('Yasuhiko Takiguchi'); #126

SELECT * FROM Writers ORDER BY ID ASC;

#################################################################################### INSERT MovieGenres

INSERT INTO MovieGenres (MovieID,GenreID) VALUES (1,1); # Aliens is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (1,2); # Aliens is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (1,17); # Aliens is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (1,19); # Aliens is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (2,7); # One Flew Over the Cuckoo\'s Nest is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (3,5); # The Kid is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (3,7); # The Kid is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (3,8); # The Kid is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (4,5); # Life Is Beautiful is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (4,7); # Life Is Beautiful is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (4,16); # Life Is Beautiful is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (4,20); # Life Is Beautiful is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (5,2); # Princess Mononoke is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (5,3); # Princess Mononoke is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (5,9); # Princess Mononoke is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (6,6); # Witness for the Prosecution is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (6,7); # Witness for the Prosecution is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (6,10); # Witness for the Prosecution is Film-Noir
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (6,15); # Witness for the Prosecution is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (6,19); # Witness for the Prosecution is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (7,6); # The Usual Suspects is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (7,15); # The Usual Suspects is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (7,19); # The Usual Suspects is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (8,4); # The Pianist is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (8,7); # The Pianist is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (8,13); # The Pianist is Music
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (8,20); # The Pianist is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (9,1); # Avengers: Infinity War is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (9,2); # Avengers: Infinity War is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (9,17); # Avengers: Infinity War is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (9,20); # Avengers: Infinity War is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (10,2); # The Lord of the Rings: The Return of the King is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (10,7); # The Lord of the Rings: The Return of the King is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (10,9); # The Lord of the Rings: The Return of the King is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (11,5); # Amélie is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (11,16); # Amélie is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (12,1); # The Matrix is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (12,17); # The Matrix is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (13,2); # 2001: A Space Odyssey is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (13,17); # 2001: A Space Odyssey is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (14,2); # The Lord of the Rings: The Two Towers is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (14,7); # The Lord of the Rings: The Two Towers is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (14,9); # The Lord of the Rings: The Two Towers is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (15,1); # Star Wars: Episode V - The Empire Strikes Back is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (15,2); # Star Wars: Episode V - The Empire Strikes Back is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (15,9); # Star Wars: Episode V - The Empire Strikes Back is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (15,17); # Star Wars: Episode V - The Empire Strikes Back is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (15,20); # Star Wars: Episode V - The Empire Strikes Back is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (16,7); # Apocalypse Now is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (16,15); # Apocalypse Now is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (16,20); # Apocalypse Now is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (17,2); # North by Northwest is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (17,15); # North by Northwest is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (17,19); # North by Northwest is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (18,7); # The Shining is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (18,12); # The Shining is Horror
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (19,5); # 3 Idiots is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (19,7); # 3 Idiots is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (20,1); # Avengers: Endgame is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (20,2); # Avengers: Endgame is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (20,7); # Avengers: Endgame is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (20,17); # Avengers: Endgame is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (21,6); # Once Upon a Time in America is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (21,7); # Once Upon a Time in America is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (22,1); # The Dark Knight is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (22,6); # The Dark Knight is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (22,7); # The Dark Knight is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (22,19); # The Dark Knight is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (23,4); # Untouchable is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (23,5); # Untouchable is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (23,7); # Untouchable is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (24,7); # Casablanca is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (24,16); # Casablanca is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (24,20); # Casablanca is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (25,15); # Vertigo is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (25,16); # Vertigo is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (25,19); # Vertigo is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (26,2); # Interstellar is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (26,7); # Interstellar is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (26,17); # Interstellar is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (27,1); # Harakiri is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (27,7); # Harakiri is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (27,11); # Harakiri is History
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (28,1); # Star Wars: Episode IV - A New Hope is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (28,2); # Star Wars: Episode IV - A New Hope is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (28,9); # Star Wars: Episode IV - A New Hope is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (28,17); # Star Wars: Episode IV - A New Hope is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (28,20); # Star Wars: Episode IV - A New Hope is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (29,7); # Good Will Hunting is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (29,16); # Good Will Hunting is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (30,1); # Dangal is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (30,4); # Dangal is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (30,7); # Dangal is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (30,18); # Dangal is Sport
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (31,6); # A Clockwork Orange is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (31,7); # A Clockwork Orange is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (31,17); # A Clockwork Orange is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (32,7); # Eternal Sunshine of the Spotless Mind is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (32,16); # Eternal Sunshine of the Spotless Mind is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (32,17); # Eternal Sunshine of the Spotless Mind is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,2); # Coco is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,3); # Coco is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,8); # Coco is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,9); # Coco is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,13); # Coco is Music
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (33,15); # Coco is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (34,7); # Like Stars on Earth is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (34,8); # Like Stars on Earth is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (35,7); # 12 Angry Men is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (36,6); # The Departed is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (36,7); # The Departed is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (36,19); # The Departed is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (37,1); # Inception is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (37,2); # Inception is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (37,17); # Inception is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (37,19); # Inception is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (38,7); # The Hunt is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (39,7); # Requiem for a Dream is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (40,2); # WALL·E is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (40,3); # WALL·E is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (40,8); # WALL·E is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (40,17); # WALL·E is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (41,7); # It\'s a Wonderful Life is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (41,8); # It\'s a Wonderful Life is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (41,9); # It\'s a Wonderful Life is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (42,12); # Alien is Horror
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (42,17); # Alien is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (43,7); # American History X is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (43,11); # American History X is History
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (44,2); # Toy Story is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (44,3); # Toy Story is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (44,5); # Toy Story is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (44,8); # Toy Story is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (44,9); # Toy Story is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (45,1); # Seven Samurai is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (45,2); # Seven Samurai is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (45,7); # Seven Samurai is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (46,5); # Modern Times is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (46,7); # Modern Times is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (46,8); # Modern Times is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (46,16); # Modern Times is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (47,6); # The Green Mile is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (47,7); # The Green Mile is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (47,9); # The Green Mile is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (47,15); # The Green Mile is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (48,4); # Schindler\'s List is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (48,7); # Schindler\'s List is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (48,11); # Schindler\'s List is History
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (49,15); # Rear Window is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (49,19); # Rear Window is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (50,7); # Full Metal Jacket is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (50,20); # Full Metal Jacket is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (51,5); # City Lights is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (51,7); # City Lights is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (51,16); # City Lights is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (52,5); # The Great Dictator is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (52,7); # The Great Dictator is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (52,20); # The Great Dictator is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (53,6); # M is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (53,15); # M is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (53,19); # M is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (54,3); # Grave of the Fireflies is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (54,20); # Grave of the Fireflies is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (55,6); # The Silence of the Lambs is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (55,7); # The Silence of the Lambs is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (55,19); # The Silence of the Lambs is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (56,1); # Gladiator is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (56,2); # Gladiator is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (56,7); # Gladiator is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (57,2); # Back to the Future is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (57,5); # Back to the Future is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (57,17); # Back to the Future is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (58,4); # Braveheart is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (58,7); # Braveheart is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (58,11); # Braveheart is History
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (58,20); # Braveheart is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (59,1); # Leon is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (59,6); # Leon is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (59,7); # Leon is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (59,19); # Leon is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (60,2); # Inglourious Basterds is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (60,7); # Inglourious Basterds is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (60,20); # Inglourious Basterds is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (61,7); # The Shawshank Redemption is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (62,1); # Oldboy is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (62,7); # Oldboy is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (62,15); # Oldboy is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (62,19); # Oldboy is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (63,6); # City of God is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (63,7); # City of God is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (64,7); # Forrest Gump is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (64,16); # Forrest Gump is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (65,6); # Reservoir Dogs is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (65,7); # Reservoir Dogs is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (65,19); # Reservoir Dogs is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (66,1); # The Lord of the Rings: The Fellowship of the Ring is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (66,2); # The Lord of the Rings: The Fellowship of the Ring is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (66,7); # The Lord of the Rings: The Fellowship of the Ring is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (66,9); # The Lord of the Rings: The Fellowship of the Ring is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (67,6); # Joker is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (67,7); # Joker is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (67,19); # Joker is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (68,15); # Memento is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (68,19); # Memento is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (69,7); # The Prestige is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (69,15); # The Prestige is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (69,17); # The Prestige is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (69,19); # The Prestige is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (70,3); # Your Name. is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (70,7); # Your Name. is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (70,9); # Your Name. is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (70,16); # Your Name. is Romance
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (71,7); # American Beauty is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (72,7); # The Lives of Others is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (72,15); # The Lives of Others is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (72,19); # The Lives of Others is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (73,7); # Saving Private Ryan is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (73,20); # Saving Private Ryan is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (74,1); # Raiders of the Lost Ark is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (74,2); # Raiders of the Lost Ark is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (75,21); # Once Upon a Time in the West is Western
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (76,6); # The Godfather is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (76,7); # The Godfather is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (77,1); # Terminator 2: Judgment Day is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (77,17); # Terminator 2: Judgment Day is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,2); # The Lion King is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,3); # The Lion King is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,7); # The Lion King is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,8); # The Lion King is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,13); # The Lion King is Music
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (78,14); # The Lion King is Musical
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (79,1); # Star Wars: Episode VI - Return of the Jedi is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (79,2); # Star Wars: Episode VI - Return of the Jedi is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (79,9); # Star Wars: Episode VI - Return of the Jedi is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (79,17); # Star Wars: Episode VI - Return of the Jedi is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (79,20); # Star Wars: Episode VI - Return of the Jedi is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (80,6); # Seven is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (80,7); # Seven is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (80,15); # Seven is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (80,19); # Seven is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (81,7); # Sunset Blvd. is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (81,10); # Sunset Blvd. is Film-Noir
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (82,2); # Spirited Away is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (82,3); # Spirited Away is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (82,8); # Spirited Away is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (82,9); # Spirited Away is Fantasy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (82,15); # Spirited Away is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (83,6); # Pulp Fiction is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (83,7); # Pulp Fiction is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (84,5); # Snatch is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (84,6); # Snatch is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (85,7); # Fight Club is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (86,12); # Psycho is Horror
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (86,15); # Psycho is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (86,19); # Psycho is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (87,7); # Citizen Kane is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (87,15); # Citizen Kane is Mystery
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (88,2); # Das Boot is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (88,7); # Das Boot is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (88,19); # Das Boot is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (88,20); # Das Boot is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (89,7); # Paths of Glory is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (89,20); # Paths of Glory is War
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (90,1); # Spider-Man: Into the Spider-Verse is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (90,2); # Spider-Man: Into the Spider-Verse is Adventure
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (90,3); # Spider-Man: Into the Spider-Verse is Animation
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (90,8); # Spider-Man: Into the Spider-Verse is Family
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (90,17); # Spider-Man: Into the Spider-Verse is Sci-Fi
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (91,4); # Amadeus is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (91,7); # Amadeus is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (91,11); # Amadeus is History
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (91,13); # Amadeus is Music
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (92,7); # Django Unchained is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (92,21); # Django Unchained is Western
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (93,21); # The Good, the Bad and the Ugly is Western
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (94,4); # Goodfellas is Biography
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (94,6); # Goodfellas is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (94,7); # Goodfellas is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (95,7); # Whiplash is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (95,13); # Whiplash is Music
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (96,6); # The Godfather: Part II is Crime
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (96,7); # The Godfather: Part II is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (97,5); # Parasite is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (97,7); # Parasite is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (97,19); # Parasite is Thriller
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (98,5); # Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb is Comedy
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (99,7); # Cinema Paradiso is Drama
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (100,1); # The Dark Knight Rises is Action
INSERT INTO MovieGenres (MovieID,GenreID) VALUES (100,2); # The Dark Knight Rises is Adventure

SELECT * FROM MovieGenres ORDER BY MovieID ASC;

#################################################################################### INSERT MovieWriters

INSERT INTO MovieWriters (MovieID,WriterID) VALUES (1,31); # Aliens was written by David Giler
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (1,53); # Aliens was written by James Cameron
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (2,15); # One Flew Over the Cuckoo\'s Nest was written by Bo Goldman
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (2,65); # One Flew Over the Cuckoo\'s Nest was written by Lawrence Hauben
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (3,21); # The Kid was written by Charles Chaplin
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (4,98); # Life Is Beautiful was written by Roberto Benigni
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (4,120); # Life Is Beautiful was written by Vincenzo Cerami
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (5,47); # Princess Mononoke was written by Hayao Miyazaki
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (5,79); # Princess Mononoke was written by Neil Gaiman (adapted by: English version)
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (6,2); # Witness for the Prosecution was written by Agatha Christie (in Agatha Christie\'s international stage success)
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (6,14); # Witness for the Prosecution was written by Billy Wilder
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (7,24); # The Usual Suspects was written by Christopher McQuarrie
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (8,101); # The Pianist was written by Ronald Harwood
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (8,124); # The Pianist was written by Wladyslaw Szpilman
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (9,23); # Avengers: Infinity War was written by Christopher Markus
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (9,110); # Avengers: Infinity War was written by Stephen McFeely
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (10,36); # The Lord of the Rings: The Return of the King was written by Fran Walsh
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (10,52); # The Lord of the Rings: The Return of the King was written by J.R.R. Tolkien
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (11,44); # Amélie was written by Guillaume Laurant
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (11,55); # Amélie was written by Jean-Pierre Jeunet
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (12,64); # The Matrix was written by Lana Wachowski
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (12,70); # The Matrix was written by Lilly Wachowski
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (13,12); # 2001: A Space Odyssey was written by Arthur C. Clarke
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (13,108); # 2001: A Space Odyssey was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (14,36); # The Lord of the Rings: The Two Towers was written by Fran Walsh
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (14,52); # The Lord of the Rings: The Two Towers was written by J.R.R. Tolkien
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (15,66); # Star Wars: Episode V - The Empire Strikes Back was written by Lawrence Kasdan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (15,68); # Star Wars: Episode V - The Empire Strikes Back was written by Leigh Brackett
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (16,38); # Apocalypse Now was written by Francis Ford Coppola
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (16,59); # Apocalypse Now was written by John Milius
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (17,34); # North by Northwest was written by Ernest Lehman
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (18,108); # The Shining was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (18,109); # The Shining was written by Stephen King
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (19,1); # 3 Idiots was written by Abhijat Joshi
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (19,92); # 3 Idiots was written by Rajkumar Hirani
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (20,23); # Avengers: Endgame was written by Christopher Markus
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (20,110); # Avengers: Endgame was written by Stephen McFeely
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (21,46); # Once Upon a Time in America was written by Harry Grey
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (21,69); # Once Upon a Time in America was written by Leonardo Benvenuti
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (21,105); # Once Upon a Time in America was written by Sergio Leone
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (22,25); # The Dark Knight was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (22,60); # The Dark Knight was written by Jonathan Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (23,82); # Untouchable was written by Olivier Nakache
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (23,89); # Untouchable was written by Philippe Pozzo di Borgo
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (24,63); # Casablanca was written by Julius J. Epstein
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (24,88); # Casablanca was written by Philip G. Epstein
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (25,7); # Vertigo was written by Alec Coppel
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (25,102); # Vertigo was written by Samuel A. Taylor
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (26,25); # Interstellar was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (26,60); # Interstellar was written by Jonathan Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (27,106); # Harakiri was written by Shinobu Hashimoto
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (27,126); # Harakiri was written by Yasuhiko Takiguchi
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (28,42); # Star Wars: Episode IV - A New Hope was written by George Lucas
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (29,13); # Good Will Hunting was written by Ben Affleck
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (29,76); # Good Will Hunting was written by Matt Damon
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (30,90); # Dangal was written by Piyush Gupta
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (30,107); # Dangal was written by Shreyas Jain
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (31,11); # A Clockwork Orange was written by Anthony Burgess
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (31,108); # A Clockwork Orange was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (32,22); # Eternal Sunshine of the Spotless Mind was written by Charlie Kaufman
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (32,78); # Eternal Sunshine of the Spotless Mind was written by Michel Gondry
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (33,54); # Coco was written by Jason Katz
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (33,67); # Coco was written by Lee Unkrich
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (34,8); # Like Stars on Earth was written by Amole Gupte
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (35,94); # 12 Angry Men was written by Reginald Rose
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (36,5); # The Departed was written by Alan Mak
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (36,76); # The Departed was written by Matt Damon
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (36,121); # The Departed was written by William Monahan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (37,25); # Inception was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (38,117); # The Hunt was written by Thomas Vinterberg
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (38,118); # The Hunt was written by Tobias Lindholm
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (39,49); # Requiem for a Dream was written by Hubert Selby Jr.
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (40,10); # WALL·E was written by Andrew Stanton
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (40,85); # WALL·E was written by Pete Docter
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (41,6); # It\'s a Wonderful Life was written by Albert Hackett
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (41,37); # It\'s a Wonderful Life was written by Frances Goodrich
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (42,29); # Alien was written by Dan O\'Bannon
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (43,32); # American History X was written by David McKenna
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (44,57); # Toy Story was written by John Lasseter
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (44,85); # Toy Story was written by Pete Docter
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (45,106); # Seven Samurai was written by Shinobu Hashimoto
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (46,21); # Modern Times was written by Charles Chaplin
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (47,39); # The Green Mile was written by Frank Darabont
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (47,109); # The Green Mile was written by Stephen King
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (48,111); # Schindler\'s List was written by Steven Zaillian
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (48,116); # Schindler\'s List was written by Thomas Keneally
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (49,27); # Rear Window was written by Cornell Woolrich
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (49,58); # Rear Window was written by John Michael Hayes
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (50,77); # Full Metal Jacket was written by Michael Herr
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (50,108); # Full Metal Jacket was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (51,21); # City Lights was written by Charles Chaplin
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (52,21); # The Great Dictator was written by Charles Chaplin
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (53,40); # M was written by Fritz Lang
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (53,114); # M was written by Thea von Harbou
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (54,3); # Grave of the Fireflies was written by Akiyuki Nosaka
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (54,51); # Grave of the Fireflies was written by Isao Takahata
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (55,112); # The Silence of the Lambs was written by Ted Tally
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (55,115); # The Silence of the Lambs was written by Thomas Harris
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (56,30); # Gladiator was written by David Franzoni
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (57,16); # Back to the Future was written by Bob Gale
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (57,97); # Back to the Future was written by Robert Zemeckis
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (58,93); # Braveheart was written by Randall Wallace
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (59,72); # Leon was written by Luc Besson
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (60,91); # Inglourious Basterds was written by Quentin Tarantino
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (61,39); # The Shawshank Redemption was written by Frank Darabont
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (61,109); # The Shawshank Redemption was written by Stephen King
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (62,41); # Oldboy was written by Garon Tsuchiya
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (62,81); # Oldboy was written by Nobuaki Minegishi
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (63,18); # City of God was written by Bráulio Mantovani
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (63,84); # City of God was written by Paulo Lins
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (64,33); # Forrest Gump was written by Eric Roth
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (64,97); # Forrest Gump was written by Robert Zemeckis
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (64,123); # Forrest Gump was written by Winston Groom
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (65,91); # Reservoir Dogs was written by Quentin Tarantino
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (66,36); # The Lord of the Rings: The Fellowship of the Ring was written by Fran Walsh
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (66,52); # The Lord of the Rings: The Fellowship of the Ring was written by J.R.R. Tolkien
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (67,103); # Joker was written by Scott Silver
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (67,119); # Joker was written by Todd Phillips
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (68,25); # Memento was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (68,60); # Memento was written by Jonathan Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (69,25); # The Prestige was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (69,60); # The Prestige was written by Jonathan Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (70,74); # Your Name. was written by Makoto Shinkai
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (71,4); # American Beauty was written by Alan Ball
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (72,35); # The Lives of Others was written by Florian Henckel von Donnersmarck
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (73,76); # Saving Private Ryan was written by Matt Damon
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (73,96); # Saving Private Ryan was written by Robert Rodat
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (74,42); # Raiders of the Lost Ark was written by George Lucas
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (74,66); # Raiders of the Lost Ark was written by Lawrence Kasdan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (75,104); # Once Upon a Time in the West was written by Sergio Donati
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (75,105); # Once Upon a Time in the West was written by Sergio Leone
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (76,38); # The Godfather was written by Francis Ford Coppola
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (76,75); # The Godfather was written by Mario Puzo
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (77,53); # Terminator 2: Judgment Day was written by James Cameron
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (77,122); # Terminator 2: Judgment Day was written by William Wisher
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (78,50); # The Lion King was written by Irene Mecchi
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (78,61); # The Lion King was written by Jonathan Roberts
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (79,42); # Star Wars: Episode VI - Return of the Jedi was written by George Lucas
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (79,66); # Star Wars: Episode VI - Return of the Jedi was written by Lawrence Kasdan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (80,9); # Seven was written by Andrew Kevin Walker
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (81,14); # Sunset Blvd. was written by Billy Wilder
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (81,20); # Sunset Blvd. was written by Charles Brackett
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (82,47); # Spirited Away was written by Hayao Miyazaki
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (83,91); # Pulp Fiction was written by Quentin Tarantino
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (83,100); # Pulp Fiction was written by Roger Avary
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (84,45); # Snatch was written by Guy Ritchie
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (85,26); # Fight Club was written by Chuck Palahniuk
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (85,56); # Fight Club was written by Jim Uhls
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (86,62); # Psycho was written by Joseph Stefano
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (86,95); # Psycho was written by Robert Bloch
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (87,48); # Citizen Kane was written by Herman J. Mankiewicz
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (87,83); # Citizen Kane was written by Orson Welles
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (88,71); # Das Boot was written by Lothar G. Buchheim
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (88,125); # Das Boot was written by Wolfgang Petersen
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (89,19); # Paths of Glory was written by Calder Willingham
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (89,108); # Paths of Glory was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (90,87); # Spider-Man: Into the Spider-Verse was written by Phil Lord
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (90,99); # Spider-Man: Into the Spider-Verse was written by Rodney Rothman
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (91,86); # Amadeus was written by Peter Shaffer
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (92,91); # Django Unchained was written by Quentin Tarantino
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (93,73); # The Good, the Bad and the Ugly was written by Luciano Vincenzoni
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (93,105); # The Good, the Bad and the Ugly was written by Sergio Leone
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (94,80); # Goodfellas was written by Nicholas Pileggi
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (95,28); # Whiplash was written by Damien Chazelle
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (96,38); # The Godfather: Part II was written by Francis Ford Coppola
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (96,75); # The Godfather: Part II was written by Mario Puzo
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (97,17); # Parasite was written by Bong Joon Ho
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (98,108); # Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb was written by Stanley Kubrick
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (98,113); # Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb was written by Terry Southern
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (99,43); # Cinema Paradiso was written by Giuseppe Tornatore
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (100,25); # The Dark Knight Rises was written by Christopher Nolan
INSERT INTO MovieWriters (MovieID,WriterID) VALUES (100,60); # The Dark Knight Rises was written by Jonathan Nolan

SELECT * FROM MovieWriters ORDER BY MovieID ASC;

#################################################################################### INSERT MovieCast

INSERT INTO MovieCast (MovieID,CastID) VALUES (1,30); # Carrie Henn is in Aliens
INSERT INTO MovieCast (MovieID,CastID) VALUES (1,167); # Michael Biehn is in Aliens
INSERT INTO MovieCast (MovieID,CastID) VALUES (1,211); # Sigourney Weaver is in Aliens
INSERT INTO MovieCast (MovieID,CastID) VALUES (2,97); # Jack Nicholson is in One Flew Over the Cuckoo\'s Nest
INSERT INTO MovieCast (MovieID,CastID) VALUES (2,146); # Louise Fletcher is in One Flew Over the Cuckoo\'s Nest
INSERT INTO MovieCast (MovieID,CastID) VALUES (2,241); # Will Sampson is in One Flew Over the Cuckoo\'s Nest
INSERT INTO MovieCast (MovieID,CastID) VALUES (3,34); # Charles Chaplin is in The Kid
INSERT INTO MovieCast (MovieID,CastID) VALUES (3,53); # Edna Purviance is in The Kid
INSERT INTO MovieCast (MovieID,CastID) VALUES (3,99); # Jackie Coogan is in The Kid
INSERT INTO MovieCast (MovieID,CastID) VALUES (4,79); # Giorgio Cantarini is in Life Is Beautiful
INSERT INTO MovieCast (MovieID,CastID) VALUES (4,178); # Nicoletta Braschi is in Life Is Beautiful
INSERT INTO MovieCast (MovieID,CastID) VALUES (4,197); # Roberto Benigni is in Life Is Beautiful
INSERT INTO MovieCast (MovieID,CastID) VALUES (5,245); # Yuriko Ishida is in Princess Mononoke
INSERT INTO MovieCast (MovieID,CastID) VALUES (5,246); # Yôji Matsuda is in Princess Mononoke
INSERT INTO MovieCast (MovieID,CastID) VALUES (5,247); # Yûko Tanaka is in Princess Mononoke
INSERT INTO MovieCast (MovieID,CastID) VALUES (6,35); # Charles Laughton is in Witness for the Prosecution
INSERT INTO MovieCast (MovieID,CastID) VALUES (6,152); # Marlene Dietrich is in Witness for the Prosecution
INSERT INTO MovieCast (MovieID,CastID) VALUES (6,233); # Tyrone Power is in Witness for the Prosecution
INSERT INTO MovieCast (MovieID,CastID) VALUES (7,36); # Chazz Palminteri is in The Usual Suspects
INSERT INTO MovieCast (MovieID,CastID) VALUES (7,73); # Gabriel Byrne is in The Usual Suspects
INSERT INTO MovieCast (MovieID,CastID) VALUES (7,132); # Kevin Spacey is in The Usual Suspects
INSERT INTO MovieCast (MovieID,CastID) VALUES (8,4); # Adrien Brody is in The Pianist
INSERT INTO MovieCast (MovieID,CastID) VALUES (8,71); # Frank Finlay is in The Pianist
INSERT INTO MovieCast (MovieID,CastID) VALUES (8,219); # Thomas Kretschmann is in The Pianist
INSERT INTO MovieCast (MovieID,CastID) VALUES (9,38); # Chris Hemsworth is in Avengers: Infinity War
INSERT INTO MovieCast (MovieID,CastID) VALUES (9,151); # Mark Ruffalo is in Avengers: Infinity War
INSERT INTO MovieCast (MovieID,CastID) VALUES (9,195); # Robert Downey Jr. is in Avengers: Infinity War
INSERT INTO MovieCast (MovieID,CastID) VALUES (10,58); # Elijah Wood is in The Lord of the Rings: The Return of the King
INSERT INTO MovieCast (MovieID,CastID) VALUES (10,93); # Ian McKellen is in The Lord of the Rings: The Return of the King
INSERT INTO MovieCast (MovieID,CastID) VALUES (10,237); # Viggo Mortensen is in The Lord of the Rings: The Return of the King
INSERT INTO MovieCast (MovieID,CastID) VALUES (11,18); # Audrey Tautou is in Amélie
INSERT INTO MovieCast (MovieID,CastID) VALUES (11,158); # Mathieu Kassovitz is in Amélie
INSERT INTO MovieCast (MovieID,CastID) VALUES (11,200); # Rufus is in Amélie
INSERT INTO MovieCast (MovieID,CastID) VALUES (12,31); # Carrie-Anne Moss is in The Matrix
INSERT INTO MovieCast (MovieID,CastID) VALUES (12,129); # Keanu Reeves is in The Matrix
INSERT INTO MovieCast (MovieID,CastID) VALUES (12,136); # Laurence Fishburne is in The Matrix
INSERT INTO MovieCast (MovieID,CastID) VALUES (13,75); # Gary Lockwood is in 2001: A Space Odyssey
INSERT INTO MovieCast (MovieID,CastID) VALUES (13,131); # Keir Dullea is in 2001: A Space Odyssey
INSERT INTO MovieCast (MovieID,CastID) VALUES (13,243); # William Sylvester is in 2001: A Space Odyssey
INSERT INTO MovieCast (MovieID,CastID) VALUES (14,58); # Elijah Wood is in The Lord of the Rings: The Two Towers
INSERT INTO MovieCast (MovieID,CastID) VALUES (14,93); # Ian McKellen is in The Lord of the Rings: The Two Towers
INSERT INTO MovieCast (MovieID,CastID) VALUES (14,237); # Viggo Mortensen is in The Lord of the Rings: The Two Towers
INSERT INTO MovieCast (MovieID,CastID) VALUES (15,29); # Carrie Fisher is in Star Wars: Episode V - The Empire Strikes Back
INSERT INTO MovieCast (MovieID,CastID) VALUES (15,84); # Harrison Ford is in Star Wars: Episode V - The Empire Strikes Back
INSERT INTO MovieCast (MovieID,CastID) VALUES (15,150); # Mark Hamill is in Star Wars: Episode V - The Empire Strikes Back
INSERT INTO MovieCast (MovieID,CastID) VALUES (16,153); # Marlon Brando is in Apocalypse Now
INSERT INTO MovieCast (MovieID,CastID) VALUES (16,155); # Martin Sheen is in Apocalypse Now
INSERT INTO MovieCast (MovieID,CastID) VALUES (16,196); # Robert Duvall is in Apocalypse Now
INSERT INTO MovieCast (MovieID,CastID) VALUES (17,32); # Cary Grant is in North by Northwest
INSERT INTO MovieCast (MovieID,CastID) VALUES (17,67); # Eva Marie Saint is in North by Northwest
INSERT INTO MovieCast (MovieID,CastID) VALUES (17,103); # James Mason is in North by Northwest
INSERT INTO MovieCast (MovieID,CastID) VALUES (18,45); # Danny Lloyd is in The Shining
INSERT INTO MovieCast (MovieID,CastID) VALUES (18,97); # Jack Nicholson is in The Shining
INSERT INTO MovieCast (MovieID,CastID) VALUES (18,209); # Shelley Duvall is in The Shining
INSERT INTO MovieCast (MovieID,CastID) VALUES (19,1); # Aamir Khan is in 3 Idiots
INSERT INTO MovieCast (MovieID,CastID) VALUES (19,147); # Madhavan is in 3 Idiots
INSERT INTO MovieCast (MovieID,CastID) VALUES (19,174); # Mona Singh is in 3 Idiots
INSERT INTO MovieCast (MovieID,CastID) VALUES (20,37); # Chris Evans is in Avengers: Endgame
INSERT INTO MovieCast (MovieID,CastID) VALUES (20,151); # Mark Ruffalo is in Avengers: Endgame
INSERT INTO MovieCast (MovieID,CastID) VALUES (20,195); # Robert Downey Jr. is in Avengers: Endgame
INSERT INTO MovieCast (MovieID,CastID) VALUES (21,61); # Elizabeth McGovern is in Once Upon a Time in America
INSERT INTO MovieCast (MovieID,CastID) VALUES (21,105); # James Woods is in Once Upon a Time in America
INSERT INTO MovieCast (MovieID,CastID) VALUES (21,194); # Robert De Niro is in Once Upon a Time in America
INSERT INTO MovieCast (MovieID,CastID) VALUES (22,2); # Aaron Eckhart is in The Dark Knight
INSERT INTO MovieCast (MovieID,CastID) VALUES (22,39); # Christian Bale is in The Dark Knight
INSERT INTO MovieCast (MovieID,CastID) VALUES (22,86); # Heath Ledger is in The Dark Knight
INSERT INTO MovieCast (MovieID,CastID) VALUES (23,10); # Anne Le Ny is in Untouchable
INSERT INTO MovieCast (MovieID,CastID) VALUES (23,72); # François Cluzet is in Untouchable
INSERT INTO MovieCast (MovieID,CastID) VALUES (23,179); # Omar Sy is in Untouchable
INSERT INTO MovieCast (MovieID,CastID) VALUES (24,91); # Humphrey Bogart is in Casablanca
INSERT INTO MovieCast (MovieID,CastID) VALUES (24,95); # Ingrid Bergman is in Casablanca
INSERT INTO MovieCast (MovieID,CastID) VALUES (24,185); # Paul Henreid is in Casablanca
INSERT INTO MovieCast (MovieID,CastID) VALUES (25,20); # Barbara Bel Geddes is in Vertigo
INSERT INTO MovieCast (MovieID,CastID) VALUES (25,104); # James Stewart is in Vertigo
INSERT INTO MovieCast (MovieID,CastID) VALUES (25,133); # Kim Novak is in Vertigo
INSERT INTO MovieCast (MovieID,CastID) VALUES (26,9); # Anne Hathaway is in Interstellar
INSERT INTO MovieCast (MovieID,CastID) VALUES (26,114); # Jessica Chastain is in Interstellar
INSERT INTO MovieCast (MovieID,CastID) VALUES (26,161); # Matthew McConaughey is in Interstellar
INSERT INTO MovieCast (MovieID,CastID) VALUES (27,6); # Akira Ishihama is in Harakiri
INSERT INTO MovieCast (MovieID,CastID) VALUES (27,210); # Shima Iwashita is in Harakiri
INSERT INTO MovieCast (MovieID,CastID) VALUES (27,217); # Tatsuya Nakadai is in Harakiri
INSERT INTO MovieCast (MovieID,CastID) VALUES (28,29); # Carrie Fisher is in Star Wars: Episode IV - A New Hope
INSERT INTO MovieCast (MovieID,CastID) VALUES (28,84); # Harrison Ford is in Star Wars: Episode IV - A New Hope
INSERT INTO MovieCast (MovieID,CastID) VALUES (28,150); # Mark Hamill is in Star Wars: Episode IV - A New Hope
INSERT INTO MovieCast (MovieID,CastID) VALUES (29,21); # Ben Affleck is in Good Will Hunting
INSERT INTO MovieCast (MovieID,CastID) VALUES (29,159); # Matt Damon is in Good Will Hunting
INSERT INTO MovieCast (MovieID,CastID) VALUES (29,198); # Robin Williams is in Good Will Hunting
INSERT INTO MovieCast (MovieID,CastID) VALUES (30,1); # Aamir Khan is in Dangal
INSERT INTO MovieCast (MovieID,CastID) VALUES (30,69); # Fatima Sana Shaikh is in Dangal
INSERT INTO MovieCast (MovieID,CastID) VALUES (30,204); # Sakshi Tanwar is in Dangal
INSERT INTO MovieCast (MovieID,CastID) VALUES (31,149); # Malcolm McDowell is in A Clockwork Orange
INSERT INTO MovieCast (MovieID,CastID) VALUES (31,166); # Michael Bates is in A Clockwork Orange
INSERT INTO MovieCast (MovieID,CastID) VALUES (31,182); # Patrick Magee is in A Clockwork Orange
INSERT INTO MovieCast (MovieID,CastID) VALUES (32,116); # Jim Carrey is in Eternal Sunshine of the Spotless Mind
INSERT INTO MovieCast (MovieID,CastID) VALUES (32,128); # Kate Winslet is in Eternal Sunshine of the Spotless Mind
INSERT INTO MovieCast (MovieID,CastID) VALUES (32,230); # Tom Wilkinson is in Eternal Sunshine of the Spotless Mind
INSERT INTO MovieCast (MovieID,CastID) VALUES (33,13); # Anthony Gonzalez is in Coco
INSERT INTO MovieCast (MovieID,CastID) VALUES (33,25); # Benjamin Bratt is in Coco
INSERT INTO MovieCast (MovieID,CastID) VALUES (33,74); # Gael García Bernal is in Coco
INSERT INTO MovieCast (MovieID,CastID) VALUES (34,1); # Aamir Khan is in Like Stars on Earth
INSERT INTO MovieCast (MovieID,CastID) VALUES (34,46); # Darsheel Safary is in Like Stars on Earth
INSERT INTO MovieCast (MovieID,CastID) VALUES (34,224); # Tisca Chopra is in Like Stars on Earth
INSERT INTO MovieCast (MovieID,CastID) VALUES (35,88); # Henry Fonda is in 12 Angry Men
INSERT INTO MovieCast (MovieID,CastID) VALUES (35,140); # Lee J. Cobb is in 12 Angry Men
INSERT INTO MovieCast (MovieID,CastID) VALUES (35,154); # Martin Balsam is in 12 Angry Men
INSERT INTO MovieCast (MovieID,CastID) VALUES (36,97); # Jack Nicholson is in The Departed
INSERT INTO MovieCast (MovieID,CastID) VALUES (36,142); # Leonardo DiCaprio is in The Departed
INSERT INTO MovieCast (MovieID,CastID) VALUES (36,159); # Matt Damon is in The Departed
INSERT INTO MovieCast (MovieID,CastID) VALUES (37,63); # Ellen Page is in Inception
INSERT INTO MovieCast (MovieID,CastID) VALUES (37,124); # Joseph Gordon-Levitt is in Inception
INSERT INTO MovieCast (MovieID,CastID) VALUES (37,142); # Leonardo DiCaprio is in Inception
INSERT INTO MovieCast (MovieID,CastID) VALUES (38,12); # Annika Wedderkopp is in The Hunt
INSERT INTO MovieCast (MovieID,CastID) VALUES (38,148); # Mads Mikkelsen is in The Hunt
INSERT INTO MovieCast (MovieID,CastID) VALUES (38,218); # Thomas Bo Larsen is in The Hunt
INSERT INTO MovieCast (MovieID,CastID) VALUES (39,62); # Ellen Burstyn is in Requiem for a Dream
INSERT INTO MovieCast (MovieID,CastID) VALUES (39,108); # Jared Leto is in Requiem for a Dream
INSERT INTO MovieCast (MovieID,CastID) VALUES (39,112); # Jennifer Connelly is in Requiem for a Dream
INSERT INTO MovieCast (MovieID,CastID) VALUES (40,22); # Ben Burtt is in WALL·E
INSERT INTO MovieCast (MovieID,CastID) VALUES (40,59); # Elissa Knight is in WALL·E
INSERT INTO MovieCast (MovieID,CastID) VALUES (40,111); # Jeff Garlin is in WALL·E
INSERT INTO MovieCast (MovieID,CastID) VALUES (41,51); # Donna Reed is in It\'s a Wonderful Life
INSERT INTO MovieCast (MovieID,CastID) VALUES (41,104); # James Stewart is in It\'s a Wonderful Life
INSERT INTO MovieCast (MovieID,CastID) VALUES (41,145); # Lionel Barrymore is in It\'s a Wonderful Life
INSERT INTO MovieCast (MovieID,CastID) VALUES (42,121); # John Hurt is in Alien
INSERT INTO MovieCast (MovieID,CastID) VALUES (42,211); # Sigourney Weaver is in Alien
INSERT INTO MovieCast (MovieID,CastID) VALUES (42,229); # Tom Skerritt is in Alien
INSERT INTO MovieCast (MovieID,CastID) VALUES (43,26); # Beverly D\'Angelo is in American History X
INSERT INTO MovieCast (MovieID,CastID) VALUES (43,54); # Edward Furlong is in American History X
INSERT INTO MovieCast (MovieID,CastID) VALUES (43,55); # Edward Norton is in American History X
INSERT INTO MovieCast (MovieID,CastID) VALUES (44,50); # Don Rickles is in Toy Story
INSERT INTO MovieCast (MovieID,CastID) VALUES (44,221); # Tim Allen is in Toy Story
INSERT INTO MovieCast (MovieID,CastID) VALUES (44,225); # Tom Hanks is in Toy Story
INSERT INTO MovieCast (MovieID,CastID) VALUES (45,130); # Keiko Tsushima is in Seven Samurai
INSERT INTO MovieCast (MovieID,CastID) VALUES (45,216); # Takashi Shimura is in Seven Samurai
INSERT INTO MovieCast (MovieID,CastID) VALUES (45,231); # Toshirô Mifune is in Seven Samurai
INSERT INTO MovieCast (MovieID,CastID) VALUES (46,34); # Charles Chaplin is in Modern Times
INSERT INTO MovieCast (MovieID,CastID) VALUES (46,87); # Henry Bergman is in Modern Times
INSERT INTO MovieCast (MovieID,CastID) VALUES (46,186); # Paulette Goddard is in Modern Times
INSERT INTO MovieCast (MovieID,CastID) VALUES (47,48); # David Morse is in The Green Mile
INSERT INTO MovieCast (MovieID,CastID) VALUES (47,168); # Michael Clarke Duncan is in The Green Mile
INSERT INTO MovieCast (MovieID,CastID) VALUES (47,225); # Tom Hanks is in The Green Mile
INSERT INTO MovieCast (MovieID,CastID) VALUES (48,23); # Ben Kingsley is in Schindler\'s List
INSERT INTO MovieCast (MovieID,CastID) VALUES (48,143); # Liam Neeson is in Schindler\'s List
INSERT INTO MovieCast (MovieID,CastID) VALUES (48,191); # Ralph Fiennes is in Schindler\'s List
INSERT INTO MovieCast (MovieID,CastID) VALUES (49,81); # Grace Kelly is in Rear Window
INSERT INTO MovieCast (MovieID,CastID) VALUES (49,104); # James Stewart is in Rear Window
INSERT INTO MovieCast (MovieID,CastID) VALUES (49,240); # Wendell Corey is in Rear Window
INSERT INTO MovieCast (MovieID,CastID) VALUES (50,162); # Matthew Modine is in Full Metal Jacket
INSERT INTO MovieCast (MovieID,CastID) VALUES (50,190); # R. Lee Ermey is in Full Metal Jacket
INSERT INTO MovieCast (MovieID,CastID) VALUES (50,238); # Vincent D\'Onofrio is in Full Metal Jacket
INSERT INTO MovieCast (MovieID,CastID) VALUES (51,34); # Charles Chaplin is in City Lights
INSERT INTO MovieCast (MovieID,CastID) VALUES (51,70); # Florence Lee is in City Lights
INSERT INTO MovieCast (MovieID,CastID) VALUES (51,239); # Virginia Cherrill is in City Lights
INSERT INTO MovieCast (MovieID,CastID) VALUES (52,34); # Charles Chaplin is in The Great Dictator
INSERT INTO MovieCast (MovieID,CastID) VALUES (52,98); # Jack Oakie is in The Great Dictator
INSERT INTO MovieCast (MovieID,CastID) VALUES (52,186); # Paulette Goddard is in The Great Dictator
INSERT INTO MovieCast (MovieID,CastID) VALUES (53,64); # Ellen Widmann is in M
INSERT INTO MovieCast (MovieID,CastID) VALUES (53,94); # Inge Landgut is in M
INSERT INTO MovieCast (MovieID,CastID) VALUES (53,187); # Peter Lorre is in M
INSERT INTO MovieCast (MovieID,CastID) VALUES (54,5); # Akemi Yamaguchi is in Grave of the Fireflies
INSERT INTO MovieCast (MovieID,CastID) VALUES (54,19); # Ayano Shiraishi is in Grave of the Fireflies
INSERT INTO MovieCast (MovieID,CastID) VALUES (54,232); # Tsutomu Tatsumi is in Grave of the Fireflies
INSERT INTO MovieCast (MovieID,CastID) VALUES (55,14); # Anthony Hopkins is in The Silence of the Lambs
INSERT INTO MovieCast (MovieID,CastID) VALUES (55,118); # Jodie Foster is in The Silence of the Lambs
INSERT INTO MovieCast (MovieID,CastID) VALUES (55,137); # Lawrence A. Bonney is in The Silence of the Lambs
INSERT INTO MovieCast (MovieID,CastID) VALUES (56,44); # Connie Nielsen is in Gladiator
INSERT INTO MovieCast (MovieID,CastID) VALUES (56,117); # Joaquin Phoenix is in Gladiator
INSERT INTO MovieCast (MovieID,CastID) VALUES (56,201); # Russell Crowe is in Gladiator
INSERT INTO MovieCast (MovieID,CastID) VALUES (57,41); # Christopher Lloyd is in Back to the Future
INSERT INTO MovieCast (MovieID,CastID) VALUES (57,138); # Lea Thompson is in Back to the Future
INSERT INTO MovieCast (MovieID,CastID) VALUES (57,169); # Michael J. Fox is in Back to the Future
INSERT INTO MovieCast (MovieID,CastID) VALUES (58,164); # Mel Gibson is in Braveheart
INSERT INTO MovieCast (MovieID,CastID) VALUES (58,183); # Patrick McGoohan is in Braveheart
INSERT INTO MovieCast (MovieID,CastID) VALUES (58,212); # Sophie Marceau is in Braveheart
INSERT INTO MovieCast (MovieID,CastID) VALUES (59,76); # Gary Oldman is in Leon
INSERT INTO MovieCast (MovieID,CastID) VALUES (59,110); # Jean Reno is in Leon
INSERT INTO MovieCast (MovieID,CastID) VALUES (59,177); # Natalie Portman is in Leon
INSERT INTO MovieCast (MovieID,CastID) VALUES (60,28); # Brad Pitt is in Inglourious Basterds
INSERT INTO MovieCast (MovieID,CastID) VALUES (60,49); # Diane Kruger is in Inglourious Basterds
INSERT INTO MovieCast (MovieID,CastID) VALUES (60,56); # Eli Roth is in Inglourious Basterds
INSERT INTO MovieCast (MovieID,CastID) VALUES (61,27); # Bob Gunton is in The Shawshank Redemption
INSERT INTO MovieCast (MovieID,CastID) VALUES (61,176); # Morgan Freeman is in The Shawshank Redemption
INSERT INTO MovieCast (MovieID,CastID) VALUES (61,222); # Tim Robbins is in The Shawshank Redemption
INSERT INTO MovieCast (MovieID,CastID) VALUES (62,92); # Hye-jeong Kang is in Oldboy
INSERT INTO MovieCast (MovieID,CastID) VALUES (62,115); # Ji-Tae Yoo is in Oldboy
INSERT INTO MovieCast (MovieID,CastID) VALUES (62,172); # Min-sik Choi is in Oldboy
INSERT INTO MovieCast (MovieID,CastID) VALUES (63,8); # Alexandre Rodrigues is in City of God
INSERT INTO MovieCast (MovieID,CastID) VALUES (63,139); # Leandro Firmino is in City of God
INSERT INTO MovieCast (MovieID,CastID) VALUES (63,157); # Matheus Nachtergaele is in City of God
INSERT INTO MovieCast (MovieID,CastID) VALUES (64,77); # Gary Sinise is in Forrest Gump
INSERT INTO MovieCast (MovieID,CastID) VALUES (64,199); # Robin Wright is in Forrest Gump
INSERT INTO MovieCast (MovieID,CastID) VALUES (64,225); # Tom Hanks is in Forrest Gump
INSERT INTO MovieCast (MovieID,CastID) VALUES (65,85); # Harvey Keitel is in Reservoir Dogs
INSERT INTO MovieCast (MovieID,CastID) VALUES (65,170); # Michael Madsen is in Reservoir Dogs
INSERT INTO MovieCast (MovieID,CastID) VALUES (65,223); # Tim Roth is in Reservoir Dogs
INSERT INTO MovieCast (MovieID,CastID) VALUES (66,58); # Elijah Wood is in The Lord of the Rings: The Fellowship of the Ring
INSERT INTO MovieCast (MovieID,CastID) VALUES (66,93); # Ian McKellen is in The Lord of the Rings: The Fellowship of the Ring
INSERT INTO MovieCast (MovieID,CastID) VALUES (66,180); # Orlando Bloom is in The Lord of the Rings: The Fellowship of the Ring
INSERT INTO MovieCast (MovieID,CastID) VALUES (67,117); # Joaquin Phoenix is in Joker
INSERT INTO MovieCast (MovieID,CastID) VALUES (67,194); # Robert De Niro is in Joker
INSERT INTO MovieCast (MovieID,CastID) VALUES (67,248); # Zazie Beetz is in Joker
INSERT INTO MovieCast (MovieID,CastID) VALUES (68,31); # Carrie-Anne Moss is in Memento
INSERT INTO MovieCast (MovieID,CastID) VALUES (68,82); # Guy Pearce is in Memento
INSERT INTO MovieCast (MovieID,CastID) VALUES (68,119); # Joe Pantoliano is in Memento
INSERT INTO MovieCast (MovieID,CastID) VALUES (69,39); # Christian Bale is in The Prestige
INSERT INTO MovieCast (MovieID,CastID) VALUES (69,90); # Hugh Jackman is in The Prestige
INSERT INTO MovieCast (MovieID,CastID) VALUES (69,206); # Scarlett Johansson is in The Prestige
INSERT INTO MovieCast (MovieID,CastID) VALUES (70,175); # Mone Kamishiraishi is in Your Name.
INSERT INTO MovieCast (MovieID,CastID) VALUES (70,202); # Ryô Narita is in Your Name.
INSERT INTO MovieCast (MovieID,CastID) VALUES (70,203); # Ryûnosuke Kamiki is in Your Name.
INSERT INTO MovieCast (MovieID,CastID) VALUES (71,11); # Annette Bening is in American Beauty
INSERT INTO MovieCast (MovieID,CastID) VALUES (71,132); # Kevin Spacey is in American Beauty
INSERT INTO MovieCast (MovieID,CastID) VALUES (71,220); # Thora Birch is in American Beauty
INSERT INTO MovieCast (MovieID,CastID) VALUES (72,156); # Martina Gedeck is in The Lives of Others
INSERT INTO MovieCast (MovieID,CastID) VALUES (72,207); # Sebastian Koch is in The Lives of Others
INSERT INTO MovieCast (MovieID,CastID) VALUES (72,234); # Ulrich Mühe is in The Lives of Others
INSERT INTO MovieCast (MovieID,CastID) VALUES (73,159); # Matt Damon is in Saving Private Ryan
INSERT INTO MovieCast (MovieID,CastID) VALUES (73,225); # Tom Hanks is in Saving Private Ryan
INSERT INTO MovieCast (MovieID,CastID) VALUES (73,228); # Tom Sizemore is in Saving Private Ryan
INSERT INTO MovieCast (MovieID,CastID) VALUES (74,84); # Harrison Ford is in Raiders of the Lost Ark
INSERT INTO MovieCast (MovieID,CastID) VALUES (74,127); # Karen Allen is in Raiders of the Lost Ark
INSERT INTO MovieCast (MovieID,CastID) VALUES (74,184); # Paul Freeman is in Raiders of the Lost Ark
INSERT INTO MovieCast (MovieID,CastID) VALUES (75,33); # Charles Bronson is in Once Upon a Time in the West
INSERT INTO MovieCast (MovieID,CastID) VALUES (75,42); # Claudia Cardinale is in Once Upon a Time in the West
INSERT INTO MovieCast (MovieID,CastID) VALUES (75,88); # Henry Fonda is in Once Upon a Time in the West
INSERT INTO MovieCast (MovieID,CastID) VALUES (76,7); # Al Pacino is in The Godfather
INSERT INTO MovieCast (MovieID,CastID) VALUES (76,101); # James Caan is in The Godfather
INSERT INTO MovieCast (MovieID,CastID) VALUES (76,153); # Marlon Brando is in The Godfather
INSERT INTO MovieCast (MovieID,CastID) VALUES (77,17); # Arnold Schwarzenegger is in Terminator 2: Judgment Day
INSERT INTO MovieCast (MovieID,CastID) VALUES (77,54); # Edward Furlong is in Terminator 2: Judgment Day
INSERT INTO MovieCast (MovieID,CastID) VALUES (77,144); # Linda Hamilton is in Terminator 2: Judgment Day
INSERT INTO MovieCast (MovieID,CastID) VALUES (78,102); # James Earl Jones is in The Lion King
INSERT INTO MovieCast (MovieID,CastID) VALUES (78,113); # Jeremy Irons is in The Lion King
INSERT INTO MovieCast (MovieID,CastID) VALUES (78,160); # Matthew Broderick is in The Lion King
INSERT INTO MovieCast (MovieID,CastID) VALUES (79,29); # Carrie Fisher is in Star Wars: Episode VI - Return of the Jedi
INSERT INTO MovieCast (MovieID,CastID) VALUES (79,84); # Harrison Ford is in Star Wars: Episode VI - Return of the Jedi
INSERT INTO MovieCast (MovieID,CastID) VALUES (79,150); # Mark Hamill is in Star Wars: Episode VI - Return of the Jedi
INSERT INTO MovieCast (MovieID,CastID) VALUES (80,28); # Brad Pitt is in Seven
INSERT INTO MovieCast (MovieID,CastID) VALUES (80,132); # Kevin Spacey is in Seven
INSERT INTO MovieCast (MovieID,CastID) VALUES (80,176); # Morgan Freeman is in Seven
INSERT INTO MovieCast (MovieID,CastID) VALUES (81,66); # Erich von Stroheim is in Sunset Blvd.
INSERT INTO MovieCast (MovieID,CastID) VALUES (81,80); # Gloria Swanson is in Sunset Blvd.
INSERT INTO MovieCast (MovieID,CastID) VALUES (81,242); # William Holden is in Sunset Blvd.
INSERT INTO MovieCast (MovieID,CastID) VALUES (82,47); # Daveigh Chase is in Spirited Away
INSERT INTO MovieCast (MovieID,CastID) VALUES (82,173); # Miyu Irino is in Spirited Away
INSERT INTO MovieCast (MovieID,CastID) VALUES (82,215); # Suzanne Pleshette is in Spirited Away
INSERT INTO MovieCast (MovieID,CastID) VALUES (83,122); # John Travolta is in Pulp Fiction
INSERT INTO MovieCast (MovieID,CastID) VALUES (83,205); # Samuel L. Jackson is in Pulp Fiction
INSERT INTO MovieCast (MovieID,CastID) VALUES (83,235); # Uma Thurman is in Pulp Fiction
INSERT INTO MovieCast (MovieID,CastID) VALUES (84,24); # Benicio Del Toro is in Snatch
INSERT INTO MovieCast (MovieID,CastID) VALUES (84,28); # Brad Pitt is in Snatch
INSERT INTO MovieCast (MovieID,CastID) VALUES (84,109); # Jason Statham is in Snatch
INSERT INTO MovieCast (MovieID,CastID) VALUES (85,28); # Brad Pitt is in Fight Club
INSERT INTO MovieCast (MovieID,CastID) VALUES (85,55); # Edward Norton is in Fight Club
INSERT INTO MovieCast (MovieID,CastID) VALUES (85,163); # Meat Loaf is in Fight Club
INSERT INTO MovieCast (MovieID,CastID) VALUES (86,15); # Anthony Perkins is in Psycho
INSERT INTO MovieCast (MovieID,CastID) VALUES (86,107); # Janet Leigh is in Psycho
INSERT INTO MovieCast (MovieID,CastID) VALUES (86,236); # Vera Miles is in Psycho
INSERT INTO MovieCast (MovieID,CastID) VALUES (87,52); # Dorothy Comingore is in Citizen Kane
INSERT INTO MovieCast (MovieID,CastID) VALUES (87,123); # Joseph Cotten is in Citizen Kane
INSERT INTO MovieCast (MovieID,CastID) VALUES (87,181); # Orson Welles is in Citizen Kane
INSERT INTO MovieCast (MovieID,CastID) VALUES (88,89); # Herbert Grönemeyer is in Das Boot
INSERT INTO MovieCast (MovieID,CastID) VALUES (88,125); # Jürgen Prochnow is in Das Boot
INSERT INTO MovieCast (MovieID,CastID) VALUES (88,135); # Klaus Wennemann is in Das Boot
INSERT INTO MovieCast (MovieID,CastID) VALUES (89,3); # Adolphe Menjou is in Paths of Glory
INSERT INTO MovieCast (MovieID,CastID) VALUES (89,134); # Kirk Douglas is in Paths of Glory
INSERT INTO MovieCast (MovieID,CastID) VALUES (89,192); # Ralph Meeker is in Paths of Glory
INSERT INTO MovieCast (MovieID,CastID) VALUES (90,83); # Hailee Steinfeld is in Spider-Man: Into the Spider-Verse
INSERT INTO MovieCast (MovieID,CastID) VALUES (90,100); # Jake Johnson is in Spider-Man: Into the Spider-Verse
INSERT INTO MovieCast (MovieID,CastID) VALUES (90,208); # Shameik Moore is in Spider-Man: Into the Spider-Verse
INSERT INTO MovieCast (MovieID,CastID) VALUES (91,60); # Elizabeth Berridge is in Amadeus
INSERT INTO MovieCast (MovieID,CastID) VALUES (91,68); # F. Murray Abraham is in Amadeus
INSERT INTO MovieCast (MovieID,CastID) VALUES (91,227); # Tom Hulce is in Amadeus
INSERT INTO MovieCast (MovieID,CastID) VALUES (92,40); # Christoph Waltz is in Django Unchained
INSERT INTO MovieCast (MovieID,CastID) VALUES (92,106); # Jamie Foxx is in Django Unchained
INSERT INTO MovieCast (MovieID,CastID) VALUES (92,142); # Leonardo DiCaprio is in Django Unchained
INSERT INTO MovieCast (MovieID,CastID) VALUES (93,43); # Clint Eastwood is in The Good, the Bad and the Ugly
INSERT INTO MovieCast (MovieID,CastID) VALUES (93,57); # Eli Wallach is in The Good, the Bad and the Ugly
INSERT INTO MovieCast (MovieID,CastID) VALUES (93,141); # Lee Van Cleef is in The Good, the Bad and the Ugly
INSERT INTO MovieCast (MovieID,CastID) VALUES (94,120); # Joe Pesci is in Goodfellas
INSERT INTO MovieCast (MovieID,CastID) VALUES (94,193); # Ray Liotta is in Goodfellas
INSERT INTO MovieCast (MovieID,CastID) VALUES (94,194); # Robert De Niro is in Goodfellas
INSERT INTO MovieCast (MovieID,CastID) VALUES (95,96); # J.K. Simmons is in Whiplash
INSERT INTO MovieCast (MovieID,CastID) VALUES (95,165); # Melissa Benoist is in Whiplash
INSERT INTO MovieCast (MovieID,CastID) VALUES (95,171); # Miles Teller is in Whiplash
INSERT INTO MovieCast (MovieID,CastID) VALUES (96,7); # Al Pacino is in The Godfather: Part II
INSERT INTO MovieCast (MovieID,CastID) VALUES (96,194); # Robert De Niro is in The Godfather: Part II
INSERT INTO MovieCast (MovieID,CastID) VALUES (96,196); # Robert Duvall is in The Godfather: Part II
INSERT INTO MovieCast (MovieID,CastID) VALUES (97,126); # Kang-ho Song is in Parasite
INSERT INTO MovieCast (MovieID,CastID) VALUES (97,214); # Sun-kyun Lee is in Parasite
INSERT INTO MovieCast (MovieID,CastID) VALUES (97,244); # Yeo-jeong Jo is in Parasite
INSERT INTO MovieCast (MovieID,CastID) VALUES (98,78); # George C. Scott is in Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb
INSERT INTO MovieCast (MovieID,CastID) VALUES (98,188); # Peter Sellers is in Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb
INSERT INTO MovieCast (MovieID,CastID) VALUES (98,213); # Sterling Hayden is in Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb
INSERT INTO MovieCast (MovieID,CastID) VALUES (99,16); # Antonella Attili is in Cinema Paradiso
INSERT INTO MovieCast (MovieID,CastID) VALUES (99,65); # Enzo Cannavale is in Cinema Paradiso
INSERT INTO MovieCast (MovieID,CastID) VALUES (99,189); # Philippe Noiret is in Cinema Paradiso
INSERT INTO MovieCast (MovieID,CastID) VALUES (100,9); # Anne Hathaway is in The Dark Knight Rises
INSERT INTO MovieCast (MovieID,CastID) VALUES (100,39); # Christian Bale is in The Dark Knight Rises
INSERT INTO MovieCast (MovieID,CastID) VALUES (100,226); # Tom Hardy is in The Dark Knight Rises


select * from MovieCast order by MovieID asc;

#################################################################################### insert Medias

insert into Medias (Media) values ('DVD');
insert into Medias (Media) values ('BLU-RAY');

select * from Medias;

#################################################################################### insert Rentals

insert into Rentals (CustomerID, MediaID, RentedOn, Returned, Held)
values (3, 1, '2020-3-15', false, true); #1

insert into Rentals (CustomerID, MediaID, RentedOn, Returned, Held)
values (4, 1, '2020-3-15', false, true); #1

insert into Rentals (CustomerID, MediaID, RentedOn, Returned, Held)
values (2, 1, '2020-3-15', false, true); #1

insert into Rentals (CustomerID, MediaID, RentedOn, Returned, Held)
values (1, 1, '2020-3-15', false, true); #1

insert into Rentals (CustomerID, MediaID, RentedOn, ReturnedOn, Returned, TotalDays, TotalCost)
values (5, 2, '2020-3-15', '2020-3-20', true, 5, 15.0); #2

select * from Rentals;
SELECT * FROM Rentals ORDER BY ID DESC LIMIT 1;
UPDATE Rentals SET Returned = true WHERE ID = 9;

#################################################################################### insert MovieRental

insert into MovieRental (MovieID, RentalID) values (1, 1);
insert into MovieRental (MovieID, RentalID) values (3, 2);
insert into MovieRental (MovieID, RentalID) values (3, 3);
insert into MovieRental (MovieID, RentalID) values (4, 4);
insert into MovieRental (MovieID, RentalID) values (6, 5);

select * from MovieRental order by MovieID asc;
