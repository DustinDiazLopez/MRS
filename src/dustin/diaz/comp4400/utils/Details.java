package dustin.diaz.comp4400.utils;

import java.sql.Date;
import java.time.Period;
import java.util.HashSet;

public abstract class Details {
    public static float dvdPrice = 2.00f;
    public static float bluRayPrice = 3.00f;
    public static float defaultPrice = 2.00f;

    public static HashSet<String> genres;

    public static int inBetween(Date start, Date end) {
        return Period.between(start.toLocalDate(), end.toLocalDate()).getDays();
    }
}
