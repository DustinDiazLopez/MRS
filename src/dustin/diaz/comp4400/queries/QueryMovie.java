package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.model.Movie;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;

public abstract class QueryMovie {
    //SELECT movies
    public static final String allMovies = "SELECT * FROM " + Database.MOVIE;
    public static final String movieByID = "SELECT * FROM " + Database.MOVIE + " WHERE ID = ?";

    //INSERT movie
    public static final String insertMovie = "INSERT INTO " + Database.MOVIE + " (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static Movie getMovie(ResultSet resultSet) throws SQLException {
        Movie movie = new Movie();
        movie.setId(resultSet.getInt("ID"));
        movie.setTitle(resultSet.getString("Title"));
        movie.setDirectors(resultSet.getString("Directors").split(","));
        movie.setWriters(resultSet.getString("Writers").split(","));
        movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
        movie.setGenres(resultSet.getString("Genre").split(","));
        movie.setRunTime(resultSet.getString("RunTime"));
        movie.setRated(resultSet.getString("Rated"));
        movie.setCast(resultSet.getString("Cast").split(","));
        movie.setRating(resultSet.getString("Ratings"));
        movie.setFileName(resultSet.getString("Filename"));
        return movie.getId() != 0 ? movie : null;
    }

    private static ArrayList<Movie> getMovies(ResultSet resultSet) throws SQLException {
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            Movie movie = getMovie(resultSet);
            movies.add(movie);
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static HashSet<String> availableGenres() throws SQLException {
        HashSet<String> set = new HashSet<>();
        QueryMovie.findAllMovies().forEach(e -> set.addAll(Arrays.asList(e.getGenres())));
        return !set.isEmpty() ? set : null;
    }

    public static ArrayList<Movie> findAllMovies() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.allMovies);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getMovies(resultSet);
    }

    public static ArrayList<Movie> findMoviesByGenre(String genre) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.allMovies);

        ResultSet resultSet = preparedStatement.executeQuery();
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            String g = resultSet.getString("Genre");
            if (g.toLowerCase().contains(genre.toLowerCase())) movies.add(getMovie(resultSet));
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static Movie findMovieByID(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByID);
        preparedStatement.setInt(1, id);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();
        while (resultSet.next()) movie = getMovie(resultSet);
        return movie;
    }
}
