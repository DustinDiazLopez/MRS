package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.model.parent.Customer;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableView;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;

public class Styling {

    public static double imageFactor = 0.78;

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


    public static void disableEnableVBoxStyle(VBox vBox1, VBox vBox2) {
        vBox1.setStyle(homeStyle);
        vBox2.setStyle(homeStyleHover);
    }

    public static void setStyle(VBox... vBoxes) {
        double opacity = 0.85;


        for (VBox vBox : vBoxes) {
            vBox.setStyle(homeStyle);
            vBox.opacityProperty().setValue(opacity);

            vBox.setOnMouseEntered(e -> {
                vBox.opacityProperty().setValue(1);
                vBox.setStyle(homeStyleHover);
            });

            vBox.setOnMouseExited(e -> {
                vBox.opacityProperty().setValue(opacity);
                vBox.setStyle(homeStyle);
            });
        }
    }

    public static void setTableConst(TableView tableView) {
        tableView.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

    }

    public static double defaultButtonSize = 80;

    public static void setButtonWidth(Button... buttons) {
        for (Button button : buttons) button.setPrefWidth(defaultButtonSize);
    }

    public static void pleaseWaitVBoxStyle(VBox vBox, Label label) {
        vBox.setOnMousePressed(e -> {
            label.setTextFill(Color.RED);
            label.setText("Please wait...");
            vBox.opacityProperty().setValue(1);
        });
    }

    public static String formatNames(Customer c) {
        if (c == null) return null;
        String middle = c.getMiddleName();
        return formatNames(c.getFirstName(), middle == null ? "" : middle, c.getLastName());
    }

    public static String formatNames(String... strings) {
        StringBuilder builder = new StringBuilder();

        for (String string : strings) {
            String name = capitalize(string);
            if (name.trim().isEmpty()) continue;
            builder.append(name).append(" ");
        }

        return builder.toString().trim().replaceAll(" {2}", " ");
    }

    private static String capitalize(String string) {
        if (string.trim().isEmpty()) return string;
        String firstChar = String.valueOf(string.charAt(0));
        String name = string.replaceFirst(firstChar, "").toLowerCase();
        return firstChar.toUpperCase() + name;
    }

}
