/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.User;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Query;
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
import java.sql.SQLException;
import java.util.ResourceBundle;

/**
 * C:\Users\Dustin\Desktop\Ene - May 2020\2 COMP4400 System Development and Implementation\Dustin-Diaz-COMP4400\src\Images\icons
 * @author dudia
 */
public class controller implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private Label manFieldOne;

    @FXML
    private TextField usernameLoginTextField;

    @FXML
    private Label manText;

    @FXML
    private PasswordField passwordLoginTextField;

    @FXML
    private Label manFieldTwo;

    @FXML
    private ImageView loginImage;


    @FXML
    void login(ActionEvent event) throws SQLException {
        manFieldOne.setText("");
        manFieldTwo.setText("");
        manText.setText("");
        String u = usernameLoginTextField.getText();
        String p = passwordLoginTextField.getText();
        boolean valid = true;

        if (u.trim().isEmpty()) {
            manFieldOne.setText("*");
            valid = false;
        }

        if (p.trim().isEmpty()) {
            manFieldTwo.setText("*");
            valid = false;
        }

        if (valid) {
            User user = Query.findUserByUsername(u);
            String username = user.getUsername();
            String password = user.getAccountPassword();

            if (username.equals(u) && password.equals(p)) {
                manText.setText("Hello, " + user.getFirstName() + "!");
            } else {
                manText.setText("The entered credentials do not match anything on record.");
            }

        } else {
            manText.setText("* Mandatory Field");
        }
    }

    @FXML
    void loginRegister(ActionEvent event) throws IOException {
        borderPane.getChildren().clear();
        DustinDiazCOMP4400.setRoot("view/user/register.fxml");
    }


    @FXML
    void loginCancel(ActionEvent event) throws SQLException {
        Computer.closeProgram();
    }


    @Override
    public void initialize(URL location, ResourceBundle resources) {
        File file = new File("src/Images/icons/app/012-line.png");
        Image image = new Image(file.toURI().toString());
        loginImage.setImage(image);
    }
}
