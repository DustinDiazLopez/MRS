/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dustin.diaz.comp4400.controller;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ResourceBundle;

import dustin.diaz.comp4400.utils.Computer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

/**
 * C:\Users\Dustin\Desktop\Ene - May 2020\2 COMP4400 System Development and Implementation\Dustin-Diaz-COMP4400\src\Images\icons
 * @author dudia
 */
public class controller implements Initializable {

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
    void login(ActionEvent event) {
        String u = usernameLoginTextField.getText();
        String p = passwordLoginTextField.getText();
        boolean valid = true;

        if (u.trim().isEmpty()) {
            manFieldOne.setText("*");
            manText.setText("* Mandatory Field");
            valid = false;
        }

        if (p.trim().isEmpty()) {
            manFieldTwo.setText("*");
            manText.setText("* Mandatory Field");
            valid = false;
        }

        if (valid)
            System.out.println("Username: " + usernameLoginTextField.getText() + "\n" + "Password: " + passwordLoginTextField.getText());
    }

    @FXML
    void loginRegister(ActionEvent event) {
        System.out.println("Going to register...");
    }

    @FXML
    void loginCancel(ActionEvent event) {
        Computer.closeProgram();
    }


    @Override
    public void initialize(URL location, ResourceBundle resources) {
        File file = new File("src/Images/icons/012-line.png");
        Image image = new Image(file.toURI().toString());
        loginImage.setImage(image);
    }
}
