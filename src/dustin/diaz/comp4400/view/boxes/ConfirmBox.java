package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.TextAlignment;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.util.concurrent.atomic.AtomicBoolean;

public class ConfirmBox {

    public static boolean display(String title, String message) {
        return display(title, message, 410, 200, "Yes", "No");
    }

    public static boolean display(String title, String message, String btnOne, String btnTwo) {
        return display(title, message, 410, 200, btnOne, btnTwo);
    }

    public static boolean display(String title, String message, int width, int height) {
        return display(title, message, width, height, "Yes", "No");
    }

    public static boolean display(String title, String message, int width, int height, String btnOne, String btnTwo) {
        AtomicBoolean answer = new AtomicBoolean(false);
        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle(title);
        window.setMinHeight(200);
        window.setMinWidth(410);
        window.getIcons().add(Computer.favicon);

        Label label = new Label();
        label.setText(message);
        label.setMaxWidth(400);
        label.setAlignment(Pos.CENTER);
        label.setWrapText(true);
        label.textAlignmentProperty().setValue(TextAlignment.CENTER);

        Button yesButton = new Button(btnOne);
        Button noButton = new Button(btnTwo);
        Styling.setButtonWidth(yesButton, noButton);

        yesButton.setOnAction(e -> {
            answer.set(true);
            window.close();
        });


        noButton.setOnAction(e -> {
            answer.set(false);
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
        layout.getChildren().addAll(label, layButton);
        layout.setAlignment(Pos.CENTER);

        Scene scene = new Scene(layout, width, height);

        window.setScene(scene);
        window.showAndWait();

        return answer.get();
    }
}
