package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Utils;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.io.IOException;
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
    private Label userLabel;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        rentalsVBox.setOnMouseClicked(e -> {
            System.out.println("Hey rentals");
        });

        moviesVBox.setOnMouseClicked(e -> {
            System.out.println("Hey movies");
        });

        customerVBox.setOnMouseClicked(e -> {
            System.out.println("Hey customers");
        });

        exitVBox.setOnMouseClicked(e -> {
            if (ConfirmBox.display("Log-out", "Are you sure you want to log-out?")) {
                borderPane.getChildren().clear();
                try {
                    DustinDiazCOMP4400.setRoot("view/user/login.fxml");
                    Computer.user = null;
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        });

        userLabel.setText(Computer.user.getFirstName() + " " + Computer.user.getLastName());

        rentalsVBox.setStyle(Utils.homeStyle);
        customerVBox.setStyle(Utils.homeStyle);
        moviesVBox.setStyle(Utils.homeStyle);
        exitVBox.setStyle(Utils.homeStyle);
        rentalsVBox.setOnMouseEntered(e -> rentalsVBox.setStyle(Utils.homeStyleHover));
        rentalsVBox.setOnMouseExited(e -> rentalsVBox.setStyle(Utils.homeStyle));
        customerVBox.setOnMouseEntered(e -> customerVBox.setStyle(Utils.homeStyleHover));
        customerVBox.setOnMouseExited(e -> customerVBox.setStyle(Utils.homeStyle));
        moviesVBox.setOnMouseEntered(e -> moviesVBox.setStyle(Utils.homeStyleHover));
        moviesVBox.setOnMouseExited(e -> moviesVBox.setStyle(Utils.homeStyle));
        exitVBox.setOnMouseEntered(e -> exitVBox.setStyle(Utils.homeStyleHover));
        exitVBox.setOnMouseExited(e -> exitVBox.setStyle(Utils.homeStyle));
    }
}
