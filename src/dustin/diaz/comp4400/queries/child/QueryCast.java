package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.child.Cast;
import dustin.diaz.comp4400.model.connector.MovieCast;
import dustin.diaz.comp4400.queries.connectors.QueryMovieCast;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryCast {
    //INSERT
    public static final String insertCast = "INSERT INTO " + DBINFO.CAST + " (Name) VALUES (?);";

    //SELECT
    public static final String castByID = "SELECT * FROM " + DBINFO.CAST + " WHERE ID = ?";
    public static final String castByName = "SELECT * FROM " + DBINFO.CAST + " WHERE Name = ?";

    public static void insertCast(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertCast);
        preparedStatement.setString(1, name);
        preparedStatement.executeUpdate();
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

    public static ArrayList<Cast> get(int movieId) throws SQLException {
        ArrayList<MovieCast> list = QueryMovieCast.findByMovieID(movieId);
        if (list == null) return null;
        ArrayList<Cast> directors = new ArrayList<>();
        for (MovieCast md : list) {
            directors.add(findCast(md.getCastId()));
        }
        return directors;
    }
}
