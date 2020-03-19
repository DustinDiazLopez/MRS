package dustin.diaz.comp4400.queries;

public abstract class QueryRental {
    //SELECT rentals
    public static String allRentals = "SELECT * FROM rental.Rental";

    //INSERT rental
    public static String insertRental = "INSERT INTO rental.Rental (CustomerID, MovieID, RentedOn, Media) VALUES (?, ?, ?, ?)";

}
