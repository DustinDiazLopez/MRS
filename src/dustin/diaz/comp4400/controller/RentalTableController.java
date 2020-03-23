package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.model.tables.RentalTable;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ChooseBox;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;

import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class RentalTableController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private Button refreshBtn;

    @FXML
    private Button deleteButton;

    @FXML
    private Button backBtn;

    @FXML
    private TableView tableView;

    @FXML
    private Button addBtn;

    @FXML
    private Label warning;

    private Rental selected = null;

    public void updateTable() {
        try {
            tableView.getItems().clear();
            ArrayList<RentalTable> table = QueryRental.getAllForTable();
            if (table != null) {
                tableView.getItems().addAll(QueryRental.getAllForTable());
                warning.setText("");
            } else {
                warning.setText("No rentals found...");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {

        borderPane.setMinSize(1100.0, 900.0);

        tableView.getColumns().clear();

        refreshBtn.setOnMousePressed(e -> updateTable());

        refreshBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) refreshBtn.fire();
        });

        backBtn.setOnMousePressed(e -> Computer.changeScreen(borderPane, "adminhome"));

        backBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) backBtn.fire();
        });

        addBtn.setOnMousePressed(e -> {
            Computer.changeScreen(borderPane, "addmovie");
        });

        addBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) addBtn.fire();
        });

        deleteButton.setOnMousePressed(e -> {
            warning.setText("");
            tableView.setStyle("");

            if (selected == null) {
                warning.setText("Select a movie to DELETE.");
                tableView.setStyle(Styling.error);
            } else {
                Rental c = selected;
                String name = c.getMovie().getTitle();
                if (ConfirmBox.display(
                        "Delete " + name,
                        "Are you sure you want to DELETE movie '" + name + "' " + "(ID: " + c.getId() + ")")) {
                    try {
                        QueryRental.delete(c.getId());
                        updateTable();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        });

        deleteButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) deleteButton.fire();
        });

        tableView.setOnMousePressed(e -> {
            try {
                RentalTable rt = (RentalTable) tableView.getSelectionModel().getSelectedItem();
                selected = QueryRental.find(rt.getRentalId());
            } catch (Exception ignored) {
            }
        });

        tableView.setOnMouseClicked(event -> {
            String e = event.toString();
            if (!e.contains("target = TableColumnHeader") && !e.contains("target = Label") && selected != null) {
                if (event.getButton().equals(MouseButton.SECONDARY)) {
                    String choice = ChooseBox.display(selected.getMovie().getTitle(), "" + selected.getId());

                    if (choice != null) {
                        Rental c = selected;
                        String name = selected.getMovie().getTitle();

                        if (choice.equals("Edit")) {
                            try {
                                Computer.editRental = QueryRental.find(selected.getId());
                                Computer.changeScreen(borderPane, "editmovie");
                            } catch (SQLException ignored) {
                                ConfirmBox.display("An error occured", "Couldn't execute query");
                            }
                        } else if (choice.equals("Delete")) {
                            if (ConfirmBox.display(
                                    "Delete " + name,
                                    "Are you sure you want to DELETE movie '" + name + "' " + "(ID: " + c.getId() + ")?")) {
                                try {
                                    QueryRental.delete(c.getId());
                                    updateTable();
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }
                        } else {
                            ConfirmBox.display(
                                    "Unrecognized Command",
                                    "Please specify the command in the ChooseBox Class"
                            );
                        }
                    }

                } else if (event.getButton().equals(MouseButton.PRIMARY) && event.getClickCount() == 2) {
                    String name = selected.getMovie().getTitle();
                    if (ConfirmBox.display("Edit " + name,
                            "Would you like to EDIT " + name + " (ID:" + selected.getId() + ")?")) {
                        try {
                            Computer.editRental = QueryRental.find(selected.getId());
                            Computer.changeScreen(borderPane, "editmovie");
                        } catch (SQLException ignored) {
                            ConfirmBox.display("An error occured", "Couldn't execute query");
                        }
                    }
                }
            }
        });

        tableView.setPlaceholder(new Label("No rentals to display."));

        TableColumn<String, RentalTable> id = new TableColumn<>("Movie ID");
        id.setCellValueFactory(new PropertyValueFactory<>("movieId"));

        TableColumn<String, RentalTable> title = new TableColumn<>("Movie Title");
        title.setCellValueFactory(new PropertyValueFactory<>("movieTitle"));

        TableColumn<String, RentalTable> releaseDate = new TableColumn<>("Customer ID");
        releaseDate.setCellValueFactory(new PropertyValueFactory<>("customerId"));

        TableColumn<String, RentalTable> genre = new TableColumn<>("Customer Name");
        genre.setCellValueFactory(new PropertyValueFactory<>("customerName"));

        TableColumn<String, RentalTable> runTime = new TableColumn<>("Rented Date");
        runTime.setCellValueFactory(new PropertyValueFactory<>("rentedDate"));

        HBox.setHgrow(tableView, Priority.ALWAYS);


        tableView.getColumns().add(id);
        tableView.getColumns().add(title);
        tableView.getColumns().add(releaseDate);
        tableView.getColumns().add(genre);
        tableView.getColumns().add(runTime);


        updateTable();
    }
}
