package dustin.diaz.comp4400.model;

import java.sql.Date;

public class Rental {
    private int id;
    private int customerId;
    private int movieId;
    private Date rentedOn;
    private String media;
    private Date returnedOn;
    private boolean returned;
    private int totalDays;
    private float totalCost;

    public Rental() {
    }

    public Rental(int id, int customerId, int movieId, Date rentedOn,
                  String media, Date returnedOn, boolean returned,
                  int totalDays, float totalCost) {
        this.id = id;
        this.customerId = customerId;
        this.movieId = movieId;
        this.rentedOn = rentedOn;
        this.media = media;
        this.returnedOn = returnedOn;
        this.returned = returned;
        this.totalDays = totalDays;
        this.totalCost = totalCost;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public Date getRentedOn() {
        return rentedOn;
    }

    public void setRentedOn(Date rentedOn) {
        this.rentedOn = rentedOn;
    }

    public String getMedia() {
        return media;
    }

    public void setMedia(String media) {
        this.media = media;
    }

    public Date getReturnedOn() {
        return returnedOn;
    }

    public void setReturnedOn(Date returnedOn) {
        this.returnedOn = returnedOn;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }

    public int getTotalDays() {
        return totalDays;
    }

    public void setTotalDays(int totalDays) {
        this.totalDays = totalDays;
    }

    public float getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(float totalCost) {
        this.totalCost = totalCost;
    }

    @Override
    public String toString() {
        return "Rental{" +
                "id=" + id +
                ", customerId=" + customerId +
                ", movieId=" + movieId +
                ", rentedOn=" + rentedOn +
                ", media='" + media + '\'' +
                ", returnedOn=" + returnedOn +
                ", returned=" + returned +
                ", totalDays=" + totalDays +
                ", totalCost=" + totalCost +
                '}';
    }
}

