package dustin.diaz.comp4400.model.tables;

public class RentalHistoryTable {
    private int id;
    private String rentedOn;
    private String media;
    private String cost;

    public RentalHistoryTable() {
    }

    public RentalHistoryTable(int id, String rentedOn, String media, String cost) {
        this.id = id;
        this.rentedOn = rentedOn;
        this.media = media;
        this.cost = cost;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRentedOn() {
        return rentedOn;
    }

    public void setRentedOn(String rentedOn) {
        this.rentedOn = rentedOn;
    }

    public String getMedia() {
        return media;
    }

    public void setMedia(String media) {
        this.media = media;
    }

    public String getCost() {
        return cost;
    }

    public void setCost(String cost) {
        this.cost = cost;
    }

    @Override
    public String toString() {
        return "RentalHistoryTable{" +
                "id=" + id +
                ", rentedOn='" + rentedOn + '\'' +
                ", media='" + media + '\'' +
                ", cost='" + cost + '\'' +
                '}';
    }
}
