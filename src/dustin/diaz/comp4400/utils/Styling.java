package dustin.diaz.comp4400.utils;

public class Styling {
    public static String error =
            "-fx-focus-color: #d35244;\n" +
                    "-fx-faint-focus-color: #d3524422;\n" +
                    "-fx-highlight-fill: -fx-accent;\n" +
                    "-fx-highlight-text-fill: white;\n" +
                    "-fx-background-color:\n" +
                    "   -fx-focus-color,\n" +
                    "   -fx-control-inner-background,\n" +
                    "   -fx-faint-focus-color,\n" +
                    "   linear-gradient(from 0px 0px to 0px 5px, derive(-fx-control-inner-background, -9%), -fx-control-inner-background);\n" +
                    "-fx-background-insets: -0.2, 1, -1.4, 3;\n" +
                    "-fx-background-radius: 3, 2, 4, 0;\n" +
                    "-fx-prompt-text-fill: transparent;";

    public static String homeStyle =
            "-fx-padding: 10;" +
                    "-fx-border-style: solid inside;" +
                    "-fx-border-width: 2;" +
                    "-fx-border-insets: 5;" +
                    "-fx-border-radius: 5;" +
                    "-fx-border-color: gray;";

    public static String homeStyleHover =
            "-fx-padding: 10;" +
                    "-fx-border-style: solid inside;" +
                    "-fx-border-width: 2;" +
                    "-fx-border-insets: 5;" +
                    "-fx-border-radius: 5;" +
                    "-fx-border-color: blue;";

    public static String formatNames(String... strings) {
        StringBuilder builder = new StringBuilder();

        for (String string : strings) {
            String name = capitalize(string);
            if (name.trim().isEmpty()) continue;
            builder.append(name).append(" ");
        }

        return builder.toString().trim();
    }

    public static String capitalize(String string) {
        if (string.trim().isEmpty()) return string;
        String firstChar = String.valueOf(string.charAt(0));
        String name = string.replaceFirst(firstChar, "").toLowerCase();
        return firstChar.toUpperCase() + name;
    }

}
