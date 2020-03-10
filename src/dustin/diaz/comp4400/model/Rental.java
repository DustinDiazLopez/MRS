package dustin.diaz.comp4400.model;

import java.sql.Date;

public class Rental {
    private int id;
    private int customerId;
    private int movieId;
    private Date rentedOn;
    private Date returnedOn;
    private float costPerDay;
    private int totalDays;
    private float totalCost;

    public Rental(int id, int customerId, int movieId, Date rentedOn, Date returnedOn,
                  float costPerDay, int totalDays, float totalCost) {
        this.id = id;
        this.customerId = customerId;
        this.movieId = movieId;
        this.rentedOn = rentedOn;
        this.returnedOn = returnedOn;
        this.costPerDay = costPerDay;
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

    public Date getReturnedOn() {
        return returnedOn;
    }

    public void setReturnedOn(Date returnedOn) {
        this.returnedOn = returnedOn;
    }

    public float getCostPerDay() {
        return costPerDay;
    }

    public void setCostPerDay(float costPerDay) {
        this.costPerDay = costPerDay;
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
                ", returnedOn=" + returnedOn +
                ", costPerDay=" + costPerDay +
                ", totalDays=" + totalDays +
                ", totalCost=" + totalCost +
                '}';
    }
}

