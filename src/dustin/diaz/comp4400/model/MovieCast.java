package dustin.diaz.comp4400.model;

public class MovieCast {
    private int movieId;
    private int castId;

    public MovieCast() {
    }

    public MovieCast(int movieId, int castId) {
        this.movieId = movieId;
        this.castId = castId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getCastId() {
        return castId;
    }

    public void setCastId(int castId) {
        this.castId = castId;
    }

    @Override
    public String toString() {
        return "MovieCast{" +
                "movieId=" + movieId +
                ", castId=" + castId +
                '}';
    }
}
