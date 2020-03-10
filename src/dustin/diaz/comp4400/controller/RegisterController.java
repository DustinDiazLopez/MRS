package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Region;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.time.format.DateTimeFormatter;
import java.util.ResourceBundle;

public class RegisterController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private TextField lastName;

    @FXML
    private TextField zipCode;

    @FXML
    private TextField city;

    @FXML
    private Label manPasswordTwo;

    @FXML
    private Label manLastName;

    @FXML
    private Label manUsername;

    @FXML
    private TextField password;

    @FXML
    private Label manFirstName;

    @FXML
    private Label manCity;

    @FXML
    private TextField address;

    @FXML
    private Label manText;

    @FXML
    private Label manZipCode;

    @FXML
    private Label manPassword;

    @FXML
    private ImageView loginImage;

    @FXML
    private TextField passwordConfirmation;

    @FXML
    private TextField firstName;

    @FXML
    private TextField phone;

    @FXML
    private DatePicker dateOfBirth;

    @FXML
    private Label manDOB;

    @FXML
    private TextField middleName;

    @FXML
    private Label manAddress;

    @FXML
    private TextField username;


    @FXML
    void register(ActionEvent event) {
        manText.setText("");
        manAddress.setText("");
        manCity.setText("");
        manDOB.setText("");
        manFirstName.setText("");
        manLastName.setText("");
        manPassword.setText("");
        manPasswordTwo.setText("");
        manUsername.setText("");
        manZipCode.setText("");

        boolean valid = true;
        boolean missing = false;

        String u = username.getText();
        String p1 = password.getText();
        String p2 = passwordConfirmation.getText();
        String fn = firstName.getText();
        String mn = middleName.getText();
        String ln = lastName.getText();
        String dob;
        try {
            dob = dateOfBirth.getValue().toString();
        } catch (Exception ignored) {
            dob = "";
        }

        String a = address.getText();
        String c = city.getText();
        String z = zipCode.getText();
        String p = phone.getText();

        System.out.println(dob);

        if (isEmpty(mn)) {
            missing = true;
        }

        if (isEmpty(p)) {
            missing = true;
        }

        if (isEmpty(dob)) {
            missing = true;
        }

        if (isEmpty(u)) {
            manUsername.setText("*");
            valid = false;
        }

        if (isEmpty(p1)) {
            manPassword.setText("*");
            valid = false;
        }

        if (isEmpty(p2)) {
            manPasswordTwo.setText("*");
            valid = false;
        }

        if (isEmpty(fn)) {
            manFirstName.setText("*");
            valid = false;
        }

        if (isEmpty(ln)) {
            manLastName.setText("*");
            valid = false;
        }

        if (isEmpty(a)) {
            manAddress.setText("*");
            valid = false;
        }

        if (isEmpty(c)) {
            manCity.setText("*");
            valid = false;
        }

        if (isEmpty(z)) {
            manZipCode.setText("*");
            valid = false;
        }

        if (valid) {
            if (p1.equals(p2)) {
                if (missing) {

                } else {

                }
            } else {
                manPassword.setText("*");
                manPasswordTwo.setText("*");
                manText.setText("* Passwords don't match");
            }
        } else {
            manText.setText("* Mandatory Fields");
        }

    }

    private boolean isEmpty(String string) {
        return string.trim().isEmpty();
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
