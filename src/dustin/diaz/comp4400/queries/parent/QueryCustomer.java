package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.model.child.AccountType;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.child.QueryAccountType;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;

public abstract class QueryCustomer {

    //SELECT
    public static final String allUsers = "SELECT * FROM " + Database.CUSTOMER;
    public static final String userByID = "SELECT * FROM " + Database.CUSTOMER + " WHERE ID = ?";
    public static final String userByUsername = "SELECT * FROM " + Database.CUSTOMER + " WHERE Username = ?";

    //UPDATE
    public static final String updateUserByIDAndUsername = "UPDATE " + Database.CUSTOMER + " SET AccountPassword = ?, FirstName = ?, MiddleName = ?, LastName = ?, DateOfBirth = ?, Address = ?, City = ?, ZipCode = ?, Phone = ? WHERE Username = ? AND ID = ?;";
    public static final String updateUserByID = "UPDATE " + Database.CUSTOMER + " SET Username = ?, AccountPassword = ?, FirstName = ?, MiddleName = ?, LastName = ?, DateOfBirth = ?, Address = ?, City = ?, ZipCode = ?, Phone = ?, AccountTypeID = ? WHERE ID = ?;";

    //INSERT
    public static final String insertUser = "INSERT INTO " + Database.CUSTOMER + " (Username, AccountPassword, FirstName, MiddleName, LastName, DateOfBirth, Address, City, ZipCode, Phone, AccountTypeID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1);";

    //DELETE
    public static final String deleteUser = "DELETE FROM " + Database.CUSTOMER + " WHERE ID = ?";

    public static int insert(String username, String accountPassword, String firstName, String middleName,
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

    public static int insert(Customer customer) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertUser);
        int i = 1;
        preparedStatement.setString(i, customer.getUsername());
        preparedStatement.setString(++i, customer.getAccountPassword());
        preparedStatement.setString(++i, customer.getFirstName());
        preparedStatement.setString(++i, customer.getMiddleName());
        preparedStatement.setString(++i, customer.getLastName());
        preparedStatement.setString(++i, customer.getDateOfBirth().toLocalDate().toString());
        preparedStatement.setString(++i, customer.getAddress());
        preparedStatement.setString(++i, customer.getCity());
        preparedStatement.setString(++i, customer.getZipCode());
        preparedStatement.setString(++i, customer.getPhone());
        return preparedStatement.executeUpdate();
    }

    public static int updateCustomer(int id, String username, String accountPassword, String firstName, String middleName,
                                     String lastName, String dateOfBirth, String address, String city, String zipCode,
                                     String phone, AccountType type) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateUserByID);
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
        preparedStatement.setInt(++i, type.getId());
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int delete(int customerId) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteUser);
        preparedStatement.setInt(1, customerId);
        return preparedStatement.executeUpdate();
    }

    public static int update(int id, String username, String accountPassword, String firstName, String middleName,
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
        customer.setAccountType(QueryAccountType.findType(resultSet.getInt("AccountTypeID")).getType());
        customer.setRentedHistory(QueryRental.findAllByCustomerId(customer.getId()));
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

    public static ArrayList<Customer> findAll() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allUsers);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getUsers(resultSet);
    }

    public static Customer find(String username) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(userByUsername);
        preparedStatement.setString(1, username);
        ResultSet resultSet = preparedStatement.executeQuery();
        Customer customer = new Customer();
        while (resultSet.next()) customer = getUser(resultSet);
        return validate(customer);
    }

    public static Customer find(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(userByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Customer customer = new Customer();
        while (resultSet.next()) customer = getUser(resultSet);
        return validate(customer);
    }

    public static ArrayList<Customer> find(HashSet<Integer> id) throws SQLException {
        ArrayList<Customer> customers = new ArrayList<>();
        for (Integer i : id) customers.add(find(i));
        return customers;
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        Customer customer = find(6);
        if (customer == null) {
            error(testNumber, "FIND", "Couldn't find user 6 (reset db)");
            return false;
        }

        int test = delete(6);
        if (test != 1) {
            error(testNumber, "DELETE", "Couldn't delete user 6");
            return false;
        }

        testNumber++;
        test = insert(customer);
        if (test != 1) {
            error(testNumber, "INSERT", "Couldn't insert user");
            return false;
        }

        testNumber++;
        ArrayList<Customer> customers = findAll();
        if (customers.isEmpty()) {
            error(testNumber, "FINDALL", "Couldn't find any users");
            return false;
        }

        testNumber++;
        customer = find(2);
        if (customer == null) {
            error(testNumber, "FIND", "Couldn't find user 2 (root)");
            return false;
        }

        testNumber++;
        customer = find("dustin123");
        if (customer == null) {
            error(testNumber, "FIND", "Couldn't find user dustin123");
            return false;
        }


        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
