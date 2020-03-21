package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.model.AccountType;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryAccountType {
    //INSERT
    public static final String insertType = "INSERT INTO " + Database.ACCOUNT_TYPE + " (Type) VALUES (?)";

    //SELECT
    public static final String findTypeByID = "SELECT * FROM " + Database.ACCOUNT_TYPE + " WHERE ID = ?";
    public static final String findTypeByName = "SELECT * FROM " + Database.ACCOUNT_TYPE + " WHERE Type = ?";
    public static final String findAllTypes = "SELECT * FROM " + Database.ACCOUNT_TYPE + " ORDER BY ID ASC";

    //UPDATE
    public static final String updateType = "UPDATE " + Database.ACCOUNT_TYPE + " SET Type = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteTypeByName = "DELETE FROM " + Database.ACCOUNT_TYPE + " WHERE Type = ?";
    public static final String deleteTypeByID = "DELETE FROM " + Database.ACCOUNT_TYPE + " WHERE ID = ?";

    public static int insertType(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertType);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    private static AccountType validate(AccountType user) {
        if (user == null) return null;
        else return user.getId() != 0 ? user : null;
    }

    private static ArrayList<AccountType> getTypes(ResultSet resultSet) throws SQLException {
        ArrayList<AccountType> types = new ArrayList<>();

        while (resultSet.next()) {
            AccountType director = getType(resultSet);
            types.add(director);
        }

        return !types.isEmpty() ? types : null;
    }

    public static ArrayList<AccountType> findAllTypes() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findAllTypes);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getTypes(resultSet);
    }

    private static AccountType getType(ResultSet resultSet) throws SQLException {
        AccountType type = new AccountType();
        type.setId(resultSet.getInt("ID"));
        type.setType(resultSet.getString("Type"));
        return validate(type);
    }

    public static AccountType findType(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findTypeByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        AccountType type = new AccountType();
        while (resultSet.next()) type = getType(resultSet);
        return validate(type);
    }

    public static AccountType findType(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findTypeByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        AccountType type = new AccountType();
        while (resultSet.next()) type = getType(resultSet);
        return validate(type);
    }

    public static int deleteType(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteTypeByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int updateType(int id, String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateType);
        preparedStatement.setString(1, name);
        preparedStatement.setInt(2, id);
        return preparedStatement.executeUpdate();
    }

    public static int deleteType(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteTypeByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        AccountType type = findType(2);
        if (!type.getType().equals("ADMIN")) {
            error(testNumber, type.toString(), "type ADMIN");
            return false;
        }

        testNumber++;
        type = findType("USER");
        if (type.getId() != 1) {
            error(testNumber, type.toString(), null);
            return false;
        }

        testNumber++;
        type = findType(30);
        if (type != null) {
            error(testNumber, type.toString(), null);
            return false;
        }

        testNumber++;
        ArrayList<AccountType> types = findAllTypes();
        if (types.size() != 2) {
            error(testNumber, "[...] size: " + types.size(), "2");
            return false;
        }

        String mod = UUID.randomUUID().toString();

        testNumber++;
        int i = insertType(mod);
        if (i != 1) {
            error(testNumber, "CREATE", "Failed to create a type");
            return false;
        }

        testNumber++;
        i = deleteType(mod);
        if (i != 1) {
            error(testNumber, "DELETE", "Failed to delete a type by name");
            return false;
        }

        testNumber++;
        insertType(mod);
        i = deleteType(findType(mod).getId());
        if (i != 1) {
            error(testNumber, "DELETE", "Failed to delete a type by id");
            return false;
        }

        testNumber++;
        insertType(mod);
        int modId = findType(mod).getId();
        i = updateType(modId, "Moderator");
        if (i != 1) {
            error(testNumber, "UPDATE", "Failed to delete a type by id");
            return false;
        }
        deleteType(modId);

        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
