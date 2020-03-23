package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import javafx.collections.FXCollections;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

class RentMovieBox {

    static String recover(String fileName) {
        final AtomicReference<String>[] value = new AtomicReference[]{new AtomicReference<>("")};
        Stage window = new Stage();

        Button yesButton = new Button("Choose");
        yesButton.setDisable(true);
        Button noButton = new Button("Cancel");
        Button eraseButton = new Button("Erase");
        Styling.setButtonWidth(yesButton, noButton, eraseButton);

        eraseButton.setStyle("-fx-text-fill: #FFFFFF; -fx-background-color: #cc0000");

        List<String> histories = new ArrayList<>();
        List<String> display = new ArrayList<>();

        ListView listView = new ListView();
        listView.setPlaceholder(new Label("No saved state has been selected."));

        String[] action = new String[histories.size()];
        int counter = action.length;
        String temp;

        for (int i = 0; i < action.length; i++) {
            temp = histories.get(i);
            action[i] = (counter--) + " - " + temp;
        }


        ComboBox<String> comboBox = new ComboBox<>();

        comboBox.setOnAction(event -> {
            if (yesButton.isDisabled()) yesButton.setDisable(false);

            yesButton.setText("Recover");

            String val = comboBox.getValue();

            int selected = Integer.parseInt(val.substring(0, val.indexOf("-")).trim()) - 1;

            String paths = display.get(selected);

            List<String> list = new ArrayList<>(Arrays.asList(paths.trim().substring(1, paths.length() - 1).trim().split(",")));

            AtomicInteger i = new AtomicInteger();

            listView.getItems().clear();

            list.forEach(e -> listView.getItems().add(("[" + i.incrementAndGet()) + "] " + e.trim()));

        });

        comboBox.setItems(FXCollections.observableArrayList(action));

        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("History-inator");
        window.setMinHeight(400);
        window.setMinWidth(800);
        window.getIcons().add(Computer.favicon);

        Label label = new Label();
        label.setText("Choose a saved state to load:");

        yesButton.setOnAction(e -> {
            if (!(comboBox.getValue() == null)) {
                String val = comboBox.getValue();
                int selected = Integer.parseInt(val.substring(0, val.indexOf("-")).trim()) - 1;

                assert display != null;
                value[0].set(display.get(selected));
            } else {
                value[0] = null;
            }
            window.close();
        });

        noButton.setOnAction(e -> {
            value[0] = null;
            window.close();
        });

        eraseButton.setOnAction(e -> {
            value[0].set("-Execute Order 66-");
            window.close();
        });

        yesButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) yesButton.fire();

        });

        noButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) noButton.fire();
        });

        eraseButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) eraseButton.fire();
        });

        VBox layout = new VBox(10);
        HBox layButton = new HBox(10);
        layButton.getChildren().addAll(yesButton, noButton, eraseButton);
        layButton.setAlignment(Pos.CENTER);
        layout.getChildren().addAll(label, comboBox, layButton);
        layout.setAlignment(Pos.CENTER);

        HBox hBox = new HBox(layout, listView);

        HBox.setHgrow(layout, Priority.ALWAYS);
        HBox.setHgrow(listView, Priority.ALWAYS);

        Scene scene = new Scene(hBox, 1100, 900);

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

