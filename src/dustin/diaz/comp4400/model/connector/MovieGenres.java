package dustin.diaz.comp4400.model.connector;

public class MovieGenres {
    private int movieId;
    private int genreId;

    public MovieGenres() {
    }

    public MovieGenres(int movieId, int genreId) {
        this.movieId = movieId;
        this.genreId = genreId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    @Override
    public String toString() {
        return "MovieGenres{" +
                "movieId=" + movieId +
                ", genreId=" + genreId +
                '}';
    }
}
