package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.model.Directors;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryDirectors {
    //INSERT
    public static final String insertDirector = "INSERT INTO " + Database.DIRECTORS + " (Name) VALUES (?);";

    //SELECT
    public static final String allDirectors = "SELECT * FROM " + Database.DIRECTORS;
    public static final String directorByID = "SELECT * FROM " + Database.DIRECTORS + " WHERE ID = ?";
    public static final String directorByName = "SELECT * FROM " + Database.DIRECTORS + " WHERE Name = ?";

    //UPDATE
    public static final String updateDirectorByID = "UPDATE " + Database.DIRECTORS + " SET Name = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteDirectorByID = "DELETE FROM " + Database.DIRECTORS + " WHERE ID = ?";
    public static final String deleteDirectorByName = "DELETE FROM " + Database.DIRECTORS + " WHERE Name = ?";

    public static int insertDirector(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertDirector);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    private static Directors getDirector(ResultSet resultSet) throws SQLException {
        Directors director = new Directors();
        director.setId(resultSet.getInt("ID"));
        director.setName(resultSet.getString("Name"));
        return validate(director);
    }

    private static Directors validate(Directors director) {
        if (director == null) return null;
        else return director.getId() != 0 ? director : null;
    }

    private static ArrayList<Directors> getDirectors(ResultSet resultSet) throws SQLException {
        ArrayList<Directors> directors = new ArrayList<>();

        while (resultSet.next()) {
            Directors director = getDirector(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<Directors> findAllDirectors() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allDirectors);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getDirectors(resultSet);
    }

    public static Directors findDirector(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(directorByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        Directors director = new Directors();
        while (resultSet.next()) director = getDirector(resultSet);
        return validate(director);
    }

    public static Directors findDirector(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(directorByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Directors director = new Directors();
        while (resultSet.next()) director = getDirector(resultSet);
        return validate(director);
    }

    //Duplicate entry throw
    public static int updateDirector(int id, String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateDirectorByID);
        int i = 1;
        preparedStatement.setString(i, name);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int deleteDirector(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteDirectorByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int deleteDirector(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteDirectorByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        String name = "Chris Buck";
        Directors director = findDirector(2);
        if (!director.getName().equals(name)) {
            error(testNumber, director.toString(), "name " + name);
            return false;
        }

        testNumber++;
        director = findDirector("Dustin Diaz");
        if (!(director == null)) {
            error(testNumber, director.toString(), null);
            return false;
        }

        testNumber++;
        int id = 9;
        director = findDirector("Jay Roach");
        if (!(director.getId() == id)) {
            error(testNumber, director.toString(), "id " + id);
            return false;
        }

        ArrayList<Directors> list = findAllDirectors();
        testNumber++;
        if (list.size() != 18) {
            //list.forEach(System.out::println);
            error(testNumber, "[...] size: " + list.size(), "arr of size 18");
            return false;
        }

        testNumber++;
        if (updateDirector(director.getId(), director.getName() + "updated") != 1) {
            error(testNumber, director.toString(), "Could not update");
            return false;
        }

        testNumber++;
        if (updateDirector(director.getId(), director.getName()) != 1) {
            error(testNumber, director.toString(), "Could not update");
            return false;
        }

        String test = "Jennifer Lee";
        testNumber++;
        try {
            updateDirector(director.getId(), test);
            error(testNumber, "Updated", "Updated an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            insertDirector(test);
            error(testNumber, "Created", "Created an existing value");
            return false;
        } catch (Exception ignored) {
        }
        testNumber++;
        String hello = UUID.randomUUID().toString();
        try {
            insertDirector(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }
        testNumber++;
        try {
            deleteDirector(hello);
        } catch (Exception e) {
            error(testNumber, "Delete", "\n\tCould not delete by name: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        try {
            insertDirector(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        testNumber++;
        director = findDirector(hello);
        try {
            deleteDirector(director.getId());
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
