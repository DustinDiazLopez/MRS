package dustin.diaz.comp4400.model.tables;

import java.sql.Date;

public class RentalTable {
    private int rentalId;
    private int movieId;
    private int customerId;
    private String customerName;
    private String movieTitle;
    private Date rentedDate;

    public RentalTable() {
    }

    public RentalTable(int rentalId, int movieId, int customerId, String customerName, String movieTitle, Date rentedDate) {
        this.rentalId = rentalId;
        this.movieId = movieId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.movieTitle = movieTitle;
        this.rentedDate = rentedDate;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public Date getRentedDate() {
        return rentedDate;
    }

    public void setRentedDate(Date rentedDate) {
        this.rentedDate = rentedDate;
    }

    @Override
    public String toString() {
        return "RentalTable{" +
                "rentalId=" + rentalId +
                ", movieId=" + movieId +
                ", customerId=" + customerId +
                ", customerName='" + customerName + '\'' +
                ", movieTitle='" + movieTitle + '\'' +
                ", rentedDate=" + rentedDate +
                '}';
    }
}
