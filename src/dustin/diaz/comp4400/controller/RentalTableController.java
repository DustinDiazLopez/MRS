package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.model.tables.RentalTable;
import dustin.diaz.comp4400.queries.child.QueryMedias;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.*;
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
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Objects;
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
            int[] choice = NewRentalBox.display();
            if (choice != null) {
                if (choice[0] != -1 && choice[1] != -1) {
                    try {
                        Customer customer = QueryCustomer.find(choice[0]);
                        Movie movie = QueryMovie.findMovie(choice[1]);
                        int media = QueryMedias.findMedia(MediaBox.display(movie)).getId();
                        Date date = Date.valueOf(LocalDate.now().toString());
                        int q = QueryRental.insert(customer.getId(), media, date, false);
                        System.out.println(movie.getTitle() + " (" + media + ") rented by " + customer.getUsername() + " on " + date);
                        System.out.println("Insert count " + q);
                        updateTable();
                    } catch (SQLException ignored) {
                        ConfirmBox.display(
                                "Error",
                                "An error occurred while finding customer-movie",
                                "OK",
                                "Cancel"
                        );
                    }
                } else {
                    try {
                        ArrayList<Rental> held = QueryRental.getHeld();
                        if (choice[1] != -1) {
                            try {
                                Customer customer = QueryCustomer.find(choice[1]);
                                if (customer != null) {
                                    ArrayList<Rental> matched = new ArrayList<>();

                                    for (Rental r : held) {
                                        if (r.getCustomerId() == customer.getId()) {
                                            matched.add(r);
                                        }
                                    }

                                    if (matched.size() != 0) {
                                        for (Rental s : matched) {
                                            QueryRental.updateHeld(s.getId(), customer.getId(), false);
                                        }

                                        updateTable();
                                    } else {
                                        ConfirmBox.display(
                                                "Held",
                                                "The user " + Styling.formatNames(customer) +
                                                        " (ID: " + customer.getId() +
                                                        ") hasn't held any movies for pick-up.",
                                                "OK",
                                                "Cancel"
                                        );
                                    }
                                } else {
                                    ConfirmBox.display(
                                            "Error finding User",
                                            "Couldn't find user by ID " + choice[1],
                                            "OK",
                                            "Cancel"
                                    );
                                }

                            } catch (SQLException ignored) {
                            }
                        } else {
                            try {
                                Movie movie = QueryMovie.findMovie(choice[0]);

                                if (movie != null) {
                                    ArrayList<Rental> matched = new ArrayList<>();
                                    //TODO
                                    for (Rental r : held) {
                                        if (r.getMovie().getId() == movie.getId()) {
                                            matched.add(r);
                                        }
                                    }

                                    if (matched.size() != 0) {
                                        HashSet<Integer> customers = new HashSet<>();

                                        for (Rental r : matched) customers.add(r.getCustomerId());
                                        System.out.println(customers);

                                        if (customers.size() == 1) {
                                            for (Rental s : matched) {
                                                if (customers.contains(s.getCustomerId())) {
                                                    QueryRental.updateHeld(s.getId(), s.getCustomerId(), false);
                                                }
                                            }
                                        } else {
                                            try {
                                                int customerId = Integer.parseInt(Objects.requireNonNull(CustomerBox.display(customers)));
                                                for (Rental s : matched) {
                                                    if (s.getCustomerId() == customerId) {
                                                        QueryRental.updateHeld(s.getId(), s.getCustomerId(), false);
                                                    }
                                                }
                                            } catch (Exception n) {
                                                ConfirmBox.display(
                                                        "Error", "Bad formatting in CustomerBox: " + n.getMessage(),
                                                        "OK", "Cancel");
                                            }
                                        }

                                        updateTable();
                                    } else {
                                        ConfirmBox.display(
                                                "Held",
                                                "The movie " + movie.getTitle() + " (ID: " + movie.getId() +
                                                        ") hasn't been held for pick-up",
                                                "OK",
                                                "Cancel"
                                        );
                                    }
                                } else {
                                    ConfirmBox.display(
                                            "Error finding Movie",
                                            "Couldn't find movie by ID " + choice[0],
                                            "OK",
                                            "Cancel"
                                    );
                                }
                            } catch (SQLException ignored) {
                            }
                        }
                    } catch (SQLException ignored) {
                    }
                }
            }
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
