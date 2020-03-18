package dustin.diaz.comp4400.utils;

import java.sql.Date;
import java.time.Period;

public class Utils {
    public static String[] allGenres = "Action,Adventure,Animation,Comedy,Crime,Drama,Documentary,Epic,Fantasy,Historical,Historical fiction,Horror,Magical realism,Mystery,Paranoid fiction,Philosophical,Political,Romance,Saga,Satire,Science fiction,Social,Speculative,Thriller,Urban,Western".split(",");

    public static int inBetween(Date start, Date end) {
        return Period.between(start.toLocalDate(), end.toLocalDate()).getDays();
    }
}
