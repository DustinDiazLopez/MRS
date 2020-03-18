package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.model.Movie;
import dustin.diaz.comp4400.model.User;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class Query {
    //SELECT users
    public static String allUsers = "SELECT * FROM rental.Customer";
    public static String userByID = "SELECT * FROM rental.Customer WHERE ID = ?";
    public static String userByUsername = "SELECT * FROM rental.Customer WHERE Username = ?";

    //SELECT movies
    public static String allMovies = "SELECT * FROM rental.Movie";
    public static String movieByID = "SELECT * FROM rental.Movie WHERE ID = ?";

    //SELECT rentals
    public static String allRentals = "SELECT * FROM rental.Rental";

    //INSERT user
    public static String insertUser = "INSERT INTO rental.Customer (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'USER');";

    //INSERT movie
    public static String insertMovie = "INSERT INTO rental.Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    //INSERT rental
    public static String insertRental = "INSERT INTO rental.Rental (CustomerID, MovieID, RentedOn, Media) VALUES (?, ?, ?, ?)";

    public static int insertUser(String username, String accountPassword, String firstName, String middleName,
                                 String lastName, String dateOfBirth, String address, String city, String zipCode,
                                 String phone) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.insertUser);
        preparedStatement.setString(1, username);
        preparedStatement.setString(2, accountPassword);
        preparedStatement.setString(3, firstName);
        preparedStatement.setString(4, middleName);
        preparedStatement.setString(5, lastName);
        preparedStatement.setString(6, dateOfBirth);
        preparedStatement.setString(7, address);
        preparedStatement.setString(8, city);
        preparedStatement.setString(9, zipCode);
        preparedStatement.setString(10, phone);
        return preparedStatement.executeUpdate();
    }

    public static ArrayList<User> findAllUsers() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.allUsers);

        ResultSet resultSet = preparedStatement.executeQuery();
        ArrayList<User> users = new ArrayList<>();

        while (resultSet.next()) {
            User user = new User();
            user.setId(resultSet.getInt("ID"));
            user.setUsername(resultSet.getString("Username"));
            user.setAccountPassword(resultSet.getString("AccountPassword"));
            user.setFirstName(resultSet.getString("FirstName"));
            user.setMiddleName(resultSet.getString("MiddleName"));
            user.setLastName(resultSet.getString("LastName"));
            user.setDateOfBirth(Date.valueOf(resultSet.getString("DateOfBirth")));
            user.setAddress(resultSet.getString("Address"));
            user.setCity(resultSet.getString("City"));
            user.setZipCode(resultSet.getString("ZipCode"));
            user.setPhone(resultSet.getString("Phone"));
            user.setAccountType(resultSet.getString("AccountType"));
            String s = resultSet.getString("RentedHistory");

            if (s == null) {
                s = "You haven't rented anything :(";
            }

            user.setRentedHistory(s.split(","));
            users.add(user);
        }

        return !users.isEmpty() ? users : null;
    }

    public static ArrayList<Movie> findAllMovies() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.allMovies);

        ResultSet resultSet = preparedStatement.executeQuery();
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            Movie movie = new Movie();
            movie.setId(resultSet.getInt("ID"));
            movie.setTitle(resultSet.getString("Title"));
            movie.setDirectors(resultSet.getString("Directors").split(","));
            movie.setWriters(resultSet.getString("Writers").split(","));
            movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
            movie.setGenre(resultSet.getString("Genre"));
            movie.setRunTime(resultSet.getString("RunTime"));
            movie.setRated(resultSet.getString("Rated"));
            movie.setCast(resultSet.getString("Cast").split(","));
            movie.setRatings(resultSet.getString("Ratings").split(","));
            movie.setFileName(resultSet.getString("Filename"));
            movies.add(movie);
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static ArrayList<Movie> findMoviesByGenre(String genre) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.allMovies);

        ResultSet resultSet = preparedStatement.executeQuery();
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            Movie movie = new Movie();
            String g = resultSet.getString("Genre");
            if (g.toLowerCase().contains(genre.toLowerCase())) {
                movie.setId(resultSet.getInt("ID"));
                movie.setTitle(resultSet.getString("Title"));
                movie.setDirectors(resultSet.getString("Directors").split(","));
                movie.setWriters(resultSet.getString("Writers").split(","));
                movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
                movie.setGenre(g);
                movie.setRunTime(resultSet.getString("RunTime"));
                movie.setRated(resultSet.getString("Rated"));
                movie.setCast(resultSet.getString("Cast").split(","));
                movie.setRatings(resultSet.getString("Ratings").split(","));
                movie.setFileName(resultSet.getString("Filename"));
                movies.add(movie);
            }
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static User findUserByUsername(String username) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.userByUsername);
        preparedStatement.setString(1, username);
        ResultSet resultSet = preparedStatement.executeQuery();
        User user = new User();

        while (resultSet.next()) {
            user.setId(resultSet.getInt("ID"));
            user.setUsername(resultSet.getString("Username"));
            user.setAccountPassword(resultSet.getString("AccountPassword"));
            user.setFirstName(resultSet.getString("FirstName"));
            user.setMiddleName(resultSet.getString("MiddleName"));
            user.setLastName(resultSet.getString("LastName"));
            user.setDateOfBirth(Date.valueOf(resultSet.getString("DateOfBirth")));
            user.setAddress(resultSet.getString("Address"));
            user.setCity(resultSet.getString("City"));
            user.setZipCode(resultSet.getString("ZipCode"));
            user.setPhone(resultSet.getString("Phone"));
            user.setAccountType(resultSet.getString("AccountType"));
            String s = resultSet.getString("RentedHistory");

            if (s == null) {
                s = "You haven't rented anything :(";
            }

            user.setRentedHistory(s.split(","));
        }

        return user.getId() != 0 ? user : null;
    }

    public static User findUserByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.userByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        User user = new User();

        while (resultSet.next()) {
            user.setId(resultSet.getInt("ID"));
            user.setUsername(resultSet.getString("Username"));
            user.setAccountPassword(resultSet.getString("AccountPassword"));
            user.setFirstName(resultSet.getString("FirstName"));
            user.setMiddleName(resultSet.getString("MiddleName"));
            user.setLastName(resultSet.getString("LastName"));
            user.setDateOfBirth(Date.valueOf(resultSet.getString("DateOfBirth")));
            user.setAddress(resultSet.getString("Address"));
            user.setCity(resultSet.getString("City"));
            user.setZipCode(resultSet.getString("ZipCode"));
            user.setPhone(resultSet.getString("Phone"));
            user.setAccountType(resultSet.getString("AccountType"));
            String s = resultSet.getString("RentedHistory");

            if (s == null) {
                s = "You haven't rented anything :(";
            }

            user.setRentedHistory(s.split(","));
        }

        return user.getId() != 0 ? user : null;
    }

    public static Movie findMovieByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(Query.movieByID);
        preparedStatement.setInt(1, id);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();

        while (resultSet.next()) {
            movie.setId(resultSet.getInt("ID"));
            movie.setTitle(resultSet.getString("Title"));
            movie.setDirectors(resultSet.getString("Directors").split(","));
            movie.setWriters(resultSet.getString("Writers").split(","));
            movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
            movie.setGenre(resultSet.getString("Genre"));
            movie.setRunTime(resultSet.getString("RunTime"));
            movie.setRated(resultSet.getString("Rated"));
            movie.setCast(resultSet.getString("Cast").split(","));
            movie.setRatings(resultSet.getString("Ratings").split(","));
            movie.setFileName(resultSet.getString("Filename"));
        }

        return movie.getId() != 0 ? movie : null;
    }
}
