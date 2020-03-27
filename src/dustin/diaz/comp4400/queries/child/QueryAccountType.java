package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.child.AccountType;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryAccountType {
    //SELECT
    public static final String findTypeByID = "SELECT * FROM " + DBINFO.ACCOUNT_TYPE + " WHERE ID = ?";
    public static final String findTypeByName = "SELECT * FROM " + DBINFO.ACCOUNT_TYPE + " WHERE Type = ?";
    public static final String findAllTypes = "SELECT * FROM " + DBINFO.ACCOUNT_TYPE + " ORDER BY ID ASC";

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
}
