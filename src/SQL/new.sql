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
insert into Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) values ('dustindiaz', 'dustin123', 'Dustin', 'A.', 'Díaz', '1998-02-06', '4 Calle Aleli Urb. Round Hill', 'Trujillo Alto', '00976', '7874782095', 2);
insert into Customers (Username, AccountPassword, FirstName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) values ('root', 'toor', 'Admin', 'Privelages', '1860-02-06', 'RA 0h 42m 44s | Dec +4° 6\' 9\"', 'Andromeda Galaxy', 'M3', 'Radio Waves', 2);
INSERT INTO Customers (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES ('dustin123', 'asd', 'Pedro', 'A.', 'Díaza', '1996-2-06', 'El Campo', 'Rio Campo', '0076', '237067890', 1);
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
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Pamela","Logan","Ramos","Octavia Velasquez","vitae","1998-04-29","Ap #995-2249 Auctor, St.","Oranienburg","32057","898-631-6364","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zephania","Uta","Castro","Yuli Shepherd","habitant","2003-02-23","Ap #460-1398 Odio St.","Colobraro","25991","738-719-6487","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ian","Elizabeth","Whitaker","Matthew Todd","pharetra,","2000-10-04","492-3812 Dictum. Road","Sigillo","J5P 4T5","293-863-3240","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Quinn","Samson","Munoz","Rae Long","Phasellus","1998-03-01","P.O. Box 428, 339 Duis Rd.","Thuin","914005","889-991-2600","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hall","Keaton","Stout","Miriam Dorsey","et,","2000-08-22","Ap #269-5985 Elit, Avenue","Surbo","IF7 3BI","348-641-0863","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Macon","Brandon","Powers","Virginia Cross","tristique","1995-07-16","221 Dolor Road","Stintino","59899","525-672-4662","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Griffith","Basil","Higgins","Macy Mcclain","faucibus","1992-09-18","6251 Iaculis Rd.","Napier","01-555","697-770-7077","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sonia","Erica","Contreras","Cedric Haynes","massa","1995-01-30","5461 Lacus. St.","Westkerke","43464","674-458-3304","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Charlotte","Phoebe","Zimmerman","Hamish Meyer","ridiculus","2002-09-07","Ap #712-3584 Non, Rd.","Mont-de-Marsan","52566-73976","615-554-8030","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Katelyn","Priscilla","Petersen","Malachi Cline","molestie","1996-03-27","9681 Lectus St.","Blind River","757461","753-327-7954","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gemma","Roary","Rosales","Karyn Watts","ridiculus","2002-12-17","424-7399 Tincidunt Ave","Rochester","989038","935-380-2845","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lunea","Raya","Hebert","Isadora Mccray","arcu","1997-02-15","506-8654 Cras Rd.","Salihli","5735","883-681-4400","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zephania","Dolan","Hull","Nola Hyde","aliquet.","1992-07-29","835-1660 Parturient Road","Coinco","U59 0IS","203-807-5635","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Althea","Walter","Ramirez","Hoyt Horne","purus.","1993-08-31","Ap #814-4062 Sed Ave","Nottingham","599244","675-809-0828","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Abbot","Kato","Sutton","Naida Anthony","pellentesque","2000-09-08","422-9714 Vivamus St.","Wageningen","V1W 4S0","569-585-1155","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kelly","Ryan","Christian","Todd Rodgers","sagittis","1993-10-13","P.O. Box 154, 4515 Orci. Ave","Nashville","07912","295-118-8610","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kieran","Cassady","Bender","Harriet Fisher","eget","2002-08-28","151-172 Et Av.","Zaltbommel","Z8222","547-774-8759","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Veronica","Alisa","Daniel","Maia Nielsen","eu,","1994-01-05","3735 Vulputate Av.","Rawalpindi","20797","415-611-1258","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kato","Jeremy","Matthews","Grady Guzman","porttitor","2003-05-08","834-4921 Diam St.","Sossano","26038","639-608-2303","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Blake","Dominique","Evans","Garrison Booker","mi","1996-05-19","P.O. Box 470, 9601 Luctus. Ave","Rostov","NO0S 0ZH","566-727-6205","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Leandra","Sonia","Bean","Axel Burton","dictum","1992-06-18","P.O. Box 100, 6421 Eleifend Av.","Mocoa","00123","868-944-1836","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Cameron","Kasimir","Cash","Ayanna Henry","augue","2000-01-09","P.O. Box 387, 588 Molestie Street","Asso","K0C 9RQ","168-831-7709","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jared","Emily","Mcdonald","Chancellor Daniel","sagittis","2001-11-08","5968 Metus. Road","Cervino","58080","284-375-9873","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tallulah","Gannon","Long","Wylie Flynn","rhoncus.","1996-11-27","Ap #993-6803 Nunc. Av.","Sakhalin","39355-63723","453-418-3703","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Portia","Raja","Greer","Echo Dickerson","ipsum","1992-09-11","Ap #987-8644 Leo Rd.","Fürstenwalde","6799 IN","717-425-2558","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Shaine","Zorita","Galloway","Porter Wade","luctus","1998-03-03","Ap #679-1403 Magnis Road","Brussel X-Luchthaven Remailing","05724-693","624-573-1712","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ashton","Hashim","Justice","Jack Shannon","semper","2004-04-01","9837 Sed Road","Bellefontaine","49818-984","825-662-7049","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sacha","Pandora","Wilkerson","Eve Silva","a","1991-08-24","Ap #178-9912 Porttitor Road","Kemerovo","830937","728-193-3829","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Harding","Dara","Yates","Allen Fischer","sit","1993-01-13","Ap #394-3794 Justo. St.","North Waziristan","92070","656-464-1284","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Azalia","Jenette","Aguirre","Katell Daugherty","neque","1998-09-06","Ap #591-564 Egestas St.","Aisén","8757","446-831-0858","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Aiko","Isaiah","Anthony","Aaron Quinn","aliquam","2002-11-28","6943 Fermentum St.","Dudzele","936204","430-109-7715","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sarah","Ila","Montgomery","Mercedes Frederick","Integer","2002-08-07","187-2816 Sed Av.","Flint","93264","675-740-0525","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Herrod","Meghan","English","Jerome Fernandez","Sed","1992-04-19","774-3808 Ac Avenue","Staßfurt","08444","625-537-7846","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jordan","grant","Newton","Cruz Sanders","at","2001-11-21","Ap #235-4833 At Avenue","Noicattaro","51004","365-940-5444","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zahir","Stewart","Diaz","Hedwig Weeks","convallis","2000-01-10","9254 Quisque Av.","Rutigliano","80771","310-571-3946","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sydnee","Eve","Hess","Ulric Wheeler","felis,","1992-03-17","363-9695 Sit St.","Banjarbaru","725616","235-637-4622","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Emery","Todd","Roberts","Remedios Hendrix","egestas","1990-04-23","P.O. Box 585, 1636 Cursus Road","Saarlouis","612066","859-597-5731","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Walter","Zoe","Benson","Nathan Ashley","mauris.","2001-10-26","P.O. Box 225, 8514 Nunc Rd.","Girardot","58336","958-603-3265","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Oren","Hammett","Mcleod","Orlando Henderson","Curabitur","2000-12-28","P.O. Box 635, 1784 Aliquet Street","Casnate con Bernate","09810","638-599-8106","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zia","Carlos","Fry","Uma Head","Etiam","1992-07-26","233-8536 Enim, St.","Wenduine","52648","311-514-1623","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kelly","Candace","Fowler","Lillian Norris","ac,","1995-05-05","1070 Velit Street","Villers-aux-Tours","8807","589-206-6025","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Buffy","Adria","Terry","Tarik Bright","Sed","1992-08-12","234-2718 Pretium Avenue","Kolkata","07495","458-720-2191","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Holmes","Jesse","Kramer","Dominic Riggs","eu,","2002-06-18","9019 Curabitur Road","Keumiee","72824","700-697-3906","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Nissim","Iola","Harding","Kylynn Byers","a","1995-12-23","4579 Sed Av.","Yegoryevsk","074751","381-429-9685","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Imogene","Guy","Pace","Zoe Blair","eu","2002-07-06","511-7795 Sapien Street","Lanark County","683822","734-957-2956","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Althea","Damon","Burton","Blythe Bentley","lacus.","2000-06-21","P.O. Box 825, 1717 Vitae St.","Poggiorsini","QY3 9SN","427-988-8858","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gloria","Armando","Shaffer","Xena Beck","ac","1998-03-31","P.O. Box 128, 9967 Aliquam Road","Polatlı","881972","880-380-8960","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("James","Iris","Graham","Yasir Rasmussen","vel,","1997-10-19","Ap #867-8685 Ipsum Rd.","Sooke","419670","562-529-3004","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Aaron","Briar","Eaton","Mariko Lang","diam","1994-04-22","5486 Magna. Ave","Colchester","35672-91423","206-793-1073","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alma","Madeline","Hill","Cruz Nash","Vivamus","1989-05-29","4150 Ut, St.","Sint-Genesius-Rode","1624 IC","753-667-0639","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zia","Chanda","Marquez","Seth Mayer","odio.","2003-04-28","Ap #280-1636 Aliquet, St.","Valtournenche","71117","726-563-0431","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Mara","Amela","Neal","Keaton Dennis","velit.","1997-11-21","4267 Nascetur Road","Sloten","945048","312-285-0338","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Colton","Linus","Bell","Martha Dalton","tristique","1992-08-30","P.O. Box 893, 441 Commodo Avenue","Red Deer","1043","262-284-7247","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Neve","Nicole","Garner","Taylor Ross","vel","1989-09-17","5665 Ipsum. St.","Soye","767614","562-151-3704","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Regan","Hashim","Cooper","Noelani Warner","semper","1995-05-05","Ap #966-6648 Odio Ave","Paranaguá","Z3560","702-291-7668","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alan","Dieter","Allen","Caesar Small","aliquet","2004-06-12","2553 Nonummy. Rd.","Jefferson City","271272","425-490-4646","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Brock","Gareth","Alston","Hiram Terrell","Donec","2001-09-13","Ap #222-2118 Egestas. Rd.","Montaldo Bormida","1782","980-663-4254","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Clare","Kamal","Clarke","Sydnee Justice","dictum","1999-11-15","106-8211 Enim. Road","Cimahi","T9E 3H4","801-465-5899","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Amethyst","Christian","Maxwell","Yoshi Green","Donec","2004-07-11","Ap #340-2837 Nibh. St.","Covington","9631","560-760-4221","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Carol","Hanna","Grimes","Carolyn Walls","nunc","2004-05-12","6293 At Ave","Barry","49202","935-982-7878","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Vivien","Griffith","Delgado","Isadora Mueller","Ut","1996-12-31","9304 Non, Street","Buizingen","Z9322","417-747-1826","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Aline","Ciaran","Velez","Hector Mann","ornare","2000-04-30","Ap #271-9430 Aenean St.","Jhelum","3507","808-477-6444","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Colorado","Wing","Sykes","Damian Adkins","non","2003-12-20","P.O. Box 210, 1436 Condimentum. Rd.","Tirunelveli","025782","835-404-3305","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Joan","Nichole","Wells","Colorado Horn","nibh.","1997-07-11","635-988 Congue Avenue","Bevel","945963","147-182-5093","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ori","Robert","Collins","Eric Rodgers","mollis","1993-09-30","617-7653 Consectetuer St.","Angoulême","5452","147-722-4762","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yuli","Eric","Keith","Wanda Thomas","hymenaeos.","2004-11-10","Ap #376-7169 Ac St.","Iowa City","578460","886-330-8721","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rana","Brian","Dalton","Nasim Patel","porttitor","1993-10-16","708-5385 Vulputate St.","Keumiee","147964","747-260-4728","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jonas","Theodore","Henderson","Sebastian Lawson","parturient","1998-06-20","2887 Nulla St.","Orsogna","Z9136","857-210-7788","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Melvin","Blythe","Taylor","Myra Chang","dui.","1990-04-29","Ap #259-3910 Sagittis. Street","Rio Grande","927441","673-100-5313","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Erica","India","Mcleod","Travis Bonner","amet","1999-11-25","6446 Sed Rd.","Beauport","20877","475-559-8726","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hop","Jerome","Quinn","Zelenia Cox","Morbi","2001-01-22","348-8077 Fringilla Ave","Bojano","39-235","177-251-7285","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Clarke","Francis","Beach","Alma Herman","magna","1998-09-29","163-6067 Pellentesque Avenue","Tollembeek","5798","375-428-5240","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Moses","Callie","Wilder","Maia Bird","libero.","1995-06-13","P.O. Box 644, 4257 Mauris Rd.","Norderstedt","90464","154-848-6629","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Noah","Ahmed","Barr","Barry Sykes","Proin","1992-10-20","356-2531 Tempor Rd.","Holyhead","27239","847-378-1207","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Wyoming","Cairo","Blackwell","Wang Hyde","adipiscing","1994-01-19","8356 In Rd.","Grado","465898","492-247-2012","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Abel","Martin","Ware","Mara Mcdonald","erat,","1994-02-18","Ap #482-612 Nam Road","Wisbech","25078","836-603-9636","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Fallon","Kevyn","Mccarthy","Lance Trujillo","magnis","1993-01-16","Ap #657-693 Integer Rd.","Hathras","32100","801-486-0781","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hilary","Sonia","Brewer","Nicole Olsen","dui,","1992-02-18","9601 Tellus. Rd.","Hamilton","30919","786-448-9134","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jael","Amanda","Vang","Tana Vega","non","1993-12-10","Ap #513-7459 Pellentesque St.","Dunstable","75505-326","442-714-6348","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tobias","Trevor","Gardner","Eagan Frost","tincidunt,","2003-03-08","Ap #288-2762 Pellentesque St.","Riosucio","1732 PK","190-797-9042","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kendall","Richard","Byers","Deacon Russell","gravida","1995-12-01","Ap #879-1490 Elit, Avenue","Kota","03455-333","857-320-6464","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tallulah","Steel","Dillard","Deirdre Duke","mollis","1992-03-26","9630 Tellus Street","King's Lynn","SJ3 8BK","128-304-8305","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lara","Marcia","Tran","Kimberley Richardson","elit,","2001-11-28","Ap #699-1943 Orci. Ave","Welshpool","2902","980-113-3396","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yvonne","Petra","Church","Madeline Gibbs","ut","1989-05-18","1761 Ac St.","Rotheux-RimiŽre","29993","628-683-6771","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Joel","Noble","Benjamin","Yael Tillman","luctus","1990-01-15","5485 Libero. St.","Castelmarte","71406","919-344-7051","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sebastian","Petra","Mccarthy","Oscar Noel","cubilia","2000-06-20","P.O. Box 703, 1205 Adipiscing Rd.","Warangal","36207","804-938-4923","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Risa","Clio","Alvarado","Shoshana Ashley","Mauris","2002-02-06","959-6559 Odio Av.","Sunderland","X4Z 7R5","363-212-9937","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Leilani","Damon","Larsen","Hasad Warren","nec","2002-05-07","3189 Nec Street","Ujjain","G9V 5H5","607-328-7560","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lenore","Jordan","Rodriquez","Craig Lara","egestas","1993-08-30","5217 Sit Ave","Heusden-Zolder","499135","156-903-4529","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kathleen","Dahlia","Dale","Edan Mcknight","quis","1996-04-17","P.O. Box 904, 2853 Massa. Street","Neelum Valley","G3M 3H2","988-365-3743","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Knox","Kalia","Franco","Erin Harrison","a,","1994-01-23","4716 Tincidunt Street","Odintsovo","P8A 8JQ","471-597-8201","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Macaulay","Raven","Stanley","Kelly Dickerson","scelerisque","1998-09-17","P.O. Box 205, 9194 Sit Rd.","Bogor","799103","563-299-3152","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Martina","Nash","Moon","Odette Cooke","Quisque","1991-06-16","P.O. Box 350, 6599 Mattis. Road","Cascavel","94883","446-715-9094","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Martin","Maxwell","Lee","Jamal Mayo","dolor.","1989-06-25","Ap #946-7538 Posuere St.","King Township","9829","938-516-7297","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Christine","Christian","Rivera","Gage Arnold","lorem.","1997-07-12","P.O. Box 960, 532 Cum Street","HŽron","28629","618-620-7644","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Boris","Jessamine","Mcclain","Timon Koch","senectus","1991-04-12","Ap #988-1518 Id St.","Fontenoille","50616","182-541-5582","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zane","Ina","Clark","Lars Martinez","cursus","2002-03-05","297-2293 Eget Road","Latinne","68413-55935","290-850-9834","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Demetria","Chanda","Price","Cullen Gonzalez","urna.","1993-10-31","P.O. Box 911, 9261 Accumsan Avenue","Jemappes","78-700","721-867-8581","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Deacon","Bianca","Roy","Tatum Murphy","eget,","1997-06-09","Ap #756-9497 Sit Avenue","Altach","Z9123","548-938-0797","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Xander","Colby","Richmond","Rina Pratt","est,","1989-09-18","9861 Fermentum St.","Broxburn","31999","332-266-4607","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Cheryl","Dominique","Joyce","Sage Sampson","tempus","1993-01-10","874-6471 Dui Avenue","Tours","70607","757-401-8295","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Celeste","Lee","Nash","Ruth Hamilton","Mauris","2004-01-07","P.O. Box 909, 4620 At Ave","Saint-Dié-des-Vosges","06509","406-989-0898","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Mark","Roth","Bean","Nayda Mcneil","risus","2001-08-02","937-414 Quam St.","Boston","19599","929-775-9124","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Paula","Sybil","Mcleod","Erasmus Wise","dictum","2004-02-14","Ap #701-4237 Lacinia Rd.","Sromness","936383","752-900-9439","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Curran","Hyatt","Scott","Tanisha Farley","parturient","1991-06-16","8267 At, Rd.","Serampore","28-379","229-703-3023","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Linda","Minerva","Benton","Abraham Salinas","et","1992-02-10","Ap #319-8021 At St.","Peine","52364","680-169-5076","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Caldwell","Austin","Kirkland","Jonah Irwin","eu","2000-03-04","Ap #107-3627 Nec Avenue","La Baie","94317","651-919-1127","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Chadwick","Deirdre","Beach","Drew Tyler","Cras","1989-10-29","Ap #475-5080 Gravida Av.","Huntsville","A2J 5A7","500-873-5029","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Keegan","Vera","Parsons","Macaulay Witt","molestie","1999-06-29","3343 Fusce Road","Latur","3140","990-763-0892","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kylynn","Xantha","Mayer","Shelley Mays","quis,","2002-01-19","812 Vestibulum Ave","Tofield","57269","824-766-1005","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Len","Nathan","Hoover","Owen Dawson","Donec","1990-03-11","P.O. Box 110, 8435 Vitae Rd.","Nederhasselt","61209","708-191-5801","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Melyssa","Xerxes","Perkins","Macey Russell","accumsan","1995-08-25","5528 Laoreet Road","Gävle","550620","873-174-0969","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ethan","Griffith","Stephenson","Hadley Stevenson","metus.","1998-07-12","Ap #256-9001 Duis Road","Incheon","Z5570","199-453-4687","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Bertha","Jason","Malone","Hadley Petersen","egestas.","2004-08-26","P.O. Box 158, 9871 Vitae Av.","Regina","VU6Q 3ZM","806-789-2971","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Maile","Cedric","Huff","Nichole Snyder","sodales","2001-12-05","Ap #179-6108 Penatibus Ave","Vico del Gargano","31461","235-184-9142","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jermaine","Vladimir","Horn","Maia Chandler","porttitor","1999-05-27","P.O. Box 812, 4045 Malesuada Av.","Mataró","F5N 5ZW","603-688-1412","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Neil","Jin","Tyler","Roth Wilder","accumsan","2004-10-24","Ap #174-6981 Luctus St.","Renfrew","8290","188-743-5516","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Shoshana","Damon","Noel","Alana Barry","nibh","2004-10-14","Ap #408-2167 Fames Road","Ville de Maniwaki","381943","652-868-2067","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Clare","Mari","Duran","Sonya Wyatt","sem,","1996-09-30","Ap #341-5260 Aliquam Ave","Bhiwani","1991","193-907-3646","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Marshall","Alice","Stafford","Odysseus Finley","enim","1994-01-19","2918 Proin Av.","Bazel","89648","926-728-8106","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ryan","Melodie","Bond","Autumn Baldwin","netus","1989-03-18","P.O. Box 221, 5881 Malesuada St.","Red Deer","70105","680-694-9970","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gannon","Uta","King","Desirae Avery","sapien","1991-01-23","347-1915 Elit. Street","Steenhuffel","775090","685-585-2783","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hedy","Calista","Roman","Keane Mcfadden","mus.","1991-05-14","Ap #164-6977 Netus St.","Trois-Rivières","Z3365","477-915-8392","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Seth","Shellie","Patterson","Mason Bowman","pede.","1994-01-09","Ap #432-3924 Bibendum Avenue","Kota","050192","457-810-2434","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ashton","Eaton","Knox","Amy Travis","ultrices.","2000-09-12","P.O. Box 987, 362 Etiam Rd.","Maple Ridge","65-888","340-239-0445","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kato","Aurora","Brady","Urielle Mendoza","convallis","2003-12-17","120-2694 Enim. Rd.","Cumberland","L6Y 7K0","690-586-7259","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Declan","Xenos","Tran","Venus Marks","massa","2003-08-28","P.O. Box 387, 6671 Conubia Ave","Heist-aan-Zee","2912","620-624-8428","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Anastasia","Duncan","Dillard","Sheila Schmidt","per","1999-07-23","Ap #577-3117 Eu Street","Calama","145524","622-349-1590","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Owen","Vernon","Riley","Ferris Durham","ac","1990-06-30","4237 Semper Street","Bunbury","79376","600-765-8933","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Suki","Irene","Sherman","Blake Figueroa","senectus","1994-06-29","575-805 Pharetra. Rd.","Boorsem","GT6D 1DK","294-229-7268","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Farrah","Ira","Mcintyre","Stacy Potter","ridiculus","2002-09-16","P.O. Box 407, 9698 Vehicula. Av.","Bragança","335132","359-783-6544","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Davis","Orson","Potter","Libby Medina","convallis","1999-04-15","P.O. Box 524, 7385 Sodales Ave","Middelkerke","Z2406","592-831-8011","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Cheryl","Griffith","Salas","Michael Heath","lobortis","1998-10-18","Ap #598-3953 Vehicula. Road","Valparaíso","602667","555-378-3880","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Karina","Edward","Benton","Charde Freeman","ac,","1997-11-28","Ap #311-4908 Dictum St.","Bierk Bierghes","Z5623","695-936-6457","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jordan","Eden","Glenn","Samuel Bentley","eu,","1998-04-24","Ap #237-1744 Elementum Rd.","Osimo","60916","815-995-7291","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Preston","Maggy","Roach","Ethan Case","Nam","1998-10-24","P.O. Box 783, 5457 A Rd.","Sheikhupura","A0R 1K3","199-348-8470","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kirestin","Tasha","Snow","Rose Manning","nibh.","1998-03-20","341-5334 Suspendisse Ave","Wilmington","1640","200-638-8628","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Basia","Gannon","Holden","Marvin Branch","sit","1994-03-18","P.O. Box 701, 5945 Velit Rd.","Pero","4622","430-943-4980","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Daphne","Lester","Jensen","Wayne Collins","tincidunt","1999-06-06","Ap #115-5020 Urna. Av.","Villeneuve-d'Ascq","105436","319-187-7652","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Linus","Francesca","Griffin","Sybill Foster","vitae","2000-01-28","Ap #220-1004 Non Road","Lingen","39661","164-741-5997","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Maxwell","Allen","Stevens","Angela Greer","posuere","1993-09-07","Ap #757-5103 A Rd.","Portofino","B2A 7QG","851-905-4876","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Elton","Ciara","Armstrong","Myra Le","sit","1992-12-26","448-3144 Pharetra, Road","Tuluá","577669","540-820-7508","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Breanna","Dale","Chaney","Pascale Ellison","tempor","1998-08-27","1655 Sociis Rd.","Lienz","68680","177-364-3755","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hoyt","Jasper","Gray","Cassidy Hayes","velit","2003-08-30","715-5959 Nibh Road","Dion-Valmont","10-663","230-814-6537","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Warren","Cameron","Mathis","Fuller Holloway","a","1997-06-16","P.O. Box 742, 5025 Sagittis Ave","Crewe","188572","468-520-5034","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kylan","Uriel","Peters","Octavius Mccoy","aliquet","1996-05-16","9410 Sed Avenue","Pencahue","4663 QR","594-175-5212","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Avye","Russell","Tyson","Igor Merrill","nonummy.","1998-06-30","363-6355 Ac Av.","Gaithersburg","2689 HG","744-387-1334","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Urielle","Alden","Houston","Mercedes Rogers","diam","1996-06-11","7397 Nam Ave","Bionaz","83658-23625","529-278-6088","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Larissa","Breanna","Hernandez","Rina Ramirez","luctus","1998-11-26","P.O. Box 850, 3736 Faucibus Rd.","Wolfurt","32293","874-742-1583","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rashad","Clinton","Carlson","Adena Barrett","orci.","2001-10-24","139-4304 Mollis Street","Samarinda","Z8019","362-323-3041","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zelenia","Morgan","Hamilton","Elvis Cervantes","a,","1995-06-01","P.O. Box 430, 6827 Vitae St.","Paisley","64205-412","501-168-1047","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Karly","Wade","Wiley","Deborah Frye","feugiat.","2003-07-31","2629 Orci, Avenue","Bonvicino","IV96 1IA","393-530-2753","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alea","Kieran","Olsen","Macon Duran","ante,","2000-11-09","359-2367 Lacinia. Street","Castiglione di Garfagnana","12521","764-336-7995","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Rinah","Gloria","Church","Yoshio Moon","fringilla","2004-12-02","235-8021 Ligula. St.","Stirling","V7B 2Z4","192-282-2093","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Callie","Ebony","Merritt","Christian Hunter","dui.","1998-01-03","5363 Sagittis St.","Gonda","118805","726-774-3112","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Callum","Dylan","Roberson","Michelle Bray","tempor","1993-07-27","P.O. Box 535, 5666 Mi Av.","Driffield","51633","959-115-1177","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Hermione","Stone","Nicholson","Candice Murray","a","1992-07-01","Ap #252-2751 Amet, Avenue","Foligno","LN7P 5MB","801-408-2514","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Marshall","Clayton","Robles","Demetrius Solomon","et,","1996-01-18","P.O. Box 926, 4165 Sit St.","Cellara","19269","270-919-3947","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kirestin","Armando","Lang","Ila Pate","Cras","1993-05-12","P.O. Box 256, 7553 Felis. Street","Nimy","98604","769-592-0463","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Shad","Janna","Joseph","Nicholas Bennett","purus.","2001-07-08","2135 Curae; Avenue","Casalbuono","711499","784-930-2484","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tanner","Uriah","Santiago","Garth Duran","libero.","2002-10-21","669-6881 Erat Rd.","Habergy","50140","796-486-3047","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Zeus","Elvis","Curry","Cameran Sims","euismod","2001-01-10","847-3713 Accumsan St.","Moose Jaw","33544","459-777-7604","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Leila","Aurelia","Mccormick","Dana Rogers","aliquet,","1994-10-19","849-7980 Vitae, Road","Bellegem","60438","965-626-9441","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Melvin","Keane","Singleton","Latifah Graves","erat","1998-04-29","P.O. Box 839, 2731 Vivamus Road","Barranco Minas","366347","582-260-9465","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kaseem","Alden","Hendricks","Desirae Hopkins","vitae,","2003-12-31","642-167 Nunc St.","WanfercŽe-Baulet","39369","598-677-9973","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Adrienne","Randall","Jimenez","Charlotte Lancaster","pellentesque","2003-06-22","Ap #648-1964 Nunc Road","Dro","72284","904-149-7771","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Blossom","Thomas","Moran","Callum Meadows","sem","1994-12-14","P.O. Box 729, 6104 Adipiscing Road","Dollard-des-Ormeaux","98372","504-536-1621","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Roth","Dalton","Flowers","Cruz Orr","arcu.","1997-07-27","Ap #248-937 Lobortis, Street","Pontarlier","28872-468","983-648-6400","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Grady","Bevis","Guzman","Flavia Gilmore","orci","2001-08-24","P.O. Box 631, 3671 Egestas Street","Presles","30909","108-307-6352","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Tanek","Ruth","Miller","Kitra Edwards","dictum","2003-09-14","P.O. Box 651, 8907 Cum Road","Haut-Ittre","16758","762-301-5313","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Donovan","Rinah","Young","Rhoda Patton","vitae","1991-12-01","Ap #212-6149 Ullamcorper Street","Dufftown","6664","649-294-8178","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Quin","Miriam","Myers","Rigel Lopez","lacus.","2002-01-07","Ap #360-8824 Scelerisque Av.","Dundee","48-964","494-427-4630","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Lysandra","Jelani","Harrison","Dorothy Colon","sit","1999-05-25","Ap #190-5916 Est St.","Barranquilla","53900","182-247-5466","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Garrett","Ainsley","Rivers","Amal Mccarthy","elementum","1994-10-31","810-8750 Faucibus. Rd.","Yegoryevsk","666002","187-149-7654","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Anne","Gray","Owens","Jason Rosa","sed","1991-10-27","172-7698 Sit St.","Nonsan","5051 LF","847-959-6923","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Xenos","Britanni","Hensley","Flavia Moon","convallis","1991-03-24","P.O. Box 763, 9181 Sed Road","East Kilbride","856585","666-365-2841","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Adrian","Marvin","Hess","Aimee Dixon","condimentum","1995-10-27","Ap #199-1797 Ornare. St.","Eckville","7026 MQ","825-405-3536","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ferris","Ella","Mayo","Clinton Page","cursus,","1992-11-30","400-7597 Ut St.","Criciúma","4182 SL","867-485-8292","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Brenden","Dolan","Stuart","Salvador Pate","dolor","1989-12-27","908-296 Diam Rd.","Panchià","272959","119-350-8752","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jesse","Hilel","Wyatt","Camden Joyce","massa","2004-08-18","Ap #612-9049 Risus St.","Motta Sant'Anastasia","0169 XK","944-330-8302","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Orli","Hilel","Patrick","April Johnson","risus","1999-08-31","Ap #937-5380 Semper. Rd.","Sasaram","54103","113-175-3186","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Gretchen","Tobias","Rasmussen","Barclay Walls","ligula.","1990-05-15","Ap #357-1194 Ante Road","Avigliano Umbro","Z4549","940-312-0447","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Solomon","Abigail","Keller","Leonard Alvarado","enim.","2005-02-07","P.O. Box 977, 7427 Duis Rd.","Aix-en-Provence","61272","546-645-3785","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Signe","Eric","Stevenson","Whilemina Boyer","libero.","1996-07-21","755-6903 Dictum Rd.","San Antonio","365083","765-602-8381","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Kaden","Rahim","Sparks","Aileen Payne","rhoncus.","1994-10-31","P.O. Box 191, 2460 Lorem Av.","Vänersborg","48891","288-615-8822","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jolene","Dale","Rowland","Judah Spencer","ultrices","1997-05-02","769-321 Convallis St.","Berwick","1606","463-765-8922","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Ursula","Channing","Rodriguez","Garrison Wilkinson","consectetuer","1999-12-01","592-3428 Porttitor St.","Carahue","54166","570-948-5545","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Keiko","Blaine","Mayo","Reagan Baker","aliquet","1990-05-18","790-3286 Enim Road","Ramskapelle","Z8240","491-272-6463","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Yvette","Hanna","Carpenter","Judah Cantrell","commodo","1999-04-01","Ap #328-8659 Sed Ave","Hartlepool","86944","597-883-6889","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Emma","Jane","Wilcox","Eagan Morrow","turpis.","1991-09-28","4020 Morbi St.","Bierk Bierghes","82497","628-521-7425","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Melvin","Gary","Washington","Scarlet Blevins","elementum,","2004-04-11","P.O. Box 803, 5558 Sem Rd.","Lakewood","577367","185-517-1573","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Geoffrey","Adria","James","Kirsten Wolfe","urna","1997-01-12","670-7459 Risus Street","Lago Verde","GM06 7TI","195-720-6342","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alice","Linus","Rosales","Hope Cantu","et","1995-12-14","789-1486 Interdum. Road","Papasidero","114342","448-292-1848","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Steven","Rina","Hawkins","Regan Nelson","mi.","2003-05-08","193-1758 Nascetur Av.","Brandon","2520","552-986-6450","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Teagan","Acton","Pace","Hall Farley","faucibus","1993-08-09","Ap #409-3723 Varius St.","Fort Collins","S4I 4ZY","432-998-1698","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Jackson","Mallory","Watts","Kelly Harding","facilisis","1997-08-27","418-8187 Cras St.","Port Harcourt","49302","488-395-6254","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Emi","Jamalia","Richmond","Lev Roberson","sem","1993-09-25","P.O. Box 727, 8577 Enim St.","Castres","855330","446-805-0760","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Olga","Burton","French","Xanthus Carson","Ut","1995-05-23","1102 Suspendisse Rd.","Pereto","506606","398-742-4849","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Simon","Fiona","Conrad","Karina Jacobson","Donec","2004-05-25","943-2197 Sem. St.","Rae Bareli","327855","218-631-3232","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Alvin","Yoko","Guzman","Zia Simpson","magna","2002-05-31","Ap #839-3035 Nonummy Rd.","Olmué","6180","795-291-1200","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Sopoline","Sara","Mullins","David Ruiz","sollicitudin","2000-04-03","3650 Nunc St.","Legnica","25443","294-474-1160","1");
INSERT INTO Customers (FirstName,MiddleName,LastName,Username,AccountPassword,DateOfBirth,Address,City,ZipCode,Phone,AccountTypeID) VALUES ("Buckminster","Hollee","Riggs","Hakeem Carson","molestie","2002-01-23","343-5658 Natoque Rd.","Dalbeattie","78390-540","965-559-2873","1");

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
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('All the Bright Places','2020-02-28','1h 48m','Not Yet Rated','6.5/10','allthebrightplaces.jpg'); #9
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Ford v Ferrari','2019-08-30','2h 32m','PG-13','8.1/10','fordvferrari.jpg'); #10
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Midway','2019-11-08','2h 18m','PG-13','6.7/10','midway2019.jpg'); #11
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('The Lion King','2019-07-19','1h 58m','PG','6.9/10','lionking2019.jpg'); #12
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Terminator: Dark Fate','2019-11-01','2h 8m','R','6.3/10','terminatordarkfate2019.jpg'); #13
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Bombshell','2019-12-19','1h 49m','R','6.8/10','bombshell2019.jpg'); #14
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Once Upon a Time in Hollywood','2019-07-26','2h 40m','R','7.7/10','onceuponatimeinhollyword2019.jpg'); #15
insert into Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) values ('Aladdin','2019-05-24','2h 8m','PG','7/10','aladdin2019.jpg'); #16

