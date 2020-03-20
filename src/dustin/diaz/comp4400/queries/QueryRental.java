package dustin.diaz.comp4400.queries;

public abstract class QueryRental {

    //SELECT rentals
    public static final String allRentals = "SELECT * FROM " + Tables.RENTAL;

    //INSERT rental
    public static final String insertRental = "INSERT INTO " + Tables.RENTAL + " (CustomerID, MovieID, RentedOn, Media) VALUES (?, ?, ?, ?)";

}
