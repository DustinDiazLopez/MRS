package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.utils.Computer;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.util.concurrent.atomic.AtomicInteger;

public class ReturnsBox {
    public static int display() {
        AtomicInteger value = new AtomicInteger(-1);
        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("Returns");
        window.setMinHeight(200);
        window.setMinWidth(450);
        window.getIcons().add(Computer.favicon);

        TextField textField = new TextField();
        textField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("\\d*")) {
                textField.setText(newValue.replaceAll("[^\\d]", ""));
            }
        });

        Label label = new Label("Enter movie ID:");

        Button yesButton = new Button("OK");
        Button noButton = new Button("Cancel");

        yesButton.setOnAction(e -> {
            String text = textField.getText().trim();

            if (!text.isEmpty()) {
                try {
                    value.set(Integer.parseInt(text));
                } catch (Exception ignored) {
                    value.set(-1);
                }
            } else {
                value.set(-1);
            }

            window.close();
        });

        noButton.setOnAction(e -> window.close());

        yesButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) yesButton.fire();

        });

        textField.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) yesButton.fire();

        });

        noButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) noButton.fire();
        });

        HBox hBox = new HBox(10);
        hBox.getChildren().addAll(label, textField);
        hBox.setAlignment(Pos.CENTER);
        VBox layout = new VBox(10);
        HBox layButton = new HBox(10);
        layButton.getChildren().addAll(yesButton, noButton);
        layButton.setAlignment(Pos.CENTER);
        layout.getChildren().addAll(hBox, layButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout);
        window.setScene(scene);
        window.showAndWait();

        window.setOnCloseRequest(e -> {
            e.consume();
            window.close();
        });

        return value.get();
    }
}

