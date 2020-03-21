package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.parent.Customer;
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
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertUser);
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
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateUserByIDAndUsername);
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

    private static Customer getUser(ResultSet resultSet) throws SQLException {
        Customer customer = new Customer();
        customer.setId(resultSet.getInt("ID"));
        customer.setUsername(resultSet.getString("Username"));
        customer.setAccountPassword(resultSet.getString("AccountPassword"));
        customer.setFirstName(resultSet.getString("FirstName"));
        customer.setMiddleName(resultSet.getString("MiddleName"));
        customer.setLastName(resultSet.getString("LastName"));
        customer.setDateOfBirth(Date.valueOf(resultSet.getString("DateOfBirth")));
        customer.setAddress(resultSet.getString("Address"));
        customer.setCity(resultSet.getString("City"));
        customer.setZipCode(resultSet.getString("ZipCode"));
        customer.setPhone(resultSet.getString("Phone"));
        String accType = QueryAccountType.findType(resultSet.getInt("AccountTypeID")).getType();
        customer.setAccountType(accType);
//        String s = resultSet.getString("RentedHistory");
//
//        if (s == null) s = "You haven't rented anything :(";
//
//        user.setRentedHistory(s.split(","));
        return validate(customer);
    }

    private static Customer validate(Customer customer) {
        if (customer == null) return null;
        else return customer.getId() != 0 ? customer : null;
    }

    private static ArrayList<Customer> getUsers(ResultSet resultSet) throws SQLException {
        ArrayList<Customer> customers = new ArrayList<>();

        while (resultSet.next()) {
            Customer customer = getUser(resultSet);
            customers.add(customer);
        }

        return !customers.isEmpty() ? customers : null;
    }

    public static ArrayList<Customer> findAllUsers() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allUsers);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getUsers(resultSet);
    }

    public static Customer findUserByUsername(String username) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(userByUsername);
        preparedStatement.setString(1, username);
        ResultSet resultSet = preparedStatement.executeQuery();
        Customer customer = new Customer();
        while (resultSet.next()) customer = getUser(resultSet);
        return validate(customer);
    }

    public static Customer findUserByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(userByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Customer customer = new Customer();
        while (resultSet.next()) customer = getUser(resultSet);
        return validate(customer);
    }

}
