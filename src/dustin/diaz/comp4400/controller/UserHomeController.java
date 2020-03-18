package dustin.diaz.comp4400.controller;


import dustin.diaz.comp4400.utils.Utils;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.net.URL;
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

    @Override
    public void initialize(URL location, ResourceBundle resources) {

        moviesVBox.setOnMouseClicked(e -> {
            System.out.println("Hey movies");
        });

        exitVBox.setOnMouseClicked(e -> {
            System.out.println("Hey exit");
        });

        myAccountVBox.setOnMouseClicked(e -> {
            System.out.println("Hey account");
        });

        moviesVBox.setStyle(Utils.homeStyle);
        exitVBox.setStyle(Utils.homeStyle);
        myAccountVBox.setStyle(Utils.homeStyle);
        moviesVBox.setOnMouseEntered(e -> moviesVBox.setStyle(Utils.homeStyleHover));
        moviesVBox.setOnMouseExited(e -> moviesVBox.setStyle(Utils.homeStyle));
        exitVBox.setOnMouseEntered(e -> exitVBox.setStyle(Utils.homeStyleHover));
        exitVBox.setOnMouseExited(e -> exitVBox.setStyle(Utils.homeStyle));
        myAccountVBox.setOnMouseEntered(e -> myAccountVBox.setStyle(Utils.homeStyleHover));
        myAccountVBox.setOnMouseExited(e -> myAccountVBox.setStyle(Utils.homeStyle));
    }
}

