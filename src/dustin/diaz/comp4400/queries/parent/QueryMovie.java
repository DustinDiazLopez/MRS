package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.child.QueryCast;
import dustin.diaz.comp4400.queries.child.QueryDirectors;
import dustin.diaz.comp4400.queries.child.QueryGenre;
import dustin.diaz.comp4400.queries.child.QueryWriters;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryMovie {
    //INSERT movie
    public static final String insertMovie = "INSERT INTO " + Database.MOVIE + " (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES (?, ?, ?, ?, ?, ?)";

    //SELECT movies
    public static final String allMovies = "SELECT * FROM " + Database.MOVIE;
    public static final String movieByID = "SELECT * FROM " + Database.MOVIE + " WHERE ID = ?";
    public static final String movieByTitle = "SELECT * FROM " + Database.MOVIE + " WHERE Title = ?";

    //UPDATE
    public static final String updateMovieByID = "UPDATE " + Database.MOVIE + " SET Title = ?, ReleaseDate = ?, RunTime = ?, Rated = ?, Ratings = ?, Filename = ? WHERE ID = ?";

    //DELETE
    public static final String deleteMovieByID = "DELETE FROM " + Database.MOVIE + " WHERE ID = ?";

    public static int insert(String title, Date releaseDate, String runTime, String Rated, String Ratings,
                             String filename) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertMovie);
        int i = 1;
        preparedStatement.setString(i, title);
        preparedStatement.setString(++i, releaseDate.toLocalDate().toString());
        preparedStatement.setString(++i, runTime);
        preparedStatement.setString(++i, Rated);
        preparedStatement.setString(++i, Ratings);
        preparedStatement.setString(++i, filename);
        return preparedStatement.executeUpdate();
    }

    public static int update(int id, String title, Date releaseDate, String runTime, String Rated, String Ratings,
                             String filename) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateMovieByID);
        int i = 1;
        preparedStatement.setString(i, title);
        preparedStatement.setString(++i, releaseDate.toLocalDate().toString());
        preparedStatement.setString(++i, runTime);
        preparedStatement.setString(++i, Rated);
        preparedStatement.setString(++i, Ratings);
        preparedStatement.setString(++i, filename);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int delete(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteMovieByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    private static Movie getMovie(ResultSet resultSet) throws SQLException {
        Movie movie = new Movie();
        int movieId = resultSet.getInt("ID");
        movie.setId(movieId);
        movie.setTitle(resultSet.getString("Title"));
        movie.setDirectors(QueryDirectors.get(movieId));
        movie.setWriters(QueryWriters.get(movieId));
        movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
        movie.setGenres(QueryGenre.get(movieId));
        movie.setRunTime(resultSet.getString("RunTime"));
        movie.setRated(resultSet.getString("Rated"));
        movie.setCast(QueryCast.get(movieId));
        movie.setRating(resultSet.getString("Ratings"));
        movie.setFileName(resultSet.getString("Filename"));
        return validate(movie);
    }

    private static ArrayList<Movie> getMovies(ResultSet resultSet) throws SQLException {
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            Movie movie = getMovie(resultSet);
            movies.add(movie);
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static ArrayList<Movie> findAllMovies() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.allMovies);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getMovies(resultSet);
    }

    public static Movie findMovie(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByID);
        preparedStatement.setInt(1, id);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();
        while (resultSet.next()) movie = getMovie(resultSet);
        return validate(movie);
    }

    public static Movie findMovie(String title) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByTitle);
        preparedStatement.setString(1, title);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();
        while (resultSet.next()) movie = getMovie(resultSet);
        return validate(movie);
    }

    private static Movie validate(Movie movie) {
        if (movie == null) return null;
        return movie.getId() != 0 ? movie : null;
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        ArrayList<Movie> all = findAllMovies();
        if (all.size() != 16) {
            error(testNumber, "FIND ALL", "Could't find all values in movie");
            return false;
        }

        testNumber++;
        Movie found = findMovie(1);
        if (found == null) {
            error(testNumber, "FIND", "Could't find inserted value by id");
            return false;
        }

        testNumber++;
        found = findMovie("Joker (2019 film)");
        if (found == null) {
            error(testNumber, "FIND", "Could't find value by title");
            return false;
        }

        testNumber++;
        String uuid = UUID.randomUUID().toString();
        int i = insert(uuid, Date.valueOf("2020-03-21"), "1h", "PG-13", "10/10", "filename.jpg");
        if (i != 1) {
            error(testNumber, "INSERT", "Could't insert value");
            return false;
        }

        testNumber++;
        found = findMovie(uuid);
        if (found == null) {
            error(testNumber, "FIND", "Could't find inserted value by title");
            return false;
        }

        testNumber++;
        i = update(found.getId(), "found.getTitle()", found.getReleaseDate(), found.getRunTime(), found.getRated(), found.getRating(), found.getFileName());
        if (i != 1) {
            error(testNumber, "FIND", "Could't find inserted value by title");
            return false;
        }
        testNumber++;
        i = delete(found.getId());
        if (i != 1) {
            error(testNumber, "DELETE", "Could't delete value by id");
            return false;
        }

        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
