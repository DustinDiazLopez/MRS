package dustin.diaz.comp4400.utils;

import java.sql.Date;
import java.time.Period;

public class Utils {
    public static String[] allGenres = "Action,Adventure,Animation,Comedy,Crime,Drama,Documentary,Epic,Fantasy,Historical,Historical fiction,Horror,Magical realism,Mystery,Paranoid fiction,Philosophical,Political,Romance,Saga,Satire,Science fiction,Social,Speculative,Thriller,Urban,Western".split(",");

    public static String error = "-fx-focus-color: #d35244;\n" +
            "-fx-faint-focus-color: #d3524422;\n" +
            "\n" +
            "    -fx-highlight-fill: -fx-accent;\n" +
            "    -fx-highlight-text-fill: white;\n" +
            "    -fx-background-color:\n" +
            "        -fx-focus-color,\n" +
            "        -fx-control-inner-background,\n" +
            "        -fx-faint-focus-color,\n" +
            "        linear-gradient(from 0px 0px to 0px 5px, derive(-fx-control-inner-background, -9%), -fx-control-inner-background);\n" +
            "    -fx-background-insets: -0.2, 1, -1.4, 3;\n" +
            "    -fx-background-radius: 3, 2, 4, 0;\n" +
            "    -fx-prompt-text-fill: transparent;";

    public static String homeStyle = "-fx-padding: 10;" +
            "-fx-border-style: solid inside;" +
            "-fx-border-width: 2;" +
            "-fx-border-insets: 5;" +
            "-fx-border-radius: 5;" +
            "-fx-border-color: gray;";

    public static String homeStyleHover = "-fx-padding: 10;" +
            "-fx-border-style: solid inside;" +
            "-fx-border-width: 2;" +
            "-fx-border-insets: 5;" +
            "-fx-border-radius: 5;" +
            "-fx-border-color: blue;";

    public static int inBetween(Date start, Date end) {
        return Period.between(start.toLocalDate(), end.toLocalDate()).getDays();
    }

}
