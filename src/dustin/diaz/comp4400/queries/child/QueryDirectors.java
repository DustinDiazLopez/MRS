package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.child.Directors;
import dustin.diaz.comp4400.model.connector.MovieDirectors;
import dustin.diaz.comp4400.queries.connectors.QueryMovieDirector;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryDirectors {
    //INSERT
    public static final String insertDirector = "INSERT INTO " + DBINFO.DIRECTORS + " (Name) VALUES (?);";

    //SELECT
    public static final String directorByID = "SELECT * FROM " + DBINFO.DIRECTORS + " WHERE ID = ?";
    public static final String directorByName = "SELECT * FROM " + DBINFO.DIRECTORS + " WHERE Name = ?";

    public static void insertDirector(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertDirector);
        preparedStatement.setString(1, name);
        preparedStatement.executeUpdate();
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

    public static ArrayList<Directors> get(int movieId) throws SQLException {
        ArrayList<MovieDirectors> list = QueryMovieDirector.findByMovieID(movieId);
        if (list == null) return null;
        ArrayList<Directors> directors = new ArrayList<>();
        for (MovieDirectors md : list) {
            directors.add(findDirector(md.getDirectorId()));
        }
        return directors;
    }
}
