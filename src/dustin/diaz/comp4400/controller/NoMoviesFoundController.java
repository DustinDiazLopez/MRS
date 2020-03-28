package dustin.diaz.comp4400.controller;


import dustin.diaz.comp4400.utils.Computer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;

public class NoMoviesFoundController {

    @FXML
    private BorderPane borderPane;

    @FXML
    void goBack(ActionEvent event) {
        Computer.changeScreen(borderPane, "userhome");
    }
}
