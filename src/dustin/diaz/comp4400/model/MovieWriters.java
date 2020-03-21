package dustin.diaz.comp4400.model;

public class MovieWriters {
    private int movieId;
    private int writerId;

    public MovieWriters() {
    }

    public MovieWriters(int movieId, int writerId) {
        this.movieId = movieId;
        this.writerId = writerId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getWriterId() {
        return writerId;
    }

    public void setWriterId(int writerId) {
        this.writerId = writerId;
    }

    @Override
    public String toString() {
        return "MovieWriters{" +
                "movieId=" + movieId +
                ", writerId=" + writerId +
                '}';
    }
}
