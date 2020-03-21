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
    //INSERT
    public static final String insertType = "INSERT INTO " + Database.MEDIA + " (Media) VALUES (?)";

    //SELECT
    public static final String findTypeByID = "SELECT * FROM " + Database.MEDIA + " WHERE ID = ?";
    public static final String findTypeByName = "SELECT * FROM " + Database.MEDIA + " WHERE Media = ?";
    public static final String findAllTypes = "SELECT * FROM " + Database.MEDIA + " ORDER BY ID ASC";

    //UPDATE It uses an enum any value not in the enum will not be a accepted
    //public static final String updateType = "UPDATE " + Database.MEDIA + " SET Media = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteTypeByName = "DELETE FROM " + Database.MEDIA + " WHERE Media = ?";
    public static final String deleteTypeByID = "DELETE FROM " + Database.MEDIA + " WHERE ID = ?";

    public static int insertMedia(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertType);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

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

    public static int deleteMedia(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteTypeByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int deleteMedia(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteTypeByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        Medias media = findMedia(2);
        if (!media.getType().equals("BLU-RAY")) {
            error(testNumber, media.toString(), "media BLU-RAY");
            return false;
        }

        testNumber++;
        media = findMedia("DVD");
        if (media.getId() != 1) {
            error(testNumber, media.toString(), null);
            return false;
        }

        testNumber++;
        media = findMedia(30);
        if (media != null) {
            error(testNumber, media.toString(), null);
            return false;
        }

        testNumber++;
        ArrayList<Medias> types = findAllMedias();
        if (types.size() != 2) {
            error(testNumber, "[...] size: " + types.size(), "2");
            return false;
        }

        String mod = UUID.randomUUID().toString();

        testNumber++;
        try {
            insertMedia(mod);
            error(testNumber, "INSERT", "Inserted a value not in range [DVD, BLU-RAY]");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            int i = deleteMedia("BLU-RAY");
            if (i != 1) {
                error(testNumber, "DELETE", "Deleted a parent row");
                return false;
            }
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            int i = deleteMedia(findMedia("BLU-RAY").getId());
            if (i != 1) {
                error(testNumber, "DELETE", "Deleted a parent row");
                return false;
            }
        } catch (Exception ignored) {
        }

        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
