package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.utils.Computer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.layout.BorderPane;

import java.net.URL;
import java.util.ResourceBundle;

public class NothingFoundController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    void goBack(ActionEvent event) {
        Computer.changeScreen(borderPane, "userhome");
    }

    @FXML
    void goRent(ActionEvent event) {
        Computer.changeScreen(borderPane, "rentmovie");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        System.out.println("nothing");
    }
}

