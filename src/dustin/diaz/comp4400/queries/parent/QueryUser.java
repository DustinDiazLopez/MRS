package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.parent.User;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.child.QueryAccountType;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryUser {

    //SELECT users
    public static final String allUsers = "SELECT * FROM " + Database.CUSTOMER;
    public static final String userByID = "SELECT * FROM " + Database.CUSTOMER + " WHERE ID = ?";
    public static final String userByUsername = "SELECT * FROM " + Database.CUSTOMER + " WHERE Username = ?";
    public static final String userByUsernameAccTypeJoin = "SELECT c.ID, c.Username, c.AccountPassword, a.Type AS AccountType, c.FirstName, c.MiddleName, c.LastName, c.DateOfBirth, c.Address, c.City, c.ZipCode, c.Phone FROM " + Database.CUSTOMER + " c INNER JOIN " + Database.ACCOUNT_TYPE + " a ON (c.AccountTypeID = a.ID) WHERE c.Username = ?;";

    //UPDATE user
    public static final String updateUserByIDAndUsername = "UPDATE " + Database.CUSTOMER + " SET AccountPassword = ?, FirstName = ?, MiddleName = ?, LastName = ?, DateOfBirth = ?, Address = ?, City = ?, ZipCode = ?, Phone = ? WHERE Username = ? AND ID = ?;";

    //INSERT user
    public static final String insertUser = "INSERT INTO " + Database.CUSTOMER + " (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1);";

    public static int insertUser(String username, String accountPassword, String firstName, String middleName,
                                 String lastName, String dateOfBirth, String address, String city, String zipCode,
                                 String phone) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.insertUser);
        int i = 1;
        preparedStatement.setString(i, username);
        preparedStatement.setString(++i, accountPassword);
        preparedStatement.setString(++i, firstName);
        preparedStatement.setString(++i, middleName);
        preparedStatement.setString(++i, lastName);
        preparedStatement.setString(++i, dateOfBirth);
        preparedStatement.setString(++i, address);
        preparedStatement.setString(++i, city);
        preparedStatement.setString(++i, zipCode);
        preparedStatement.setString(++i, phone);
        return preparedStatement.executeUpdate();
    }

    public static int updateUser(int id, String username, String accountPassword, String firstName, String middleName,
                                 String lastName, String dateOfBirth, String address, String city, String zipCode,
                                 String phone) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.updateUserByIDAndUsername);
        int i = 1;
        preparedStatement.setString(i, accountPassword);
        preparedStatement.setString(++i, firstName);
        preparedStatement.setString(++i, middleName);
        preparedStatement.setString(++i, lastName);
        preparedStatement.setString(++i, dateOfBirth);
        preparedStatement.setString(++i, address);
        preparedStatement.setString(++i, city);
        preparedStatement.setString(++i, zipCode);
        preparedStatement.setString(++i, phone);
        preparedStatement.setString(++i, username);
        preparedStatement.setInt(++i, id);
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
        String accType = QueryAccountType.findType(resultSet.getInt("AccountTypeID")).getType();
        user.setAccountType(accType);
//        String s = resultSet.getString("RentedHistory");
//
//        if (s == null) s = "You haven't rented anything :(";
//
//        user.setRentedHistory(s.split(","));
        return validate(user);
    }

    private static User validate(User user) {
        if (user == null) return null;
        else return user.getId() != 0 ? user : null;
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
        return validate(user);
    }

    public static User findUserByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryUser.userByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        User user = new User();
        while (resultSet.next()) user = getUser(resultSet);
        return validate(user);
    }

}
