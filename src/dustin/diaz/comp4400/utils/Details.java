package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.model.child.Medias;

import java.sql.Date;
import java.time.Period;

public abstract class Details {
    public static float dvdPrice = 2.00f;
    public static float bluRayPrice = 3.00f;
    public static float defaultPrice = 2.00f;
    public static int defaultDays = 5;
    public static float fees = 0.10f;

    public static float getPrice(Medias media) {
        if (media.getType().equals("DVD")) {
            return dvdPrice;
        } else if (media.getType().equals("BLU-RAY")) {
            return bluRayPrice;
        } else {
            return defaultPrice;
        }
    }

    public static int inBetween(Date start, Date end) {
        return Period.between(start.toLocalDate(), end.toLocalDate()).getDays();
    }

    public static double round(double x, double roundValue) {
        return Math.round(x * roundValue) / roundValue;
    }
}
