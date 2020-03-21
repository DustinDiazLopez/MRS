package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.model.child.Genres;
import dustin.diaz.comp4400.model.connector.MovieGenres;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.connectors.QueryMovieGenre;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

public abstract class QueryGenre {
    //INSERT
    public static final String insertGenre = "INSERT INTO " + Database.GENRE + " (Genre) VALUES (?);";

    //SELECT
    public static final String allGenres = "SELECT * FROM " + Database.GENRE;
    public static final String genreByID = "SELECT * FROM " + Database.GENRE + " WHERE ID = ?";
    public static final String genreByName = "SELECT * FROM " + Database.GENRE + " WHERE Genre = ?";

    //UPDATE
    public static final String updateGenreByID = "UPDATE " + Database.GENRE + " SET Genre = ? WHERE ID = ?;";

    //DELETE
    public static final String deleteGenreByID = "DELETE FROM " + Database.GENRE + " WHERE ID = ?";
    public static final String deleteGenreByName = "DELETE FROM " + Database.GENRE + " WHERE Genre = ?";

    public static int insertGenre(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertGenre);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    private static Genres getGenre(ResultSet resultSet) throws SQLException {
        Genres director = new Genres();
        director.setId(resultSet.getInt("ID"));
        director.setGenre(resultSet.getString("Genre"));
        return validate(director);
    }

    private static Genres validate(Genres director) {
        if (director == null) return null;
        else return director.getId() != 0 ? director : null;
    }

    private static ArrayList<Genres> getGenres(ResultSet resultSet) throws SQLException {
        ArrayList<Genres> directors = new ArrayList<>();

        while (resultSet.next()) {
            Genres director = getGenre(resultSet);
            directors.add(director);
        }

        return !directors.isEmpty() ? directors : null;
    }

    public static ArrayList<Genres> findAllGenres() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(allGenres);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getGenres(resultSet);
    }

    public static Genres findGenre(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(genreByName);
        preparedStatement.setString(1, name);
        ResultSet resultSet = preparedStatement.executeQuery();
        Genres director = new Genres();
        while (resultSet.next()) director = getGenre(resultSet);
        return validate(director);
    }

    public static Genres findGenre(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(genreByID);
        preparedStatement.setInt(1, id);
        ResultSet resultSet = preparedStatement.executeQuery();
        Genres director = new Genres();
        while (resultSet.next()) director = getGenre(resultSet);
        return validate(director);
    }

    public static ArrayList<Genres> get(int movieId) throws SQLException {
        ArrayList<MovieGenres> list = QueryMovieGenre.findByMovieID(movieId);
        if (list == null) return null;
        ArrayList<Genres> directors = new ArrayList<>();
        for (MovieGenres md : list) {
            directors.add(findGenre(md.getGenreId()));
        }
        return directors;
    }

    //Duplicate entry throw
    public static int updateGenre(int id, String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateGenreByID);
        int i = 1;
        preparedStatement.setString(i, name);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int deleteGenre(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteGenreByName);
        preparedStatement.setString(1, name);
        return preparedStatement.executeUpdate();
    }

    public static int deleteGenre(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteGenreByID);
        preparedStatement.setInt(1, id);
        return preparedStatement.executeUpdate();
    }

    public static boolean test() throws SQLException {
        int testNumber = 1;
        String name = "Adventure";
        Genres genre = findGenre(2);
        if (!genre.getGenre().equals(name)) {
            error(testNumber, genre.toString(), "genre " + name);
            return false;
        }

        testNumber++;
        genre = findGenre("Dustin Diaz");
        if (!(genre == null)) {
            error(testNumber, genre.toString(), null);
            return false;
        }

        testNumber++;
        int id = 9;
        genre = findGenre("Romance");
        if (!(genre.getId() == id)) {
            error(testNumber, genre.toString(), "id " + id);
            return false;
        }

        ArrayList<Genres> list = findAllGenres();
        testNumber++;
        if (list.size() != 12) {
            //list.forEach(System.out::println);
            error(testNumber, "[...] size: " + list.size(), "arr of size 12");
            return false;
        }

        testNumber++;
        if (updateGenre(genre.getId(), genre.getGenre() + "updated") != 1) {
            error(testNumber, genre.toString(), "Could not update");
            return false;
        }

        testNumber++;
        if (updateGenre(genre.getId(), genre.getGenre()) != 1) {
            error(testNumber, genre.toString(), "Could not update");
            return false;
        }

        String test = "Sport";
        testNumber++;
        try {
            updateGenre(genre.getId(), test);
            error(testNumber, "Updated", "Updated an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        try {
            insertGenre(test);
            error(testNumber, "Created", "Created an existing value");
            return false;
        } catch (Exception ignored) {
        }

        testNumber++;
        String hello = UUID.randomUUID().toString();
        try {
            insertGenre(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }
        testNumber++;
        try {
            deleteGenre(hello);
        } catch (Exception e) {
            error(testNumber, "Delete", "\n\tCould not delete by name: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        testNumber++;

        try {
            insertGenre(hello);
        } catch (Exception e) {
            error(testNumber, "Insert", "\n\tCould not create: \n\t\t" + e.getLocalizedMessage() + "\n");
            return false;
        }

        genre = findGenre(hello);

        try {
            deleteGenre(genre.getId());
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
