package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.util.ArrayList;

public class NewRentalBox {
    public static int[] display() {
        final ArrayList<Integer>[] value = new ArrayList[]{new ArrayList<>()};

        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("New Rental");
        window.setMinHeight(300);
        window.setMinWidth(500);
        window.getIcons().add(Computer.favicon);

        Label man = new Label("");
        man.setTextFill(Color.RED);

        Label star = new Label("*");
        star.setTextFill(Color.RED);
        star.setVisible(false);

        Label star2 = new Label("*");
        star2.setTextFill(Color.RED);
        star2.setVisible(false);

        Label label = new Label("Enter movie ID:     ");
        TextField textField = new TextField();
        textField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d*")) {
                textField.setText(newValue.replaceAll("[^\\d]", ""));
                man.setText("Please Enter Numbers Only");
                textField.setStyle(Styling.error);
                star.setVisible(true);
            } else {
                man.setText("");
                textField.setStyle("");
                star.setVisible(false);
            }
        });

        Label label2 = new Label("Enter customer ID:");
        TextField textField2 = new TextField();
        textField2.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d*")) {
                textField2.setText(newValue.replaceAll("[^\\d]", ""));
                man.setText("Please Enter Numbers Only");
                textField2.setStyle(Styling.error);
                star2.setVisible(true);
            } else {
                man.setText("");
                textField2.setStyle("");
                star2.setVisible(false);
            }
        });

        Button okButton = new Button("OK");
        Button cancelButton = new Button("Cancel");
        Styling.setButtonWidth(okButton, cancelButton);

        okButton.setOnAction(e -> {
            star.setVisible(false);
            star2.setVisible(false);
            man.setText("");
            textField.setStyle("");
            textField2.setStyle("");

            if (!textField.getText().trim().isEmpty() && !textField2.getText().trim().isEmpty()) {
                try {
                    value[0].add(Integer.parseInt(textField.getText()));
                    value[0].add(Integer.parseInt(textField2.getText()));
                    window.close();
                } catch (Exception ignored) {
                    value[0] = null;
                }
            } else {
                if (textField.getText().trim().isEmpty()) {
                    star.setVisible(true);
                    textField.setStyle(Styling.error);
                } else {
                    try {
                        value[0].add(Integer.parseInt(textField.getText()));
                        value[0].add(-1);
                        window.close();
                    } catch (Exception ignored) {
                        value[0] = null;
                    }
                }

                if (textField2.getText().trim().isEmpty()) {
                    star2.setVisible(true);
                    textField2.setStyle(Styling.error);
                } else {
                    try {
                        value[0].add(-1);
                        value[0].add(Integer.parseInt(textField2.getText()));
                        window.close();
                    } catch (Exception ignored) {
                        value[0] = null;
                    }
                }

                star.setVisible(true);
                star2.setVisible(true);
                man.setText("* Please provide the information for one or both fields");
            }
        });

        cancelButton.setOnAction(e -> window.close());

        cancelButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelButton.fire();
        });

        okButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) okButton.fire();
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

        Object[] arr = value[0].toArray();
        return arr.length >= 2 ? new int[]{(int) arr[0], (int) arr[1]} : null;
    }
}