select * from Movies;
#################################################################################### insert Directors
insert into Directors (Name) values ('Anthony Russo'); #1
insert into Directors (Name) values ('Chris Buck'); #2
insert into Directors (Name) values ('Bong Joon-ho'); #3
insert into Directors (Name) values ('Brett Haley'); #4
insert into Directors (Name) values ('Elizabeth Banks'); #5
insert into Directors (Name) values ('Guy Ritchie'); #6
insert into Directors (Name) values ('Jake Kasdan'); #7
insert into Directors (Name) values ('James Mangold'); #8
insert into Directors (Name) values ('Jay Roach'); #9
insert into Directors (Name) values ('Jennifer Lee'); #10
insert into Directors (Name) values ('Joe Russo'); #11
insert into Directors (Name) values ('Jon Favreau'); #12
insert into Directors (Name) values ('Quentin Tarantino'); #13
insert into Directors (Name) values ('Rian Johnson'); #14
insert into Directors (Name) values ('Roland Emmerich'); #15
insert into Directors (Name) values ('Taika Waititi'); #16
insert into Directors (Name) values ('Tim Miller'); #17
insert into Directors (Name) values ('Todd Phillips'); #18

select * from Directors order by ID asc;

#################################################################################### insert Directors
insert into Cast (Name) values ('Aaron Eckhart'); #1
insert into Cast (Name) values ('Al Pacino'); #2
insert into Cast (Name) values ('Alex Wolff'); #3
insert into Cast (Name) values ('Alexandra Shipp'); #4
insert into Cast (Name) values ('Alfie Allen'); #5
insert into Cast (Name) values ('Alfre Woodard'); #6
insert into Cast (Name) values ('Allison Janney'); #7
insert into Cast (Name) values ('Ana de Armas'); #8
insert into Cast (Name) values ('Arnold Schwarzenegger'); #9
insert into Cast (Name) values ('Austin Butler'); #10
insert into Cast (Name) values ('Awkwafina'); #11
insert into Cast (Name) values ('Benedict Wong'); #12
insert into Cast (Name) values ('Beyoncé Knowles-Carter'); #13
insert into Cast (Name) values ('Billy Eichner'); #14
insert into Cast (Name) values ('Billy Magnussen'); #15
insert into Cast (Name) values ('Brad Pitt'); #16
insert into Cast (Name) values ('Bradley Cooper'); #17
insert into Cast (Name) values ('Brie Larson'); #18
insert into Cast (Name) values ('Bruce Dern'); #19
insert into Cast (Name) values ('Chiwetel Ejiofor'); #20
insert into Cast (Name) values ('Cho Yeo-jeong'); #21
insert into Cast (Name) values ('Choi Woo-shik'); #22
insert into Cast (Name) values ('Chris Evans'); #23
insert into Cast (Name) values ('Chris Hemsworth'); #24
insert into Cast (Name) values ('Christian Bale'); #25
insert into Cast (Name) values ('Christopher Plummer'); #26
insert into Cast (Name) values ('Connie Britton'); #27
insert into Cast (Name) values ('Dakota Fanning'); #28
insert into Cast (Name) values ('Danai Gurira'); #29
insert into Cast (Name) values ('Danny DeVito'); #30
insert into Cast (Name) values ('Danny Glover'); #31
insert into Cast (Name) values ('Darren Criss'); #32
insert into Cast (Name) values ('Dennis Quaid'); #33
insert into Cast (Name) values ('Diego Boneta'); #34
insert into Cast (Name) values ('Djimon Hounsou'); #35
insert into Cast (Name) values ('Don Cheadle'); #36
insert into Cast (Name) values ('Don Johnson'); #37
insert into Cast (Name) values ('Elizabeth Banks'); #38
insert into Cast (Name) values ('Ella Balinska'); #39
insert into Cast (Name) values ('Emile Hirsch'); #40
insert into Cast (Name) values ('Etsushi Toyokawa'); #41
insert into Cast (Name) values ('Felix Mallard'); #42
insert into Cast (Name) values ('Frances Conroy'); #43
insert into Cast (Name) values ('Gabriel Luna'); #44
insert into Cast (Name) values ('Gwyneth Paltrow'); #45
insert into Cast (Name) values ('Idina Menzel'); #46
insert into Cast (Name) values ('Jack Black'); #47
insert into Cast (Name) values ('Jaeden Martell'); #48
insert into Cast (Name) values ('James Earl Jones'); #49
insert into Cast (Name) values ('Jamie Lee Curtis'); #50
insert into Cast (Name) values ('Jang Hye-jin'); #51
insert into Cast (Name) values ('Jeremy Renner'); #52
insert into Cast (Name) values ('John Kani'); #53
insert into Cast (Name) values ('John Lithgow'); #54
insert into Cast (Name) values ('John Oliver'); #55
insert into Cast (Name) values ('Jon Favreau'); #56
insert into Cast (Name) values ('Jonathan Groff'); #57
insert into Cast (Name) values ('Josh Brolin'); #58
insert into Cast (Name) values ('Josh Gad'); #59
insert into Cast (Name) values ('Jun Kunimura'); #60
insert into Cast (Name) values ('Justice Smith'); #61
insert into Cast (Name) values ('Karen Gillan'); #62
insert into Cast (Name) values ('Kate McKinnon'); #63
insert into Cast (Name) values ('Katherine Langford'); #64
insert into Cast (Name) values ('Keean Johnson'); #65
insert into Cast (Name) values ('Keegan-Michael Key'); #66
insert into Cast (Name) values ('Kelli O\'Hara'); #67
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
insert into Cast (Name) values ('Seth Rogen'); #105
insert into Cast (Name) values ('Sofia Hasmik'); #106
insert into Cast (Name) values ('Stephen Merchant'); #107
insert into Cast (Name) values ('Tadanobu Asano'); #108
insert into Cast (Name) values ('Taika Waititi'); #109
insert into Cast (Name) values ('Thomasin McKenzie'); #110
insert into Cast (Name) values ('Timothy Olyphant'); #111
insert into Cast (Name) values ('Toni Collette'); #112
insert into Cast (Name) values ('Virginia Gardner'); #113
insert into Cast (Name) values ('Woody Harrelson'); #114
insert into Cast (Name) values ('Zazie Beetz'); #115
insert into Cast (Name) values ('Charlize Theron'); #116
insert into Cast (Name) values ('Daniel Craig'); #117
insert into Cast (Name) values ('Donald Glover'); #118
insert into Cast (Name) values ('Dwayne Johnson'); #119
insert into Cast (Name) values ('Ed Skrein'); #120
insert into Cast (Name) values ('Elle Fanning'); #121
insert into Cast (Name) values ('Joaquin Phoenix'); #122
insert into Cast (Name) values ('Kristen Bell'); #123
insert into Cast (Name) values ('Kristen Stewart'); #124
insert into Cast (Name) values ('Leonardo DiCaprio'); #125
insert into Cast (Name) values ('Linda Hamilton'); #126
insert into Cast (Name) values ('Matt Damon'); #127
insert into Cast (Name) values ('Robert Downey Jr.'); #128
insert into Cast (Name) values ('Roman Griffin Davis'); #129
insert into Cast (Name) values ('Song Kang-ho'); #130
insert into Cast (Name) values ('Will Smith'); #131

