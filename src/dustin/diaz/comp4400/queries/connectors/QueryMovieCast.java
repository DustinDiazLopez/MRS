package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.model.connector.MovieCast;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieCast {
    //INSERT
    public static final String insert = "INSERT INTO " + Database.MOVIE_CAST + " (MovieID, CastID) VALUES (?, ?);";

    //SELECT
    public static final String allMovieDirectors = "SELECT * FROM " + Database.MOVIE_CAST;
    public static final String movieDirectorByMovieID = "SELECT * FROM " + Database.MOVIE_CAST + " WHERE MovieID = ?";
    public static final String movieDirectorByDirectorID = "SELECT * FROM " + Database.MOVIE_CAST + " WHERE CastID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + Database.MOVIE_CAST + " SET MovieID = ?, CastID = ? WHERE MovieID = ? AND CastID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + Database.MOVIE_CAST + " WHERE MovieID = ? AND CastID = ?";

    public static int insert(int movieId, int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insert);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, directorId);
        return preparedStatement.executeUpdate();
    }

    private static MovieCast getMovieCast(ResultSet resultSet) throws SQLException {
        MovieCast director = new MovieCast();
        director.setMovieId(resultSet.getInt("MovieID"));
        director.setCastId(resultSet.getInt("CastID"));
        return validate(director);
    }

    private static MovieCast validate(MovieCast director) {
        if (director == null) return null;
        else return director.getMovieId() != 0 || director.getCastId() != 0 ? director : null;
    }

    private static ArrayList<MovieCast> get(ResultSet resultSet) throws SQLException {
        ArrayList<MovieCast> directors = new ArrayList<>();

        while (resultSet.next()) {
            MovieCast director = getMovieCast(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<MovieCast> findAll() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allMovieDirectors);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieCast> findByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByMovieID);
        preparedStatement.setInt(1, movieId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieCast> findByCastID(int directorId) throws SQLException {
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
            test = insert(16, 5);
            if (test != 1) {
                error(testNumber, "INSERT", "Failed to insert value");
                return false;
            }
            testNumber++;
            insert(16, 5);
            error(testNumber, "INSERT", "Inserted duplicate entry");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        test = delete(16, 5);
        if (test != 1) {
            error(testNumber, "DELETE", "Failed to insert value");
            return false;
        }

        testNumber++;
        try {
            ArrayList<MovieCast> s = findAll();
            if (s.isEmpty()) {
                error(testNumber, "FIND", "Couldn't find anything in Movie-Cast");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            test = update(1, 3, 1, 1);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value");
                return false;
            }
            testNumber++;
            test = update(1, 1, 1, 3);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value back");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieCast> mv = findByCastID(23);
            if (mv.size() != 2) {
                error(testNumber, "FIND", "Failed to find values by director id");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieCast> mv = findByMovieID(14);
            if (mv.size() != 8) {
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
