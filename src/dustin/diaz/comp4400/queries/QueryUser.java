package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.model.User;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryUser {
    //SELECT users
    public static String allUsers = "SELECT * FROM rental.Customer";
    public static String userByID = "SELECT * FROM rental.Customer WHERE ID = ?";
    public static String userByUsername = "SELECT * FROM rental.Customer WHERE Username = ?";

    //UPDATE user
    public static String updateUserByIDAndUsername = "UPDATE rental.Customer SET AccountPassword = ?, FirstName = ?, MiddleName = ?, LastName = ?, DateOfBirth = ?, Address = ?, City = ?, ZipCode = ?, Phone = ? WHERE Username = ? AND ID = ?;";

    //INSERT user
    public static String insertUser = "INSERT INTO rental.Customer (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'USER');";

    public static int insertUser(String username, String accountPassword, String firstName, String middleName,
                                 String lastName, String dateOfBirth, String address, String city, String zipCode,
                                 String phone) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.insertUser);
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

    public static int updateUser(int id, String username, String accountPassword, String firstName, String middleName,
                                 String lastName, String dateOfBirth, String address, String city, String zipCode,
                                 String phone) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.updateUserByIDAndUsername);
        preparedStatement.setString(1, accountPassword);
        preparedStatement.setString(2, firstName);
        preparedStatement.setString(3, middleName);
        preparedStatement.setString(4, lastName);
        preparedStatement.setString(5, dateOfBirth);
        preparedStatement.setString(6, address);
        preparedStatement.setString(7, city);
        preparedStatement.setString(8, zipCode);
        preparedStatement.setString(9, phone);
        preparedStatement.setString(10, username);
        preparedStatement.setInt(11, id);
        return preparedStatement.executeUpdate();
    }

    private static User getUser(ResultSet resultSet) throws SQLException {
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
            user.setRentedHistory(new String[]{s});
        } else {
            user.setRentedHistory(s.split(","));
        }

        return user.getId() != 0 ? user : null;
    }

    private static ArrayList<User> getUsers(ResultSet resultSet) throws SQLException {
        ArrayList<User> users = new ArrayList<>();

        while (resultSet.next()) {
            User user = getUser(resultSet);
            users.add(user);
        }

        return !users.isEmpty() ? users : null;
    }

    public static ArrayList<User> findAllUsers() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.allUsers);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getUsers(resultSet);
    }

    public static User findUserByUsername(String username) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.userByUsername);
        preparedStatement.setString(1, username);
        ResultSet resultSet = preparedStatement.executeQuery();
        User user = new User();
        while (resultSet.next()) user = getUser(resultSet);
        return user;
    }

    public static User findUserByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.userByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        User user = new User();
        while (resultSet.next()) user = getUser(resultSet);
        return user;
    }

}
