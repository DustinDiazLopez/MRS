package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.net.URL;
import java.util.ResourceBundle;

public class AdminHomeController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private VBox rentalsVBox;

    @FXML
    private VBox moviesVBox;

    @FXML
    private VBox customerVBox;

    @FXML
    private VBox exitVBox;

    @FXML
    private Label customerLabelVBox;

    @FXML
    private Label movieLabelVBox;

    @FXML
    private Label rentalLabelVBox;

    @FXML
    private Label userLabel;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        userLabel.setText(Styling.formatNames(Computer.customer));

        Styling.pleaseWaitVBoxStyle(rentalsVBox, rentalLabelVBox);
        Styling.pleaseWaitVBoxStyle(moviesVBox, movieLabelVBox);
        Styling.pleaseWaitVBoxStyle(customerVBox, customerLabelVBox);
        Styling.setStyle(rentalsVBox, customerVBox, moviesVBox, exitVBox);

        rentalsVBox.setOnMouseClicked(e -> Computer.changeScreen(borderPane, "rentaltable"));
        moviesVBox.setOnMouseClicked(e -> Computer.changeScreen(borderPane, "movietable"));
        customerVBox.setOnMouseClicked(e -> Computer.changeScreen(borderPane, "customertable"));

        exitVBox.setOnMouseClicked(e -> {
            if (ConfirmBox.display("Log-out", "Are you sure you want to log-out?")) {
                Computer.changeScreen(borderPane, "login");
            }
        });
    }
}
