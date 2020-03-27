package dustin.diaz.comp4400.queries.parent;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.queries.child.QueryCast;
import dustin.diaz.comp4400.queries.child.QueryDirectors;
import dustin.diaz.comp4400.queries.child.QueryGenre;
import dustin.diaz.comp4400.queries.child.QueryWriters;
import dustin.diaz.comp4400.queries.connectors.*;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public abstract class QueryMovie {
    //INSERT movie
    public static final String insertMovie = "INSERT INTO " + DBINFO.MOVIE + " (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES (?, ?, ?, ?, ?, ?)";

    //SELECT movies
    public static final String allMovies = "SELECT * FROM " + DBINFO.MOVIE;
    public static final String allLimitMovies = "SELECT * FROM " + DBINFO.MOVIE + " LIMIT 10";
    public static final String movieByID = "SELECT * FROM " + DBINFO.MOVIE + " WHERE ID = ?";
    public static final String movieByTitle = "SELECT * FROM " + DBINFO.MOVIE + " WHERE Title = ?";

    //UPDATE
    public static final String updateMovieByID = "UPDATE " + DBINFO.MOVIE + " SET Title = ?, ReleaseDate = ?, RunTime = ?, Rated = ?, Ratings = ?, Filename = ? WHERE ID = ?";

    //DELETE
    public static final String deleteMovieByID = "DELETE FROM " + DBINFO.MOVIE + " WHERE ID = ?";

    public static int insert(String title, Date releaseDate, String runTime, String Rated, String Ratings,
                             String filename) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(insertMovie);
        int i = 1;
        preparedStatement.setString(i, title);
        preparedStatement.setString(++i, releaseDate.toLocalDate().toString());
        preparedStatement.setString(++i, runTime);
        preparedStatement.setString(++i, Rated);
        preparedStatement.setString(++i, Ratings);
        preparedStatement.setString(++i, filename);
        return preparedStatement.executeUpdate();
    }

    public static int update(int id, String title, Date releaseDate, String runTime, String Rated, String Ratings,
                             String filename) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(updateMovieByID);
        int i = 1;
        preparedStatement.setString(i, title);
        preparedStatement.setString(++i, releaseDate.toLocalDate().toString());
        preparedStatement.setString(++i, runTime);
        preparedStatement.setString(++i, Rated);
        preparedStatement.setString(++i, Ratings);
        preparedStatement.setString(++i, filename);
        preparedStatement.setInt(++i, id);
        return preparedStatement.executeUpdate();
    }

    public static int delete(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(deleteMovieByID);
        preparedStatement.setInt(1, id);
        deleteReferences(id);
        return preparedStatement.executeUpdate();
    }

    public static void deleteReferences(int id) throws SQLException {
        System.out.println("Deleted MovieCast Relationships [Count: " + QueryMovieCast.deleteByMovieID(id) + "]");
        System.out.println("Deleted MovieDirectors Relationships [Count: " + QueryMovieDirector.deleteByMovieID(id) + "]");
        System.out.println("Deleted MovieGenres Relationships [Count: " + QueryMovieGenre.deleteByMovieID(id) + "]");
        System.out.println("Deleted MovieWriters Relationships [Count: " + QueryMovieWriters.deleteByMovieID(id) + "]");
        System.out.println("Deleted MovieRental Relationships [Count: " + QueryMovieRental.deleteByMovieID(id) + "]");
    }

    private static Movie getMovie(ResultSet resultSet) throws SQLException {
        Movie movie = new Movie();
        int movieId = resultSet.getInt("ID");
        movie.setId(movieId);
        movie.setTitle(resultSet.getString("Title"));
        movie.setDirectors(QueryDirectors.get(movieId));
        movie.setWriters(QueryWriters.get(movieId));
        movie.setReleaseDate(Date.valueOf(resultSet.getString("ReleaseDate")));
        movie.setGenres(QueryGenre.get(movieId));
        movie.setRunTime(resultSet.getString("RunTime"));
        movie.setRated(resultSet.getString("Rated"));
        movie.setCast(QueryCast.get(movieId));
        movie.setRating(resultSet.getString("Ratings"));
        movie.setFileName(resultSet.getString("Filename"));
        return validate(movie);
    }

    private static ArrayList<Movie> getMovies(ResultSet resultSet) throws SQLException {
        ArrayList<Movie> movies = new ArrayList<>();

        while (resultSet.next()) {
            Movie movie = getMovie(resultSet);
            movies.add(movie);
        }

        return !movies.isEmpty() ? movies : null;
    }

    public static ArrayList<Movie> findAllMovies() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.allMovies);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getMovies(resultSet);
    }

    public static ArrayList<Movie> findAllLimit() throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.allLimitMovies);
        ResultSet resultSet = preparedStatement.executeQuery();
        return getMovies(resultSet);
    }

    public static Movie findMovie(int id) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByID);
        preparedStatement.setInt(1, id);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();
        while (resultSet.next()) movie = getMovie(resultSet);
        return validate(movie);
    }


    public static Movie findMovie(String title) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByTitle);
        preparedStatement.setString(1, title);

        ResultSet resultSet = preparedStatement.executeQuery();
        Movie movie = new Movie();
        while (resultSet.next()) movie = getMovie(resultSet);
        return validate(movie);
    }

    public static int findMovieID(String title) throws SQLException {
        PreparedStatement preparedStatement = Computer.connection.prepareStatement(QueryMovie.movieByTitle);
        preparedStatement.setString(1, title);
        ResultSet resultSet = preparedStatement.executeQuery();
        int id = 0;
        while (resultSet.next()) id = resultSet.getInt("ID");
        return id;
    }

    private static Movie validate(Movie movie) {
        if (movie == null) return null;
        return movie.getId() != 0 ? movie : null;
    }
}
