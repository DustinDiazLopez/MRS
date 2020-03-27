package dustin.diaz.comp4400.queries.child;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.child.Genres;
import dustin.diaz.comp4400.model.connector.MovieGenres;
import dustin.diaz.comp4400.queries.connectors.QueryMovieGenre;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryGenre {
    //INSERT
    public static final String insertGenre = "INSERT INTO " + DBINFO.GENRE + " (Genre) VALUES (?);";

    //SELECT
    public static final String allGenres = "SELECT * FROM " + DBINFO.GENRE;
    public static final String genreByID = "SELECT * FROM " + DBINFO.GENRE + " WHERE ID = ?";
    public static final String genreByName = "SELECT * FROM " + DBINFO.GENRE + " WHERE Genre = ?";

    public static void insertGenre(String name) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertGenre);
        preparedStatement.setString(1, name);
        preparedStatement.executeUpdate();
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
}
