package dustin.diaz.comp4400.utils;

import java.time.LocalDate;
import java.time.Period;

public class Utils {
    public static int inBetween(LocalDate start, LocalDate end) {
        return Period.between(start, end).getDays();
    }
}
