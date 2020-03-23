package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.connector.MovieRental;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.model.tables.RentalTable;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.child.QueryMedias;
import dustin.diaz.comp4400.queries.connectors.QueryMovieRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryRental {
    //INSERT movie
    private static final String insertRental = "INSERT INTO " + Database.RENTAL + " (CustomerID, MediaID, RentedOn, Returned) VALUES (?, ?, ?, ?);";

    //SELECT movies
    private static final String allRentals = "SELECT * FROM " + Database.RENTAL;
    private static final String rentalByID = "SELECT * FROM " + Database.RENTAL + " WHERE ID = ?";
    private static final String rentalByCustomerID = "SELECT * FROM " + Database.RENTAL + " WHERE CustomerID = ?";
    private static final String last = "SELECT * FROM Rentals ORDER BY ID DESC LIMIT 1;";

    //UPDATE
    private static final String updateRentalByID = "UPDATE " + Database.RENTAL + " SET Returned = ?, ReturnedOn = ?, TotalDays = ?, TotalCost = ? WHERE ID = ? AND CustomerID = ?";
    private static final String updateRentalHeld = "UPDATE " + Database.RENTAL + " SET Held = ? WHERE ID = ? AND CustomerID = ?";

    //DELETE
    private static final String deleteRentalByID = "DELETE FROM " + Database.RENTAL + " WHERE ID = ?";

    public static Movie getMovie(int rentalId) throws SQLException {
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

    public static Rental insertAndReturn(int customerId, int mediaId, Date rentedOn, boolean returned) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertRental);
        int i = 1;
        preparedStatement.setInt(i, customerId);
        preparedStatement.setInt(++i, mediaId);
        preparedStatement.setString(++i, rentedOn.toLocalDate().toString());
        preparedStatement.setBoolean(++i, returned);
        preparedStatement.executeUpdate();
        return find();
    }

    public static Rental find() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryRental.last);
        ResultSet resultSet = preparedStatement.executeQuery();
        Rental rental = new Rental();
        while (resultSet.next()) rental = getRental(resultSet);
        return validate(rental);
    }

    public static int update(int rentalId, int customerId, boolean returned, Date returnedOn, int totalDays, float totalCost)
            throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateRentalByID);
        int i = 1;
        preparedStatement.setBoolean(i, returned);
        preparedStatement.setString(++i, returnedOn.toLocalDate().toString());
        preparedStatement.setInt(++i, totalDays);
        preparedStatement.setFloat(++i, totalCost);
        preparedStatement.setInt(++i, rentalId);
        preparedStatement.setInt(++i, customerId);
        return preparedStatement.executeUpdate();
    }

    public static int updateHeld(int rentalId, int customerId, boolean held) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateRentalHeld);
        int i = 1;
        preparedStatement.setBoolean(i, held);
        preparedStatement.setInt(++i, rentalId);
        preparedStatement.setInt(++i, customerId);
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
        rental.setHeld(resultSet.getBoolean("Held"));

        try {
            rental.setReturnedOn(Date.valueOf(resultSet.getString("ReturnedOn")));
        } catch (Exception ignored) {
        }

        rental.setTotalCost(resultSet.getFloat("TotalCost"));
        rental.setTotalDays(resultSet.getInt("TotalDays"));

        MovieRental movieRental = QueryMovieRental.findByRentalID(rental.getId());
        if (movieRental != null) {
            Movie movie = QueryMovie.findMovie(movieRental.getMovieId());
            rental.setMovie(movie);
        }

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

    public static ArrayList<Rental> find(ArrayList<RentalTable> table) throws SQLException {
        ArrayList<Rental> rentals = new ArrayList<>();
        for (RentalTable i : table) rentals.add(find(i.getRentalId()));
        return rentals;
    }

    public static ArrayList<Rental> findAllByCustomerId(int customerId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryRental.rentalByCustomerID);
        preparedStatement.setInt(1, customerId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getRentals(resultSet);
    }

    private static Rental validate(Rental movie) {
        if (movie == null) return null;
        return movie.getId() != 0 ? movie : null;
    }

    public static boolean test() throws SQLException {
        ArrayList<Rental> rentals = findAll();
        int testNumber = 1;
        if (rentals.size() != 2) {
            error(testNumber, "[...] size: " + rentals.size(), "2 (reset db)");
            return false;
        }

        testNumber++;
        Rental rental = find(1);
        if (rental == null) {
            error(testNumber, "FIND", "Did not find the first value (1) of the table rental");
            return false;
        }

        testNumber++;
        Movie movie = getMovie(1);
        if (movie == null) {
            error(testNumber, "FIND", "Did not find movie by rental id");
            return false;
        }

        testNumber++;
        int test = insert(3, 1, Date.valueOf("2020-3-20"), false);
        if (test != 1) {
            error(testNumber, "INSERT", "Couldn't insert value");
            return false;
        }


        testNumber++;
        test = update(rentals.size() + 1, 3, false, Date.valueOf("2020-3-21"), 10, 30);
        if (test != 1) {
            error(testNumber, "UPDATE", "Couldn't update value (reset db)");
            return false;
        }


        testNumber++;
        test = delete(rentals.size() + 1);
        if (test != 1) {
            error(testNumber, "DELETE", "Couldn't delete value");
            return false;
        }

        testNumber++;
        rentals = findAllByCustomerId(3);
        if (rentals.size() != 2) {
            error(testNumber, "DELETE", "Couldn't delete value");
            return false;
        }
        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }

    public static ArrayList<Rental> getHeld() throws SQLException {
        ArrayList<Rental> rentals = findAll();
        ArrayList<Rental> held = new ArrayList<>();
        for (Rental rental : rentals) if (rental.isHeld()) held.add(rental);
        return held;
    }

    public static ArrayList<RentalTable> getAllForTable() throws SQLException {
        ArrayList<Rental> rentals = findAll();
        ArrayList<RentalTable> table = new ArrayList<>();

        for (Rental rental : rentals) {
            if (!rental.isReturned() && !rental.isHeld()) {
                Customer customer = QueryCustomer.find(rental.getCustomerId());
                String fullname = Styling.formatNames(customer);
                Movie movie = QueryMovie.findMovie(rental.getMovie().getId());
                table.add(new RentalTable(
                        rental.getId(),
                        movie.getId(),
                        customer.getId(),
                        fullname,
                        movie.getTitle(),
                        rental.getRentedOn()
                        )
                );
            }
        }

        return table;
    }
}
