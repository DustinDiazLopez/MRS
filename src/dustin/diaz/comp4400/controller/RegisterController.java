package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class RegisterController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private Label manFieldOne;

    @FXML
    private PasswordField password;

    @FXML
    private Label manText;

    @FXML
    private Label manFieldTwo;

    @FXML
    private ImageView loginImage;

    @FXML
    private TextField username;

    @FXML
    void register(ActionEvent event) {

    }

    @FXML
    void registerCancel(ActionEvent event) throws IOException {
        borderPane.getChildren().clear();
        DustinDiazCOMP4400.setRoot("view/user/login.fxml");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        File file = new File("src/Images/icons/015-chair.png");
        Image image = new Image(file.toURI().toString());
        loginImage.setImage(image);
    }
}
