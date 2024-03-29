package dustin.diaz.comp4400.model.parent;

import dustin.diaz.comp4400.model.child.Medias;

import java.sql.Date;

public class Rental {
    private int id;
    private int customerId;
    private Movie movie;
    private Medias media;
    private Date rentedOn;
    private Date returnedOn;
    private boolean returned;
    private boolean held;
    private int totalDays;
    private float totalCost;

    public Rental() {
    }

    public Rental(int id, int customerId, Movie movie, Medias media, Date rentedOn, Date returnedOn, boolean returned,
                  int totalDays, float totalCost) {
        this.id = id;
        this.customerId = customerId;
        this.movie = movie;
        this.media = media;
        this.rentedOn = rentedOn;
        this.returnedOn = returnedOn;
        this.returned = returned;
        this.totalDays = totalDays;
        this.totalCost = totalCost;
        this.held = false;
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

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public Medias getMedia() {
        return media;
    }

    public void setMedia(Medias media) {
        this.media = media;
    }

    public Date getRentedOn() {
        return rentedOn;
    }

    public void setRentedOn(Date rentedOn) {
        this.rentedOn = rentedOn;
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

    public boolean isHeld() {
        return held;
    }

    public void setHeld(boolean held) {
        this.held = held;
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
                ", movie=" + movie +
                ", media=" + media +
                ", rentedOn=" + rentedOn +
                ", returnedOn=" + returnedOn +
                ", returned=" + returned +
                ", held=" + held +
                ", totalDays=" + totalDays +
                ", totalCost=" + totalCost +
                '}';
    }
}

