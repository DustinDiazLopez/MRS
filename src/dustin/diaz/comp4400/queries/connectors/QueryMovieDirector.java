package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.model.connector.MovieDirectors;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieDirector {
    //INSERT
    public static final String insert = "INSERT INTO " + Database.MOVIE_DIRECTORS + " (MovieID, DirectorID) VALUES (?, ?);";

    //SELECT
    public static final String allMovieDirectors = "SELECT * FROM " + Database.MOVIE_DIRECTORS;
    public static final String movieDirectorByMovieID = "SELECT * FROM " + Database.MOVIE_DIRECTORS + " WHERE MovieID = ?";
    public static final String movieDirectorByDirectorID = "SELECT * FROM " + Database.MOVIE_DIRECTORS + " WHERE DirectorID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + Database.MOVIE_DIRECTORS + " SET MovieID = ?, DirectorID = ? WHERE MovieID = ? AND DirectorID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + Database.MOVIE_DIRECTORS + " WHERE MovieID = ? AND DirectorID = ?";

    public static int insert(int movieId, int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insert);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, directorId);
        return preparedStatement.executeUpdate();
    }

    private static MovieDirectors getMovieDirector(ResultSet resultSet) throws SQLException {
        MovieDirectors director = new MovieDirectors();
        director.setMovieId(resultSet.getInt("MovieID"));
        director.setDirectorId(resultSet.getInt("DirectorID"));
        return validate(director);
    }

    private static MovieDirectors validate(MovieDirectors director) {
        if (director == null) return null;
        else return director.getMovieId() != 0 || director.getDirectorId() != 0 ? director : null;
    }

    private static ArrayList<MovieDirectors> get(ResultSet resultSet) throws SQLException {
        ArrayList<MovieDirectors> directors = new ArrayList<>();

        while (resultSet.next()) {
            MovieDirectors director = getMovieDirector(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<MovieDirectors> findAll() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allMovieDirectors);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieDirectors> findByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByMovieID);
        preparedStatement.setInt(1, movieId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

    public static ArrayList<MovieDirectors> findByDirectorID(int directorId) throws SQLException {
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
            ArrayList<MovieDirectors> s = findAll();
            if (s.isEmpty()) {
                error(testNumber, "FIND", "Couldn't find anything in Movie-Director");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            test = update(1, 7, 1, 1);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value");
                return false;
            }
            testNumber++;
            test = update(1, 1, 1, 7);
            if (test != 1) {
                error(testNumber, "UPDATE", "Failed to update value back");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieDirectors> mv = findByDirectorID(12);
            if (mv.size() != 2) {
                error(testNumber, "FIND", "Failed to find values by director id");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            ArrayList<MovieDirectors> mv = findByMovieID(6);
            if (mv.size() != 3) {
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
