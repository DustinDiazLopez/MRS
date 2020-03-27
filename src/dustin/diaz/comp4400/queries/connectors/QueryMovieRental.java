package dustin.diaz.comp4400.queries.connectors;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.connector.MovieRental;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovieRental {
    //INSERT
    public static final String insert = "INSERT INTO " + DBINFO.MOVIE_RENTAL + " (MovieID, RentalID) VALUES (?, ?);";

    public static final String movieDirectorByDirectorID = "SELECT * FROM " + DBINFO.MOVIE_RENTAL + " WHERE RentalID = ?";

    //UPDATE
    public static final String updateMovieDirectorByID = "UPDATE " + DBINFO.MOVIE_RENTAL + " SET MovieID = ?, RentalID = ? WHERE MovieID = ? AND RentalID = ?";

    //DELETE
    public static final String deleteByRentalId = "DELETE FROM " + DBINFO.MOVIE_RENTAL + " WHERE RentalID = ?";
    public static final String deleteMovieDirectorByMovieId = "DELETE FROM " + DBINFO.MOVIE_RENTAL + " WHERE MovieID = ?";

    public static int insert(int movieId, int rentalId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insert);
        preparedStatement.setInt(1, movieId);
        preparedStatement.setInt(2, rentalId);
        return preparedStatement.executeUpdate();
    }

    private static MovieRental getMovieRental(ResultSet resultSet) throws SQLException {
        MovieRental director = new MovieRental();
        director.setMovieId(resultSet.getInt("MovieID"));
        director.setRentalId(resultSet.getInt("RentalID"));
        return validate(director);
    }

    private static MovieRental validate(MovieRental rental) {
        if (rental == null) return null;
        else return rental.getMovieId() != 0 || rental.getRentalId() != 0 ? rental : null;
    }

    private static ArrayList<MovieRental> get(ResultSet resultSet) throws SQLException {
        ArrayList<MovieRental> directors = new ArrayList<>();

        while (resultSet.next()) {
            MovieRental director = getMovieRental(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static MovieRental findByRentalID(int rentalId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(movieDirectorByDirectorID);
        preparedStatement.setInt(1, rentalId);
        ResultSet resultSet = preparedStatement.executeQuery();
        ArrayList<MovieRental> movieRental = get(resultSet);
        return movieRental != null ? movieRental.get(0) : null;
    }

    public static int update(int movieId, int directorId, int newMovieId, int newDirectorId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateMovieDirectorByID);
        preparedStatement.setInt(1, newMovieId);
        preparedStatement.setInt(2, newDirectorId);
        preparedStatement.setInt(3, movieId);
        preparedStatement.setInt(4, directorId);
        return preparedStatement.executeUpdate();
    }

    public static void delete(int rentalId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteByRentalId);
        preparedStatement.setInt(1, rentalId);
        System.out.println("(ID " + rentalId + ") ref del count:" + preparedStatement.executeUpdate());
    }

    public static int deleteByMovieID(int movieId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteMovieDirectorByMovieId);
        preparedStatement.setInt(1, movieId);
        return preparedStatement.executeUpdate();
    }
}
