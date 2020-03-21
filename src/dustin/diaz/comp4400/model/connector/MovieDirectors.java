package dustin.diaz.comp4400.model.connector;

public class MovieDirectors {
    private int movieId;
    private int directorId;

    public MovieDirectors() {
    }

    public MovieDirectors(int movieId, int directorId) {
        this.movieId = movieId;
        this.directorId = directorId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getDirectorId() {
        return directorId;
    }

    public void setDirectorId(int directorId) {
        this.directorId = directorId;
    }

    @Override
    public String toString() {
        return "MovieDirectors{" +
                "movieId=" + movieId +
                ", directorId=" + directorId +
                '}';
    }
}
