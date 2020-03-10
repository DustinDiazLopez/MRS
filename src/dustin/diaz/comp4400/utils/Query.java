package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.model.User;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class Query {
    public static String allUsers = "SELECT * FROM rental.Customer";
    public static String userByID = "SELECT * FROM rental.Customer WHERE ID = ?";
    public static String userByUsername = "SELECT * FROM rental.Customer WHERE Username = ?";

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

        return users;
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

        return user;
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

        return user;
    }
}
