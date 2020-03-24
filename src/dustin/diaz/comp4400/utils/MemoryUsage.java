package dustin.diaz.comp4400.utils;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class MemoryUsage {
    private static final DecimalFormat ROUNDED_DOUBLE_DECIMAL;
    private static final String MIB = "MiB";

    static {
        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols(Locale.ENGLISH);
        otherSymbols.setDecimalSeparator('.');
        otherSymbols.setGroupingSeparator(',');
        ROUNDED_DOUBLE_DECIMAL = new DecimalFormat("####0.00", otherSymbols);
        ROUNDED_DOUBLE_DECIMAL.setGroupingUsed(false);
    }

    public static String used() {
        return getPercentageUsedFormatted() + " (" + getUsedMemoryInMiB() + ")";
    }

    private static String getUsedMemoryInMiB() {
        double usedMiB = bytesToMiB(getUsedMemory());
        return String.format("%s %s", ROUNDED_DOUBLE_DECIMAL.format(usedMiB), MIB);
    }

    private static double getPercentageUsed() {
        return ((double) getUsedMemory() / getMaxMemory()) * 100;
    }

    private static String getPercentageUsedFormatted() {
        double usedPercentage = getPercentageUsed();
        return ROUNDED_DOUBLE_DECIMAL.format(usedPercentage) + "%";
    }

    private static long getMaxMemory() {
        return Runtime.getRuntime().maxMemory();
    }

    private static long getUsedMemory() {
        return getMaxMemory() - getFreeMemory();
    }

    private static long getFreeMemory() {
        return Runtime.getRuntime().freeMemory();
    }

    private static double bytesToMiB(long totalMemory) {
        return totalMemory / 1.049e+6;
    }
}
