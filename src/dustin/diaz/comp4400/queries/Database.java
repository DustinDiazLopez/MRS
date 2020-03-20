package dustin.diaz.comp4400.queries;

public abstract class Database {
    public static final String DB = "rental";
    public static final String URL = "jdbc:mysql://localhost:3306/" + DB + "?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    public static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static final String MOVIE = DB + ".Movie";
    public static final String MOVIE_DIRECTORS = DB + ".MovieDirectors";
    public static final String DIRECTORS = DB + ".Directors";
    public static final String MOVIE_WRITERS = DB + ".MovieWriters";
    public static final String WRITERS = DB + ".Writers";
    public static final String MOVIE_GENRE = DB + ".Genre";
    public static final String GENRE = DB + ".Genre";
    public static final String MOVIE_CAST = DB + ".MovieCast";
    public static final String CAST = DB + ".Cast";

    public static final String RENTAL = DB + ".Rental";
    public static final String MEDIA = DB + ".Media";

    public static final String CUSTOMER = DB + ".Customer";
    public static final String ACCOUNT_TYPE = DB + ".AccountType";
}
