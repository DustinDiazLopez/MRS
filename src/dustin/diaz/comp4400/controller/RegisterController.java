package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Styling;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.BorderPane;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalDate;
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
    private Button cancelBtn;

    @FXML
    private Button registerBtn;


    @FXML
    void register(ActionEvent event) throws IOException, SQLException {
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

        String u = username.getText();
        username.setStyle("");
        String p1 = password.getText();
        password.setStyle("");
        String p2 = passwordConfirmation.getText();
        passwordConfirmation.setStyle("");
        String fn = firstName.getText();
        firstName.setStyle("");
        String mn = middleName.getText();
        middleName.setStyle("");
        String ln = lastName.getText();
        lastName.setStyle("");
        String dob;

        try {
            dateOfBirth.setStyle("");
            dob = dateOfBirth.getValue().toString();
        } catch (Exception ignored) {
            dob = "";
        }

        String a = address.getText();
        address.setStyle("");
        String c = city.getText();
        city.setStyle("");
        String z = zipCode.getText();
        zipCode.setStyle("");
        String p = phone.getText();
        phone.setStyle("");

        if (isEmpty(mn)) mn = null;
        if (isEmpty(p)) p = null;
        if (isEmpty(dob)) dob = LocalDate.now().toString();

        if (isEmpty(u)) {
            manUsername.setText("*");
            username.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(p1)) {
            manPassword.setText("*");
            password.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(p2)) {
            manPasswordTwo.setText("*");
            passwordConfirmation.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(fn)) {
            manFirstName.setText("*");
            firstName.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(ln)) {
            manLastName.setText("*");
            lastName.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(a)) {
            manAddress.setText("*");
            address.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(c)) {
            manCity.setText("*");
            city.setStyle(Styling.error);
            valid = false;
        }

        if (isEmpty(z)) {
            manZipCode.setText("*");
            zipCode.setStyle(Styling.error);
            valid = false;
        }

        if (valid) {
            if (p1.equals(p2)) {
                if (QueryCustomer.find(u) == null) {
                    QueryCustomer.insert(u, p1, fn, mn, ln, dob, a, c, z, p);
                    borderPane.getChildren().clear();
                    DustinDiazCOMP4400.setRoot("view/user/login.fxml");
                } else {
                    manUsername.setText("*");
                    username.setStyle(Styling.error);
                    manText.setText("* This username already exists");
                }
            } else {
                manPassword.setText("*");
                manPasswordTwo.setText("*");
                passwordConfirmation.setStyle(Styling.error);
                password.setStyle(Styling.error);
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
        File file = new File("src/Images/icons/app/015-chair.png");
        Image image = new Image(file.toURI().toString());
        loginImage.setImage(image);


        EventHandler<KeyEvent> enterKey = e -> {
            if (e.getCode().toString().equals("ENTER")) registerBtn.fire();
        };

        cancelBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelBtn.fire();
        });

        registerBtn.setOnKeyPressed(enterKey);

        username.setOnKeyPressed(enterKey);
        password.setOnKeyPressed(enterKey);
        passwordConfirmation.setOnKeyPressed(enterKey);
        firstName.setOnKeyPressed(enterKey);
        middleName.setOnKeyPressed(enterKey);
        lastName.setOnKeyPressed(enterKey);
        dateOfBirth.setOnKeyPressed(enterKey);
        address.setOnKeyPressed(enterKey);
        city.setOnKeyPressed(enterKey);
        zipCode.setOnKeyPressed(enterKey);
        phone.setOnKeyPressed(enterKey);

        phone.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("(\\()?(\\d{3})+([ )\\-])? ?(\\d{3})([ \\-])?\\d{4}")) {
                manText.setText("Phone may not be valid, but that's O.K.");
            } else {
                manText.setText("");
            }
        });
    }
}
