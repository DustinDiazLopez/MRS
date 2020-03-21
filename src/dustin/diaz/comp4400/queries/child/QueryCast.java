package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.model.child.Cast;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryCast {
    //INSERT
    public static final String insertCast = "INSERT INTO " + Database.CAST + " (Name) VALUES (?);";

    //SELECT
    public static final String allCast = "SELECT * FROM " + Database.CAST;
    public static final String castByID = "SELECT * FROM " + Database.CAST + " WHERE ID = ?";
    public static final String castByName = "SELECT * FROM " + Database.CAST + " WHERE Name = ?";

    //UPDATE
    public static final String updateCastByID = "UPDATE " + Database.CAST + " SET Name = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteCastByID = "DELETE FROM " + Database.CAST + " WHERE ID = ?";
    public static final String deleteCastByName = "DELETE FROM " + Database.CAST + " WHERE Name = ?";

    public static int insertCast(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertCast);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    private static Cast getCast(ResultSet resultSet) throws SQLException {
        Cast director = new Cast();
        director.setId(resultSet.getInt("ID"));
        director.setName(resultSet.getString("Name"));
        return validate(director);
    }

    private static Cast validate(Cast director) {
        if (director == null) return null;
        else return director.getId() != 0 ? director : null;
    }

    private static ArrayList<Cast> getCasts(ResultSet resultSet) throws SQLException {
        ArrayList<Cast> directors = new ArrayList<>();

        while (resultSet.next()) {
            Cast director = getCast(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<Cast> findAllCast() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allCast);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getCasts(resultSet);
    }

    public static Cast findCast(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(castByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        Cast director = new Cast();
        while (resultSet.next()) director = getCast(resultSet);
        return validate(director);
    }

    public static Cast findCast(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(castByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Cast director = new Cast();
        while (resultSet.next()) director = getCast(resultSet);
        return validate(director);
    }

    //Duplicate entry throw
    public static int updateCast(int id, String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateCastByID);
        int i = 1;
        preparedStatement.setString(i, name);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int deleteCast(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteCastByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int deleteCast(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteCastByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        String name = "Al Pacino";
        Cast cast = findCast(2);
        if (!cast.getName().equals(name)) {
            error(testNumber, cast.toString(), "name " + name);
            return false;
        }

        testNumber++;
        cast = findCast("Dustin Diaz");
        if (!(cast == null)) {
            error(testNumber, cast.toString(), null);
            return false;
        }

        testNumber++;
        int id = 9;
        cast = findCast("Arnold Schwarzenegger");
        if (!(cast.getId() == id)) {
            error(testNumber, cast.toString(), "id " + id);
            return false;
        }

        ArrayList<Cast> list = findAllCast();
        testNumber++;
        if (list.size() != 131) {
            //list.forEach(System.out::println);
            error(testNumber, "[...] size: " + list.size(), "arr of size 131");
            return false;
        }

        testNumber++;
        if (updateCast(cast.getId(), cast.getName() + "updated") != 1) {
            error(testNumber, cast.toString(), "Could not update");
            return false;
        }

        testNumber++;
        if (updateCast(cast.getId(), cast.getName()) != 1) {
            error(testNumber, cast.toString(), "Could not update");
            return false;
        }

        String test = "Will Smith";
        testNumber++;
        try {
            updateCast(cast.getId(), test);
            error(testNumber, "Updated", "Updated an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            insertCast(test);
            error(testNumber, "Created", "Created an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        String hello = UUID.randomUUID().toString();
        try {
            insertCast(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }
        testNumber++;
        try {
            deleteCast(hello);
        } catch (Exception e) {
            error(testNumber, "Delete", "\n\tCould not delete by name: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        testNumber++;

        try {
            insertCast(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        cast = findCast(hello);

        try {
            deleteCast(cast.getId());
        } catch (Exception e) {
            error(testNumber, "Delete", "\n\tCould not delete by id: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        return true;
    }

    private static void error(int testNumber, String value, String expected) {
        System.err.println("TEST #" + testNumber + ": " + value + " expected [" + expected + "]");
    }
}
