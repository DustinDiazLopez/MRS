package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.connector.MovieRental;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.child.*;
import dustin.diaz.comp4400.queries.connectors.QueryMovieRental;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryRental {
    //INSERT movie
    public static final String insertRental = "INSERT INTO " + Database.RENTAL + " (CustomerID, MediaID, RentedOn, Returned) VALUES (?, ?, ?, ?)";

    //SELECT movies
    public static final String allRentals = "SELECT * FROM " + Database.RENTAL;
    public static final String rentalByID = "SELECT * FROM " + Database.RENTAL + " WHERE ID = ?";

    //UPDATE
    public static final String updateRentalByID = "UPDATE " + Database.RENTAL + " SET Returned = ?, ReturnedOn = ?, TotalDays = ?, TotalCost = ? WHERE ID = ? AND CustomerID = ?";

    //DELETE
    public static final String deleteRentalByID = "DELETE FROM " + Database.RENTAL + " WHERE ID = ?";

    public static Movie getRental(int rentalId) throws SQLException {
        MovieRental movieRental = QueryMovieRental.findByRentalID(rentalId);
        return movieRental != null ? QueryMovie.findMovie(movieRental.getMovieId()) : null;
    }

    public static int insert(int customerId, int mediaId, Date rentedOn, boolean returned) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertRental);
        int i = 1;
        preparedStatement.setInt(i, customerId);
        preparedStatement.setInt(++i, mediaId);
        preparedStatement.setString(++i, rentedOn.toLocalDate().toString());
        preparedStatement.setBoolean(++i, returned);
        return preparedStatement.executeUpdate();
    }

    public static int update(int id, int customerId, boolean returned, Date returnedOn, int totalDays, float totalCost)
            throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateRentalByID);
        int i = 1;
        preparedStatement.setInt(i, id);
        preparedStatement.setInt(++i, customerId);
        preparedStatement.setBoolean(++i, returned);
        preparedStatement.setString(++i, returnedOn.toLocalDate().toString());
        preparedStatement.setInt(++i, totalDays);
        preparedStatement.setFloat(++i, totalCost);
        return preparedStatement.executeUpdate();
    }

    public static int delete(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteRentalByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    private static Rental getRental(ResultSet resultSet) throws SQLException {
        Rental rental = new Rental();
        rental.setId(resultSet.getInt("ID"));
        rental.setCustomerId(resultSet.getInt("CustomerID"));
        rental.setMedia(QueryMedias.findMedia(resultSet.getInt("MediaID")));
        rental.setRentedOn(Date.valueOf(resultSet.getString("RentedOn")));
        rental.setReturned(resultSet.getBoolean("Returned"));
        rental.setReturnedOn(Date.valueOf(resultSet.getString("ReturnedOn")));
        rental.setTotalCost(resultSet.getFloat("TotalCost"));
        rental.setTotalDays(resultSet.getInt("TotalDays"));
        return validate(rental);
    }

    private static ArrayList<Rental> getRentals(ResultSet resultSet) throws SQLException {
        ArrayList<Rental> rentals = new ArrayList<>();

        while (resultSet.next()) {
            Rental rental = getRental(resultSet);
            rentals.add(rental);
        }

        return !rentals.isEmpty() ? rentals : null;
    }

    public static ArrayList<Rental> findAll() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryRental.allRentals);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getRentals(resultSet);
    }

    public static Rental find(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryRental.rentalByID);
        preparedStatement.setInt(1, id);

        ResultSet resultSet = preparedStatement.executeQuery();
        Rental rental = new Rental();
        while (resultSet.next()) rental = getRental(resultSet);
        return validate(rental);
    }

    private static Rental validate(Rental movie) {
        if (movie == null) return null;
        return movie.getId() != 0 ? movie : null;
    }

    public static boolean test() throws SQLException {
        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}