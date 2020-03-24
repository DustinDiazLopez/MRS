package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.model.child.Writers;
import dustin.diaz.comp4400.model.connector.MovieWriters;
import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.queries.connectors.QueryMovieWriters;
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
    public static final String writerByID = "SELECT * FROM " + Database.WRITERS + " WHERE ID = ?";
    public static final String writerByName = "SELECT * FROM " + Database.WRITERS + " WHERE Name = ?";

    public static void insertWriter(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertWriter);
        preparedStatement.setString(1, name);
        preparedStatement.executeUpdate();
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

    public static ArrayList<Writers> get(int movieId) throws SQLException {
        ArrayList<MovieWriters> list = QueryMovieWriters.findByMovieID(movieId);
        if (list == null) return null;
        ArrayList<Writers> directors = new ArrayList<>();
        for (MovieWriters md : list) {
            directors.add(findWriter(md.getWriterId()));
        }
        return directors;
    }
}
