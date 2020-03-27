package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.connector.MovieGenres;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieGenre {
    //INSERT
    public static final String insert = "INSERT INTO " + DBINFO.MOVIE_GENRE + " (MovieID, GenreID) VALUES (?, ?);";

    public static final String movieDirectorByMovieID = "SELECT * FROM " + DBINFO.MOVIE_GENRE + " WHERE MovieID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + DBINFO.MOVIE_GENRE + " SET MovieID = ?, CastID = ? WHERE MovieID = ? AND GenreID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + DBINFO.MOVIE_GENRE + " WHERE MovieID = ? AND GenreID = ?";
    public static final String deleteMovieDirectorByMovieId = "DELETE FROM " + DBINFO.MOVIE_GENRE + " WHERE MovieID = ?";

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

    public static ArrayList<MovieGenres> findByMovieID(int movieId) throws SQLException {
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
