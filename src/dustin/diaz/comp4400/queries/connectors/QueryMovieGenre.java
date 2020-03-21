package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.model.connector.MovieGenres;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieGenre {
    //INSERT
    public static final String insert = "INSERT INTO " + Database.MOVIE_GENRE + " (MovieID, GenreID) VALUES (?, ?);";

    //SELECT
    public static final String allMovieDirectors = "SELECT * FROM " + Database.MOVIE_GENRE;
    public static final String movieDirectorByMovieID = "SELECT * FROM " + Database.MOVIE_GENRE + " WHERE MovieID = ?";
    public static final String movieDirectorByDirectorID = "SELECT * FROM " + Database.MOVIE_GENRE + " WHERE GenreID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + Database.MOVIE_GENRE + " SET MovieID = ?, CastID = ? WHERE MovieID = ? AND GenreID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + Database.MOVIE_GENRE + " WHERE MovieID = ? AND GenreID = ?";

    public static int insert(int movieId, int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insert);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, directorId);
        return preparedStatement.executeUpdate();
    }

    private static MovieGenres getMovieCast(ResultSet resultSet) throws SQLException {
        MovieGenres director = new MovieGenres();
        director.setMovieId(resultSet.getInt("MovieID"));
        director.setGenreId(resultSet.getInt("GenreID"));
        return validate(director);
    }

    private static MovieGenres validate(MovieGenres director) {
        if (director == null) return null;
        else return director.getMovieId() != 0 || director.getGenreId() != 0 ? director : null;
    }

    private static ArrayList<MovieGenres> get(ResultSet resultSet) throws SQLException {
        ArrayList<MovieGenres> directors = new ArrayList<>();

        while (resultSet.next()) {
            MovieGenres director = getMovieCast(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<MovieGenres> findAll() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allMovieDirectors);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieGenres> findByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByMovieID);
        preparedStatement.setInt(1, movieId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieGenres> findByGenreID(int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByDirectorID);
        preparedStatement.setInt(1, directorId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    //Duplicate entry throw
    public static int update(int movieId, int directorId, int newMovieId, int newDirectorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateMovieDirectorByID);
        preparedStatement.setInt(1, newMovieId);
        preparedStatement.setInt(2, newDirectorId);
        preparedStatement.setInt(3, movieId);
        preparedStatement.setInt(4, directorId);
        return preparedStatement.executeUpdate();
    }

    public static int delete(int movieId, int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteMovieDirector);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, directorId);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        int test;

        try {
            test = insert(16, 7);
            if (test != 1) {
                error(testNumber, "INSERT", "Failed to insert value");
                return false;
            }
            testNumber++;
            insert(16, 7);
            error(testNumber, "INSERT", "Inserted duplicate entry");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        test = delete(16, 7);
        if (test != 1) {
            error(testNumber, "DELETE", "Failed to insert value");
            return false;
        }

        testNumber++;
        try {
            ArrayList<MovieGenres> s = findAll();
            if (s.isEmpty()) {
                error(testNumber, "FIND", "Couldn't find anything in Movie-Genre");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            test = update(1, 1, 1, 3);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value");
                return false;
            }
            testNumber++;
            test = update(1, 3, 1, 1);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value back");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieGenres> mv = findByGenreID(5);
            if (mv.size() != 5) {
                error(testNumber, "FIND", "Failed to find values by director id");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieGenres> mv = findByMovieID(6);
            if (mv.size() != 2) {
                error(testNumber, "FIND", "Failed to find values by movie id");
                return false;
            }
        } catch (Exception ignored) {
        }

        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
