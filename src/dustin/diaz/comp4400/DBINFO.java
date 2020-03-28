package dustin.diaz.comp4400;

public class DBINFO {
    public static final String USERNAME = "root";
    public static final String PASSWORD = "s0m3t1m3s1h@t3p@ssw0rds";
    public static final String DB = "MovieRentalSystem";
    public static final String URL = "jdbc:mysql://localhost:3306/" + DB + "?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    public static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static final String CUSTOMER = DB + ".Customers";
    public static final String ACCOUNT_TYPE = DB + ".AccountTypes";

    public static final String RENTAL = DB + ".Rentals";
    public static final String MEDIA = DB + ".Medias";

    public static final String MOVIE = DB + ".Movies";
    public static final String MOVIE_DIRECTORS = DB + ".MovieDirectors";
    public static final String DIRECTORS = DB + ".Directors";
    public static final String MOVIE_WRITERS = DB + ".MovieWriters";
    public static final String WRITERS = DB + ".Writers";
    public static final String MOVIE_GENRE = DB + ".MovieGenres";
    public static final String GENRE = DB + ".Genres";
    public static final String MOVIE_CAST = DB + ".MovieCast";
    public static final String CAST = DB + ".Cast";
    public static final String MOVIE_RENTAL = DB + ".MovieRental";
}
