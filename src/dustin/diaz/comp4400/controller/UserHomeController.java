package dustin.diaz.comp4400.controller;


import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.net.URL;
import java.sql.SQLException;
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

    @FXML
    private VBox rentalHistoryVBox;

    @FXML
    private Label userLabel;

    @FXML
    private Label rentMovieLabel;

    @FXML
    private Label rentalHistoryLabel;

    @FXML
    private Label editAccountLabel;

    int chosen = 1;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        try {
            Computer.customer = QueryCustomer.find(Computer.customer.getId());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        myAccountVBox.setOnMouseClicked(e -> Computer.changeScreen(borderPane, "updateaccount"));

        moviesVBox.setOnMouseClicked(e -> Computer.changeScreen(borderPane, "rentmovie"));

        rentalHistoryVBox.setOnMouseClicked(e -> {
            try {
                RentalHistoryController.movies = RentalHistoryController.getRented();
                if (RentalHistoryController.movies != null && RentalHistoryController.movies.size() != 0) {
                    Computer.changeScreen(borderPane, "rentalhistory");
                } else {
                    Computer.changeScreen(borderPane, "nothingfound");
                }
            } catch (SQLException ignored) {
                Computer.changeScreen(borderPane, "nothingfound");
            }
        });

        exitVBox.setOnMouseClicked(e -> {
            if (ConfirmBox.display("Log-out", "Are you sure you want to log-out?")) {
                Computer.changeScreen(borderPane, "login");
            }
        });

        userLabel.setText(Styling.formatNames(Computer.customer));

        VBox[] vBoxes = {myAccountVBox, rentalHistoryVBox, moviesVBox, exitVBox};

        Styling.setStyle(vBoxes);
        Styling.pleaseWaitVBoxStyle(moviesVBox, rentMovieLabel);
        Styling.pleaseWaitVBoxStyle(myAccountVBox, editAccountLabel);
        Styling.pleaseWaitVBoxStyle(rentalHistoryVBox, rentalHistoryLabel);

        DustinDiazCOMP4400.scene.setOnKeyPressed(e -> {
            switch (e.getCode().toString()) {
                case "ESCAPE":
                    Computer.closeProgram();
                    break;
                case "TAB":
                    if (chosen == 2) {
                        Styling.disableEnableVBoxStyle(myAccountVBox, rentalHistoryVBox);
                        chosen++;
                    } else if (chosen == 3) {
                        Styling.disableEnableVBoxStyle(rentalHistoryVBox, moviesVBox);
                        chosen++;
                    } else if (chosen == 4) {
                        Styling.disableEnableVBoxStyle(moviesVBox, exitVBox);
                        chosen++;
                    } else {
                        chosen = 2;
                        Styling.disableEnableVBoxStyle(exitVBox, myAccountVBox);
                    }
                    break;
                case "ENTER":
                    if (chosen == 2) {
                        Computer.changeScreen(borderPane, "updateaccount");
                    } else if (chosen == 3) {
                        try {
                            RentalHistoryController.movies = RentalHistoryController.getRented();
                            if (RentalHistoryController.movies != null && RentalHistoryController.movies.size() != 0) {
                                Computer.changeScreen(borderPane, "rentalhistory");
                            } else {
                                Computer.changeScreen(borderPane, "nothingfound");
                            }
                        } catch (SQLException ignored) {
                            Computer.changeScreen(borderPane, "nothingfound");
                        }
                    } else if (chosen == 4) {
                        Computer.changeScreen(borderPane, "rentmovie");
                    } else if (chosen == 5) {
                        if (ConfirmBox.display("Log-out", "Are you sure you want to log-out?")) {
                            Computer.changeScreen(borderPane, "login");
                        }
                    }
                    break;
            }
        });
    }
}

