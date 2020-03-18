package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.utils.Utils;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.io.File;

public class NewRental {

    private static int[] value;

    public static int[] display() {
        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("New Rental");
        window.setMinHeight(200);
        window.setMinWidth(450);
        window.getIcons().add(new Image(new File("src/Images/icons/favicon/android-chrome-512x512.png").toURI().toString()));

        Label label = new Label("Enter movie ID:     ");
        TextField textField = new TextField();
        textField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d*")) {
                textField.setText(newValue.replaceAll("[^\\d]", ""));
            }
        });

        Label label2 = new Label("Enter customer ID:");
        TextField textField2 = new TextField();
        textField2.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d*")) {
                textField2.setText(newValue.replaceAll("[^\\d]", ""));
            }
        });

        Label star = new Label("*");
        star.setTextFill(Color.RED);
        star.setVisible(false);

        Label star2 = new Label("*");
        star2.setTextFill(Color.RED);
        star2.setVisible(false);

        Label man = new Label("* Mandatory Field");
        man.setTextFill(Color.RED);
        man.setVisible(false);

        Button okButton = new Button("OK");
        Button cancelButton = new Button("Cancel");

        okButton.setOnAction(e -> {
            star.setVisible(false);
            star2.setVisible(false);
            man.setVisible(false);
            textField.setStyle("");
            textField2.setStyle("");

            if (!textField.getText().trim().isEmpty() && !textField2.getText().trim().isEmpty()) {
                try {
                    value = new int[]{
                            Integer.parseInt(textField.getText()),
                            Integer.parseInt(textField2.getText())
                    };

                    window.close();
                } catch (Exception ignored) {
                    value = null;
                }
            } else {
                if (textField.getText().trim().isEmpty()) {
                    star.setVisible(true);
                    textField.setStyle(Utils.error);
                }

                if (textField2.getText().trim().isEmpty()) {
                    star2.setVisible(true);
                    textField2.setStyle(Utils.error);
                }

                man.setVisible(true);
            }
        });

        cancelButton.setOnAction(e -> {
            value = null;
            window.close();
        });

        okButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) okButton.fire();

        });

        cancelButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelButton.fire();
        });

        textField.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) okButton.fire();

        });

        textField2.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) okButton.fire();

        });

        HBox hBox = new HBox(10);
        hBox.getChildren().addAll(label, textField, star);
        hBox.setAlignment(Pos.CENTER);

        HBox hBox2 = new HBox(10);
        hBox2.getChildren().addAll(label2, textField2, star2);
        hBox2.setAlignment(Pos.CENTER);

        VBox layout = new VBox(10);
        HBox layButton = new HBox(10);
        layButton.getChildren().addAll(okButton, cancelButton);
        layButton.setAlignment(Pos.CENTER);
        layout.getChildren().addAll(hBox, hBox2, man, layButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.showAndWait();

        window.setOnCloseRequest(e -> {
            e.consume();
            window.close();
        });

        return value;
    }
}

