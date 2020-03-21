package dustin.diaz.comp4400.model;

public class MovieRental {
    private int movieId;
    private int rentalId;

    public MovieRental() {
    }

    public MovieRental(int movieId, int rentalId) {
        this.movieId = movieId;
        this.rentalId = rentalId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    @Override
    public String toString() {
        return "MovieRental{" +
                "movieId=" + movieId +
                ", rentalId=" + rentalId +
                '}';
    }
}
