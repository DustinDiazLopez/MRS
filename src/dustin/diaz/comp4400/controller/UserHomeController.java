package dustin.diaz.comp4400.controller;


import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Query;
import dustin.diaz.comp4400.utils.Utils;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class UserHomeController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private VBox moviesVBox;

    @FXML
    private VBox exitVBox;

    @FXML
    private VBox myAccountVBox;

    @FXML
    private VBox rentalHistoryVBox;

    @FXML
    private Label userLabel;

    boolean hello = false;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        try {
            Computer.user = Query.findUserByID(Computer.user.getId());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        myAccountVBox.setOnMouseClicked(e -> {
            borderPane.getChildren().clear();
            try {
                DustinDiazCOMP4400.setRoot("view/user/updateaccount.fxml");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });

        moviesVBox.setOnMouseClicked(e -> {
            System.out.println("Hey movies");
        });

        rentalHistoryVBox.setOnMouseClicked(e -> {
            System.out.println("Hey history");
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

        moviesVBox.setStyle(Utils.homeStyle);
        exitVBox.setStyle(Utils.homeStyle);
        myAccountVBox.setStyle(Utils.homeStyle);
        rentalHistoryVBox.setStyle(Utils.homeStyle);
        moviesVBox.setOnMouseEntered(e -> moviesVBox.setStyle(Utils.homeStyleHover));
        moviesVBox.setOnMouseExited(e -> moviesVBox.setStyle(Utils.homeStyle));
        exitVBox.setOnMouseEntered(e -> exitVBox.setStyle(Utils.homeStyleHover));
        exitVBox.setOnMouseExited(e -> exitVBox.setStyle(Utils.homeStyle));
        myAccountVBox.setOnMouseEntered(e -> myAccountVBox.setStyle(Utils.homeStyleHover));
        myAccountVBox.setOnMouseExited(e -> myAccountVBox.setStyle(Utils.homeStyle));
        rentalHistoryVBox.setOnMouseEntered(e -> rentalHistoryVBox.setStyle(Utils.homeStyleHover));
        rentalHistoryVBox.setOnMouseExited(e -> rentalHistoryVBox.setStyle(Utils.homeStyle));
    }
}

