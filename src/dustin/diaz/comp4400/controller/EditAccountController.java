package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.child.AccountType;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.queries.child.QueryAccountType;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.BorderPane;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class EditAccountController implements Initializable {

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
    private Label manPhone;

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
    private ComboBox<String> accountTypeCB;

    @FXML
    private Label manAccountType;

    @FXML
    private Button deleteBtn;


    @FXML
    void register(ActionEvent event) {
        manText.setText("");
        manAddress.setText("");
        manCity.setText("");
        manDOB.setText("");
        manPhone.setText("");
        manFirstName.setText("");
        manLastName.setText("");
        manPassword.setText("");
        manPasswordTwo.setText("");
        manUsername.setText("");
        manZipCode.setText("");
        manAccountType.setText("");

        boolean valid = true;

        String u = username.getText();
        String oldUsername = Computer.editCustomer.getUsername();
        username.setStyle("");
        String p1 = password.getText();
        password.setStyle("");
        String p2 = passwordConfirmation.getText();
        passwordConfirmation.setStyle("");
        String cb = accountTypeCB.getValue();
        accountTypeCB.setStyle("");
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
        if (isEmpty(dob)) dob = LocalDate.now().toString();

        if (isEmpty(p)) {
            manPhone.setText("*");
            phone.setStyle(Styling.error);
            valid = false;
        }

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

        if (isEmpty(cb)) {
            manAccountType.setText("*");
            accountTypeCB.setStyle(Styling.error);
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

        int id = Computer.editCustomer.getId();

        if (valid) {
            if (p1.equals(p2)) {
                try {
                    boolean equals = oldUsername.equals(u);
                    boolean exists = QueryCustomer.find(u) != null;

                    if (equals || !exists) {
                        AccountType type = QueryAccountType.findType(accountTypeCB.getValue());
                        QueryCustomer.updateCustomer(id, u, p1, fn, mn, ln, dob, a, c, z, p, type);
                        Computer.changeScreen(borderPane, "customertable");
                    } else {
                        username.setStyle(Styling.error);
                        manText.setText("* This username already exists.");
                        manUsername.setText("*");
                    }
                } catch (Exception e) {
                    ConfirmBox.display("Error Updating", "An error has occurred. Please try again.\n" + e.getLocalizedMessage());
                    cancelBtn.fire();
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
        if (string == null) return true;
        return string.trim().isEmpty();
    }

    @FXML
    void registerCancel(ActionEvent event) throws IOException {
        Computer.changeScreen(borderPane, "customertable");
    }

    @FXML
    void update(ActionEvent event) throws SQLException {
        Customer c = Computer.editCustomer;
        String name = Styling.formatNames(c.getFirstName(), c.getLastName());
        if (ConfirmBox.display(
                "Delete " + name,
                "Are you sure you want to delete user '" + name + "' " + "(ID: " + c.getId() + ")")) {
            QueryCustomer.delete(c.getId());
            cancelBtn.fire();
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        loginImage.setImage(Computer.maskImage);


        try {
            ArrayList<AccountType> types = QueryAccountType.findAllTypes();
            ArrayList<String> list = new ArrayList<>();
            for (AccountType a : types) list.add(a.getType());
            accountTypeCB.setItems(FXCollections.observableArrayList(list));
        } catch (SQLException e) {
            e.printStackTrace();
        }


        EventHandler<KeyEvent> enterKey = e -> {
            if (e.getCode().toString().equals("ENTER")) registerBtn.fire();
        };

        cancelBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelBtn.fire();
        });

        deleteBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) deleteBtn.fire();
        });

        registerBtn.setOnKeyPressed(enterKey);

        username.setOnKeyPressed(enterKey);
        username.setText(Computer.editCustomer.getUsername());
        password.setOnKeyPressed(enterKey);
        password.setText(Computer.editCustomer.getAccountPassword());
        passwordConfirmation.setOnKeyPressed(enterKey);
        passwordConfirmation.setText(Computer.editCustomer.getAccountPassword());
        accountTypeCB.setOnKeyPressed(enterKey);
        accountTypeCB.setValue(Computer.editCustomer.getAccountType());
        firstName.setOnKeyPressed(enterKey);
        firstName.setText(Computer.editCustomer.getFirstName());
        middleName.setOnKeyPressed(enterKey);
        middleName.setText(Computer.editCustomer.getMiddleName());
        lastName.setOnKeyPressed(enterKey);
        lastName.setText(Computer.editCustomer.getLastName());
        dateOfBirth.setOnKeyPressed(enterKey);
        dateOfBirth.setValue(Computer.editCustomer.getDateOfBirth().toLocalDate());
        address.setOnKeyPressed(enterKey);
        address.setText(Computer.editCustomer.getAddress());
        city.setOnKeyPressed(enterKey);
        city.setText(Computer.editCustomer.getCity());
        zipCode.setOnKeyPressed(enterKey);
        zipCode.setText(Computer.editCustomer.getZipCode());
        phone.setOnKeyPressed(enterKey);
        phone.setText(Computer.editCustomer.getPhone());

        phone.textProperty().addListener((observable, oldValue, newValue) -> {
            if (!newValue.matches("(\\()?(\\d{3})+([ )\\-])? ?(\\d{3})([ \\-])?\\d{4}")) {
                manText.setText("Phone may not be valid, but that's O.K.");
            } else {
                manText.setText("");
            }
        });
    }
}
