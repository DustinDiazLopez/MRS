package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.connector.MovieDirectors;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieDirector {
    //INSERT
    public static final String insert = "INSERT INTO " + DBINFO.MOVIE_DIRECTORS + " (MovieID, DirectorID) VALUES (?, ?);";

    //SELECT
    public static final String movieDirectorByMovieID = "SELECT * FROM " + DBINFO.MOVIE_DIRECTORS + " WHERE MovieID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + DBINFO.MOVIE_DIRECTORS + " SET MovieID = ?, DirectorID = ? WHERE MovieID = ? AND DirectorID = ?";

    //DELETE
    public static final String deleteMovieDirector = "DELETE FROM " + DBINFO.MOVIE_DIRECTORS + " WHERE MovieID = ? AND DirectorID = ?";
    public static final String deleteMovieDirectorByMovieId = "DELETE FROM " + DBINFO.MOVIE_DIRECTORS + " WHERE MovieID = ?";

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

    public static ArrayList<MovieDirectors> findByMovieID(int movieId) throws SQLException {
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
