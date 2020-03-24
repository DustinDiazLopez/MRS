package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.model.child.Medias;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryMedias {
    //SELECT
    public static final String findTypeByID = "SELECT * FROM " + Database.MEDIA + " WHERE ID = ?";
    public static final String findTypeByName = "SELECT * FROM " + Database.MEDIA + " WHERE Media = ?";
    public static final String findAllTypes = "SELECT * FROM " + Database.MEDIA + " ORDER BY ID ASC";

    private static Medias validate(Medias user) {
        if (user == null) return null;
        else return user.getId() != 0 ? user : null;
    }

    private static ArrayList<Medias> getMedias(ResultSet resultSet) throws SQLException {
        ArrayList<Medias> types = new ArrayList<>();

        while (resultSet.next()) {
            Medias director = getMedia(resultSet);
            types.add(director);
        }

        return !types.isEmpty() ? types : null;
    }

    public static ArrayList<Medias> findAllMedias() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findAllTypes);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getMedias(resultSet);
    }

    private static Medias getMedia(ResultSet resultSet) throws SQLException {
        Medias type = new Medias();
        type.setId(resultSet.getInt("ID"));
        type.setType(resultSet.getString("Media"));
        return validate(type);
    }

    public static Medias findMedia(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findTypeByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Medias type = new Medias();
        while (resultSet.next()) type = getMedia(resultSet);
        return validate(type);
    }

    public static Medias findMedia(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(findTypeByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        Medias type = new Medias();
        while (resultSet.next()) type = getMedia(resultSet);
        return validate(type);
    }
}