select * from Cast order by ID asc;

#################################################################################### insert Genre
insert into Genres (Genre) values ('Action'); #1
insert into Genres (Genre) values ('Adventure'); #2
insert into Genres (Genre) values ('Comedy-drama'); #3
insert into Genres (Genre) values ('Drama'); #4
insert into Genres (Genre) values ('Fantasy'); #5
insert into Genres (Genre) values ('History'); #6
insert into Genres (Genre) values ('Music'); #7
insert into Genres (Genre) values ('Mystery'); #8
insert into Genres (Genre) values ('Romance'); #9
insert into Genres (Genre) values ('Sci-fi'); #10
insert into Genres (Genre) values ('Sport'); #11
insert into Genres (Genre) values ('Thriller'); #12

select * from Genres order by ID asc;

#################################################################################### insert MovieDirectors

insert into MovieDirectors (MovieID, DirectorID) values (1, 7); # Jake Kasdan directs Jumanji: The Next Level
insert into MovieDirectors (MovieID, DirectorID) values (2, 2); #  Chris Buck directs Frozen 2
insert into MovieDirectors (MovieID, DirectorID) values (2, 10); # Jennifer Lee directs Frozen 2
insert into MovieDirectors (MovieID, DirectorID) values (3, 3); # Bong Joon-ho directs Parasite
insert into MovieDirectors (MovieID, DirectorID) values (4, 18); # Todd Phillips directs Joker (2019 film)
insert into MovieDirectors (MovieID, DirectorID) values (5, 14); # Rian Johnson directs Knives Out
insert into MovieDirectors (MovieID, DirectorID) values (6, 1); #  Anthony Russo directs Avengers: Endgame
insert into MovieDirectors (MovieID, DirectorID) values (6, 11); # Joe Russo directs Avengers: Endgame
insert into MovieDirectors (MovieID, DirectorID) values (6, 12); # Jon Favreau directs Avengers: Endgame
insert into MovieDirectors (MovieID, DirectorID) values (7, 16); # Taika Waititi directs Jojo Rabbit
insert into MovieDirectors (MovieID, DirectorID) values (8, 5); # Elizabeth Banks directs Charlie\'s Angels
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
insert into MovieGenres (MovieID, GenreID) values (8, 2); # Charlie\'s Angels is Adventure
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
insert into MovieWriters (MovieID, WriterID) values (8, 19); # Charlie\'s Angels is directed by Elizabeth Banks
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
insert into MovieCast (MovieID, CastID) values (1, 119); # Dwayne Johnson is in Jumanji: The Next Level
insert into MovieCast (MovieID, CastID) values (2, 46); # Idina Menzel is in Frozen 2
insert into MovieCast (MovieID, CastID) values (2, 57); # Jonathan Groff is in Frozen 2
insert into MovieCast (MovieID, CastID) values (2, 59); # Josh Gad is in Frozen 2
insert into MovieCast (MovieID, CastID) values (2, 123); # Kristen Bell is in Frozen 2
insert into MovieCast (MovieID, CastID) values (3, 21); # Cho Yeo-jeong is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 22); # Choi Woo-shik is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 51); # Jang Hye-jin is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 71); # Lee Jung-eun is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 72); # Lee Sun-kyun is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 95); # Park So-dam is in Parasite
insert into MovieCast (MovieID, CastID) values (3, 130); # Song Kang-ho is in Parasite
insert into MovieCast (MovieID, CastID) values (4, 43); # Frances Conroy is in Joker (2019 film)
insert into MovieCast (MovieID, CastID) values (4, 100); # Robert De Niro is in Joker (2019 film)
insert into MovieCast (MovieID, CastID) values (4, 115); # Zazie Beetz is in Joker (2019 film)
insert into MovieCast (MovieID, CastID) values (4, 122); # Joaquin Phoenix is in Joker (2019 film)
insert into MovieCast (MovieID, CastID) values (5, 8); # Ana de Armas is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 23); # Chris Evans is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 26); # Christopher Plummer is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 37); # Don Johnson is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 48); # Jaeden Martell is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 50); # Jamie Lee Curtis is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 64); # Katherine Langford is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 69); # Lakeith Stanfield is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 85); # Michael Shannon is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 112); # Toni Collette is in Knives Out
insert into MovieCast (MovieID, CastID) values (5, 117); # Daniel Craig is in Knives Out
insert into MovieCast (MovieID, CastID) values (6, 12); # Benedict Wong is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 17); # Bradley Cooper is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 18); # Brie Larson is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 23); # Chris Evans is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 24); # Chris Hemsworth is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 29); # Danai Gurira is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 36); # Don Cheadle is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 45); # Gwyneth Paltrow is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 52); # Jeremy Renner is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 56); # Jon Favreau is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 58); # Josh Brolin is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 62); # Karen Gillan is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 82); # Mark Ruffalo is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 98); # Paul Rudd is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 103); # Scarlett Johansson is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (6, 128); # Robert Downey Jr. is in Avengers: Endgame
insert into MovieCast (MovieID, CastID) values (7, 5); # Alfie Allen is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 99); # Rebel Wilson is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 102); # Sam Rockwell is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 103); # Scarlett Johansson is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 107); # Stephen Merchant is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 109); # Taika Waititi is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 110); # Thomasin McKenzie is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (7, 129); # Roman Griffin Davis is in Jojo Rabbit
insert into MovieCast (MovieID, CastID) values (8, 35); # Djimon Hounsou is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 38); # Elizabeth Banks is in Charlie\'s Angels
insert into MovieCast (MovieID, CastID) values (8, 39); # Ella Balinska is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 87); # Naomi Scott is in Charlie\'s Angels
insert into MovieCast (MovieID, CastID) values (8, 89); # Nat Faxon is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 94); # Noah Centineo is in Charlie\'s Angels
insert into MovieCast (MovieID, CastID) values (8, 96); # Patrick Stewart is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (8, 101); # Sam Claflin is in Charlie\'s Angels
insert into MovieCast (MovieID, CastID) values (8, 124); # Kristen Stewart is in Charlie\'s Angels
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 4); # Alexandra Shipp is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 42); # Felix Mallard is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 61); # Justice Smith is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 66); # Keegan-Michael Key is in All the Bright Places
INSERT INTO MovieCast (MovieID, CastID) VALUES (9, 67); # Kelli O\'Hara is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (9, 70); # Lamar Johnson is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (9, 75); # Luke Wilson is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (9, 106); # Sofia Hasmik is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (9, 113); # Virginia Gardner is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (9, 121); # Elle Fanning is in All the Bright Places
insert into MovieCast (MovieID, CastID) values (10, 25); # Christian Bale is in Ford v Ferrari
insert into MovieCast (MovieID, CastID) values (10, 127); # Matt Damon is in Ford v Ferrari
insert into MovieCast (MovieID, CastID) values (11, 1); # Aaron Eckhart is in Midway
insert into MovieCast (MovieID, CastID) values (11, 32); # Darren Criss is in Midway
insert into MovieCast (MovieID, CastID) values (11, 33); # Dennis Quaid is in Midway
insert into MovieCast (MovieID, CastID) values (11, 41); # Etsushi Toyokawa is in Midway
insert into MovieCast (MovieID, CastID) values (11, 60); # Jun Kunimura is in Midway
insert into MovieCast (MovieID, CastID) values (11, 65); # Keean Johnson is in Midway
insert into MovieCast (MovieID, CastID) values (11, 73); # Luke Evans is in Midway
insert into MovieCast (MovieID, CastID) values (11, 74); # Luke Kleintank is in Midway
insert into MovieCast (MovieID, CastID) values (11, 79); # Mandy Moore is in Midway
insert into MovieCast (MovieID, CastID) values (11, 92); # Nick Jonas is in Midway
insert into MovieCast (MovieID, CastID) values (11, 97); # Patrick Wilson is in Midway
insert into MovieCast (MovieID, CastID) values (11, 108); # Tadanobu Asano is in Midway
insert into MovieCast (MovieID, CastID) values (11, 114); # Woody Harrelson is in Midway
insert into MovieCast (MovieID, CastID) values (11, 120); # Ed Skrein is in Midway
insert into MovieCast (MovieID, CastID) values (12, 6); # Alfre Woodard is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 13); # Beyoncé Knowles-Carter is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 14); # Billy Eichner is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 20); # Chiwetel Ejiofor is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 49); # James Earl Jones is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 53); # John Kani is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 55); # John Oliver is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 105); # Seth Rogen is in The Lion King
insert into MovieCast (MovieID, CastID) values (12, 118); # Donald Glover is in The Lion King
insert into MovieCast (MovieID, CastID) values (13, 9); # Arnold Schwarzenegger is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (13, 34); # Diego Boneta is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (13, 44); # Gabriel Luna is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (13, 76); # Mackenzie Davis is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (13, 90); # Natalia Reyes is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (13, 126); # Linda Hamilton is in Terminator: Dark Fate
insert into MovieCast (MovieID, CastID) values (14, 7); # Allison Janney is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 27); # Connie Britton is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 54); # John Lithgow is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 63); # Kate McKinnon is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 78); # Malcolm McDowell is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 81); # Margot Robbie is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 93); # Nicole Kidman is in Bombshell
insert into MovieCast (MovieID, CastID) values (14, 116); # Charlize Theron is in Bombshell
insert into MovieCast (MovieID, CastID) values (15, 2); # Al Pacino is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 10); # Austin Butler is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 16); # Brad Pitt is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 19); # Bruce Dern is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 28); # Dakota Fanning is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 40); # Emile Hirsch is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 80); # Margaret Qualley is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 81); # Margot Robbie is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 111); # Timothy Olyphant is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (15, 125); # Leonardo DiCaprio is in Once Upon a Time in Hollywood
insert into MovieCast (MovieID, CastID) values (16, 15); # Billy Magnussen is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 83); # Marwan Kenzari is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 84); # Mena Massoud is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 87); # Naomi Scott is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 88); # Nasim Pedrad is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 91); # Navid Negahban is in Aladdin
insert into MovieCast (MovieID, CastID) values (16, 131); # Will Smith is in Aladdin

