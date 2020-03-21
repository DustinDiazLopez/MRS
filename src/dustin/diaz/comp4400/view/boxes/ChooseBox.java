package dustin.diaz.comp4400.view.boxes;

import javafx.collections.FXCollections;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.io.File;
import java.util.concurrent.atomic.AtomicReference;

public class ChooseBox {
    public static String display(String selected) {
        final AtomicReference<String>[] value = new AtomicReference[]{new AtomicReference<>("")};
        Stage window = new Stage();

        Button yesButton = new Button("Choose");
        yesButton.setDisable(true);
        Button noButton = new Button("Cancel");

        String[] action = {
                "Edit",
                "Delete"
        };

        ComboBox<String> comboBox = new ComboBox<>();

        comboBox.setOnAction(event -> {
            if (yesButton.isDisabled()) yesButton.setDisable(false);
            yesButton.setText(comboBox.getValue());
        });

        comboBox.setItems(FXCollections.observableArrayList(action));

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("Choose");
        window.setMinHeight(200);
        window.setMinWidth(425);
        window.getIcons().add(new Image(new File("src/Images/icons/favicon/android-chrome-512x512.png").toURI().toString()));

        Label label = new Label();
        label.setText("Choose the action for user '" + selected + "':");

        yesButton.setOnAction(e -> {
            if (!(comboBox.getValue() == null)) {
                value[0].set(comboBox.getValue());
            } else {
                value[0] = null;
            }
            window.close();
        });

        noButton.setOnAction(e -> {
            value[0] = null;
            window.close();
        });

        yesButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) yesButton.fire();

        });

        noButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) noButton.fire();
        });

        VBox layout = new VBox(10);
        HBox layButton = new HBox(10);
        layButton.getChildren().addAll(yesButton, noButton);
        layButton.setAlignment(Pos.CENTER);
        layout.getChildren().addAll(label, comboBox, layButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout);

        window.setScene(scene);
        window.showAndWait();

        window.setOnCloseRequest(e -> {
            e.consume();
            value[0] = null;
            window.close();
        });

        return value[0].get();
    }
}
