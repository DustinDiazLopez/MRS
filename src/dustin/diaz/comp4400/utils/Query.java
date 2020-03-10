package dustin.diaz.comp4400.utils;

public abstract class Query {
    public static String allUsers = "SELECT * FROM rental.User";
    public static String userByID = "SELECT * FROM rental.User WHERE ID = ?";
}
