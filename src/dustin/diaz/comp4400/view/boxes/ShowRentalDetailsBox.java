package dustin.diaz.comp4400.view.boxes;

import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Details;
import dustin.diaz.comp4400.utils.Styling;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import javafx.scene.text.FontPosture;
import javafx.scene.text.FontWeight;
import javafx.scene.text.TextAlignment;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.concurrent.atomic.AtomicBoolean;

public class ShowRentalDetailsBox {
    public static boolean display(Rental rental) throws SQLException {
        AtomicBoolean answer = new AtomicBoolean(false);
        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.setMinHeight(200);
        window.setMinWidth(410);
        window.getIcons().add(Computer.favicon);

        Button yesButton = new Button("Complete Return");
        Button noButton = new Button("Cancel Return");
        setButtonWidth(yesButton, noButton);

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

        VBox right = new VBox(10);
        VBox left = new VBox(10);
        Label[] titleLabels = {
                new Label("Movie:"),
                new Label("Customer:"),
                new Label("Rented On:"),
                new Label("Returned On:"),
                new Label("Cost:"),
                new Label("Total Days:"),
                new Label("Total Cost:")
        };

        String media = rental.getMedia().getType();
        String movie = rental.getMovie().getTitle() + " (" + media + ")";
        String customer = Styling.formatNames(QueryCustomer.find(rental.getCustomerId()));
        Date rentedOn = rental.getRentedOn();
        Date returnedOn = Date.valueOf(LocalDate.now().toString());
        float cost = Details.getPrice(rental.getMedia());
        int days = rental.getTotalDays();
        days = days == 0 ? 1 : days;

        window.setTitle("Receipt for the " + customer + " for " + movie);

        Label[] informationLabels = {
                new Label(movie),
                new Label(customer),
                new Label(rentedOn.toString()),
                new Label(returnedOn.toString()),
                new Label("$" + Details.round(cost, 100d) + " per day"),
                new Label(days + " day(s)"),
                new Label("$" + Details.round(rental.getTotalCost(), 100d))
        };

        formatRightLabels(informationLabels);
        right.getChildren().addAll(informationLabels);

        formatLeftLabels(titleLabels);
        left.getChildren().addAll(titleLabels);

        HBox labels = new HBox(10);
        labels.setPadding(new Insets(10, 10, 10, 10));
        labels.setAlignment(Pos.CENTER);
        labels.getChildren().addAll(left, right);

        VBox layout = new VBox(10);
        HBox layButton = new HBox(10);
        layButton.setAlignment(Pos.CENTER);
        layout.setAlignment(Pos.CENTER);
        layButton.getChildren().addAll(yesButton, noButton);
        layout.getChildren().addAll(labels, layButton);

        Scene scene = new Scene(layout, 600, 500);

        window.setScene(scene);
        window.showAndWait();

        return answer.get();
    }

    private static void formatLeftLabels(Label... labels) {
        for (Label label : labels) {
            label.setMaxWidth(400);
            label.setAlignment(Pos.CENTER_RIGHT);
            label.setWrapText(true);
            label.textAlignmentProperty().setValue(TextAlignment.RIGHT);
            label.setFont(Font.font("Verdana", FontWeight.BOLD, 15));
        }
    }

    private static void formatRightLabels(Label... labels) {
        for (Label label : labels) {
            label.setMaxWidth(400);
            label.setAlignment(Pos.CENTER_LEFT);
            label.setWrapText(true);
            label.textAlignmentProperty().setValue(TextAlignment.LEFT);
            label.setFont(Font.font("Verdana", FontPosture.ITALIC, 15));
        }
    }

    public static void setButtonWidth(Button... buttons) {
        for (Button button : buttons) button.setPrefWidth(200d);
    }
}
