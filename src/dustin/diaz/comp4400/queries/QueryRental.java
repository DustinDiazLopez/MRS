package dustin.diaz.comp4400.queries;

public abstract class QueryRental {

    //SELECT rentals
    public static final String allRentals = "SELECT * FROM " + Database.RENTAL;

    //INSERT rental
    public static final String insertRental = "INSERT INTO " + Database.RENTAL + " (CustomerID, MovieID, RentedOn, Media) VALUES (?, ?, ?, ?)";

}
