package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.model.AccountType;
import dustin.diaz.comp4400.model.User;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class QueryAccountType {
    public static String findTypeByID = "SELECT * FROM " + Database.ACCOUNT_TYPE + " WHERE ID = ?";

    private static AccountType validate(AccountType user) {
        if (user == null) return null;
        else return user.getId() != 0 ? user : null;
    }

    private static AccountType getType(ResultSet resultSet) throws SQLException {
        AccountType type = new AccountType();
        type.setId(resultSet.getInt("ID"));
        type.setType(resultSet.getString("Type"));

        return validate(type);
    }

    public static AccountType findTypeByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryAccountType.findTypeByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        AccountType type = new AccountType();
        while (resultSet.next()) type = getType(resultSet);
        return validate(type);
    }

}
