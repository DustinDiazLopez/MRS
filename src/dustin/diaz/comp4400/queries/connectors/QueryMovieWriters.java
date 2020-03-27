package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.connector.MovieWriters;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieWriters {
    //INSERT
    public static final String insert = "INSERT INTO " + DBINFO.MOVIE_WRITERS + " (MovieID, WriterID) VALUES (?, ?);";

    public static final String movieDirectorByMovieID = "SELECT * FROM " + DBINFO.MOVIE_WRITERS + " WHERE MovieID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + DBINFO.MOVIE_WRITERS + " SET MovieID = ?, WriterID = ? WHERE MovieID = ? AND WriterID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + DBINFO.MOVIE_WRITERS + " WHERE MovieID = ? AND WriterID = ?";
    public static final String deleteMovieDirectorByMovieId = "DELETE FROM " + DBINFO.MOVIE_WRITERS + " WHERE MovieID = ?";

    public static int insert(int movieId, int directorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insert);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, directorId);
        return preparedStatement.executeUpdate();
    }

    private static MovieWriters getMovieDirector(ResultSet resultSet) throws SQLException {
        MovieWriters director = new MovieWriters();
        director.setMovieId(resultSet.getInt("MovieID"));
        director.setWriterId(resultSet.getInt("WriterID"));
        return validate(director);
    }

    private static MovieWriters validate(MovieWriters director) {
        if (director == null) return null;
        else return director.getMovieId() != 0 || director.getWriterId() != 0 ? director : null;
    }

    private static ArrayList<MovieWriters> get(ResultSet resultSet) throws SQLException {
        ArrayList<MovieWriters> directors = new ArrayList<>();

        while (resultSet.next()) {
            MovieWriters director = getMovieDirector(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<MovieWriters> findByMovieID(int movieId) throws SQLException {
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
