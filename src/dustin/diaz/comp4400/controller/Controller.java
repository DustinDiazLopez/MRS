package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.FXService;
import dustin.diaz.comp4400.utils.Styling;
import javafx.concurrent.Service;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.paint.Color;

import java.net.URL;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class Controller implements Initializable {

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
    private Button loginBtn;

    @FXML
    private Button registerBtn;

    @FXML
    private Button cancelBtn;

    @FXML
    public Label connectionStatus;

    private FXService<Void> fxService = new FXService<>();
    private Service<Void> service = fxService.setAll(() -> {
        try {
            Class.forName(DBINFO.DRIVER);
            Computer.connection = DriverManager.getConnection(DBINFO.URL, DBINFO.USERNAME, DBINFO.PASSWORD);
            while (!DustinDiazCOMP4400.finished) fxService.getLatch().await(100, TimeUnit.MILLISECONDS);
            connectionStatus.setTextFill(Color.GREEN);
            connectionStatus.setText("CONNECTED");
        } catch (ClassNotFoundException | SQLException | InterruptedException e) {
            connectionStatus.setTextFill(Color.RED);
            connectionStatus.setText(e.getMessage());
            System.out.println(e.getMessage());
        } finally {
            fxService.countDown();
        }
    }, new CountDownLatch(1));

    @FXML
    void login(ActionEvent event) throws SQLException {
        manFieldOne.setText("");
        manFieldTwo.setText("");
        usernameLoginTextField.setStyle("");
        passwordLoginTextField.setStyle("");
        manText.setText("");
        String u = usernameLoginTextField.getText();
        String p = passwordLoginTextField.getText();
        boolean valid = true;

        if (u.trim().isEmpty()) {
            usernameLoginTextField.setStyle(Styling.error);
            manFieldOne.setText("*");
            valid = false;
        }

        if (p.trim().isEmpty()) {
            passwordLoginTextField.setStyle(Styling.error);
            manFieldTwo.setText("*");
            valid = false;
        }


        if (valid) {
            Customer customer = QueryCustomer.find(u);

            if (customer != null) {
                String username = customer.getUsername();
                String password = customer.getAccountPassword(); //TODO: un-hash if hashed...

                if (username.equals(u) && password.equals(p)) {
                    manText.setText("Hello, " + customer.getFirstName() + "!");
                    Computer.customer = customer;

                    if (customer.getAccountType().equals("ADMIN")) {
                        Computer.changeScreen(borderPane, "adminhome");
                    } else {
                        Computer.changeScreen(borderPane, "userhome");
                    }
                } else {
                    manText.setText("The entered credentials do not match anything on record.");
                }
            } else {
                manText.setText("The entered credentials do not match anything on record.");
            }

        } else {
            manText.setText("* Mandatory Field");
        }
    }

    @FXML
    void loginRegister(ActionEvent event) {
        Computer.changeScreen(borderPane, "register");
    }


    @FXML
    void loginCancel(ActionEvent event) {
        Computer.closeProgram();
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        service.start();
        loginImage.setImage(Computer.loginImage);
        EventHandler<KeyEvent> loginEnterKey = e -> {
            if (e.getCode().toString().equals("ENTER")) loginBtn.fire();
        };

        usernameLoginTextField.setOnKeyPressed(loginEnterKey);
        passwordLoginTextField.setOnKeyPressed(loginEnterKey);
        loginBtn.setOnKeyPressed(loginEnterKey);

        cancelBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelBtn.fire();
        });

        registerBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) registerBtn.fire();
        });
    }
}
