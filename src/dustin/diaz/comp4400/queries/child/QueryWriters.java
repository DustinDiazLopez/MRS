package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.model.child.Writers;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryWriters {
    //INSERT
    public static final String insertWriter = "INSERT INTO " + Database.WRITERS + " (Name) VALUES (?);";

    //SELECT
    public static final String allWriters = "SELECT * FROM " + Database.WRITERS;
    public static final String writerByID = "SELECT * FROM " + Database.WRITERS + " WHERE ID = ?";
    public static final String writerByName = "SELECT * FROM " + Database.WRITERS + " WHERE Name = ?";

    //UPDATE
    public static final String updateWriterByID = "UPDATE " + Database.WRITERS + " SET Name = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteWriterByID = "DELETE FROM " + Database.WRITERS + " WHERE ID = ?";
    public static final String deleteWriterByName = "DELETE FROM " + Database.WRITERS + " WHERE Name = ?";

    public static int insertWriter(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertWriter);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    private static Writers getWriter(ResultSet resultSet) throws SQLException {
        Writers director = new Writers();
        director.setId(resultSet.getInt("ID"));
        director.setName(resultSet.getString("Name"));
        return validate(director);
    }

    private static Writers validate(Writers director) {
        if (director == null) return null;
        else return director.getId() != 0 ? director : null;
    }

    private static ArrayList<Writers> getWriters(ResultSet resultSet) throws SQLException {
        ArrayList<Writers> directors = new ArrayList<>();

        while (resultSet.next()) {
            Writers director = getWriter(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<Writers> findAllWriters() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allWriters);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getWriters(resultSet);
    }

    public static Writers findWriter(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(writerByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        Writers director = new Writers();
        while (resultSet.next()) director = getWriter(resultSet);
        return validate(director);
    }

    public static Writers findWriter(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(writerByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Writers director = new Writers();
        while (resultSet.next()) director = getWriter(resultSet);
        return validate(director);
    }

    //Duplicate entry throw
    public static int updateWriter(int id, String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateWriterByID);
        int i = 1;
        preparedStatement.setString(i, name);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int deleteWriter(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteWriterByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int deleteWriter(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteWriterByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        String name = "Billy Ray";
        Writers writer = findWriter(2);
        if (!writer.getName().equals(name)) {
            error(testNumber, writer.toString(), "name " + name);
            return false;
        }

        testNumber++;
        writer = findWriter("Dustin Diaz");
        if (!(writer == null)) {
            error(testNumber, writer.toString(), null);
            return false;
        }

        testNumber++;
        int id = 9;
        writer = findWriter("Jason Keller");
        if (!(writer.getId() == id)) {
            error(testNumber, writer.toString(), "id " + id);
            return false;
        }

        ArrayList<Writers> list = findAllWriters();
        testNumber++;
        if (list.size() != 31) {
            //list.forEach(System.out::println);
            error(testNumber, "[...] size: " + list.size(), "arr of size 31");
            return false;
        }

        testNumber++;
        if (updateWriter(writer.getId(), writer.getName() + "updated") != 1) {
            error(testNumber, writer.toString(), "Could not update");
            return false;
        }

        testNumber++;
        if (updateWriter(writer.getId(), writer.getName()) != 1) {
            error(testNumber, writer.toString(), "Could not update");
            return false;
        }

        String test = "Scott Silver";
        testNumber++;
        try {
            updateWriter(writer.getId(), test);
            error(testNumber, "Updated", "Updated an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            insertWriter(test);
            error(testNumber, "Created", "Created an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        String hello = UUID.randomUUID().toString();
        try {
            insertWriter(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }
        testNumber++;
        try {
            deleteWriter(hello);
        } catch (Exception e) {
            error(testNumber, "Delete", "\n\tCould not delete by name: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        testNumber++;

        try {
            insertWriter(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        writer = findWriter(hello);

        try {
            deleteWriter(writer.getId());
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