select * from MovieCast order by MovieID asc;

#################################################################################### insert Medias

insert into Medias (Media) values ('DVD');
insert into Medias (Media) values ('BLU-RAY');

select * from Medias;

#################################################################################### insert Rentals

insert into Rentals (CustomerID, MediaID, RentedOn, ReturnedOn, Returned, TotalDays, TotalCost)
values (3, 1, '2020-3-15', '2020-3-20', true, 5, 10.0); #1

insert into Rentals (CustomerID, MediaID, RentedOn, ReturnedOn, Returned, TotalDays, TotalCost)
values (3, 2, '2020-3-15', '2020-3-20', true, 5, 15.0); #2

select * from Rentals;

#################################################################################### insert MovieRental

insert into MovieRental (MovieID, RentalID) values (2, 1);
insert into MovieRental (MovieID, RentalID) values (5, 2);

select * from MovieRental order by MovieID asc;

#################################################################################### select JOINS

##### Customer and AccountType (ROLE) #####
select c.ID, c.Username, c.AccountPassword, a.Type as AccountType, c.FirstName, c.MiddleName, c.LastName, c.DateOfBirth,
c.Address, c.City, c.ZipCode, c.Phone from Customers c inner join AccountTypes a on (c.AccountTypeID = a.ID);

##### Figure 5 #####

#################################################################################### select all from table
select * from AccountTypes;
select * from Customers;
select * from Movies;
select * from Directors order by ID asc;
select * from Writers order by ID asc;
select * from Cast order by ID asc;
select * from Genres order by ID asc;
select * from MovieDirectors order by MovieID asc;
select * from MovieGenres order by MovieID asc;
select * from MovieWriters order by MovieID asc;
select * from MovieCast order by MovieID asc;
select * from Medias;
select * from Rentals;
select * from MovieRental order by MovieID asc;

