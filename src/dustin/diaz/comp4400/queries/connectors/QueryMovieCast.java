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

    public static final String movieDirectorByMovieID = "SELECT * FROM " + Database.MOVIE_CAST + " WHERE MovieID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + Database.MOVIE_CAST + " SET MovieID = ?, CastID = ? WHERE MovieID = ? AND CastID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + Database.MOVIE_CAST + " WHERE MovieID = ? AND CastID = ?";
    public static final String deleteMovieDirectorByMovieId = "DELETE FROM " + Database.MOVIE_CAST + " WHERE MovieID = ?";

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

    public static ArrayList<MovieCast> findByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByMovieID);
        preparedStatement.setInt(1, movieId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return get(resultSet);
    }

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

    public static int deleteByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteMovieDirectorByMovieId);
        preparedStatement.setInt(1, movieId);
        return preparedStatement.executeUpdate();
    }
}
