package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.model.tables.RentalTable;
import dustin.diaz.comp4400.queries.child.QueryMedias;
import dustin.diaz.comp4400.queries.connectors.QueryMovieRental;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Details;
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
    private ArrayList<RentalTable> table;

    public void updateTable() {
        try {
            tableView.getItems().clear();
            tableView.getColumns().clear();
            tableView.setPlaceholder(new Label("No rentals to display."));
            TableColumn<String, RentalTable> i = new TableColumn<>("ID");
            i.setCellValueFactory(new PropertyValueFactory<>("rentalId"));

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

            tableView.getColumns().add(i);
            tableView.getColumns().add(id);
            tableView.getColumns().add(title);
            tableView.getColumns().add(releaseDate);
            tableView.getColumns().add(genre);
            tableView.getColumns().add(runTime);

            table = QueryRental.getAllForTable();
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
                        Customer customer = QueryCustomer.find(choice[1]);
                        Movie movie = QueryMovie.findMovie(choice[0]);
                        int media = QueryMedias.findMedia(MediaBox.display(movie)).getId();
                        Date date = Date.valueOf(LocalDate.now().toString());
                        Rental q = QueryRental.insertAndReturn(customer.getId(), media, date, false);
                        System.out.println(movie.getTitle() + " (" + media + ") rented by " + customer.getUsername() + " on " + date);
                        System.out.println("Insert " + q);
                        QueryMovieRental.insert(movie.getId(), q.getId());
                        System.out.println(QueryRental.find(q.getId()));
                        //TODO make the connection with user and movie
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
                                            } catch (Exception ignored) {
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
            int id = ReturnsBox.display("movie");

            if (id != -1) {
                try {
                    System.out.println("Return Movie ID: " + id);
                    ArrayList<Rental> returnable = QueryRental.find(table);

                    if (returnable.size() != 0) {
                        ArrayList<Rental> matched = new ArrayList<>();

                        for (Rental rental : returnable) {
                            if (rental.getMovie().getId() == id) matched.add(rental);
                        }

                        if (matched.size() != 0) {
                            if (matched.size() == 1) {
                                Rental rental = updateRental(matched.get(0));
                                if (ShowRentalDetailsBox.display(rental)) {
                                    QueryRental.update(
                                            rental.getId(),
                                            rental.getCustomerId(),
                                            true,
                                            rental.getReturnedOn(),
                                            rental.getTotalDays(),
                                            rental.getTotalCost()
                                    );
                                }
                            } else {
                                int rentalId = ReturnsBox.display("rental");
                                for (Rental rental : matched) {
                                    if (rental.getId() == rentalId) {
                                        if (ShowRentalDetailsBox.display(updateRental(rental))) {
                                            QueryRental.update(
                                                    rental.getId(),
                                                    rental.getCustomerId(),
                                                    true,
                                                    rental.getReturnedOn(),
                                                    rental.getTotalDays(),
                                                    rental.getTotalCost()
                                            );
                                            break;
                                        }
                                    }
                                }
                            }

                            updateTable();
                        }
                    } else {
                        warning.setText("There is nothing to return.");
                    }

                } catch (SQLException ex) {
                    ex.printStackTrace();
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
                if (event.getButton().equals(MouseButton.PRIMARY) && event.getClickCount() == 2) {
                    String title = selected.getMovie().getTitle() + " (" + selected.getMedia().getType() + ")";
                    String customerName = "";
                    try {
                        customerName = " for " + Styling.formatNames(QueryCustomer.find(selected.getCustomerId()));
                    } catch (SQLException ignored) {
                    }

                    if (ConfirmBox.display("Return Movie", "Would you like to return " + title + customerName + "?")) {
                        try {
                            Rental rental = updateRental(selected);
                            if (ShowRentalDetailsBox.display(rental)) {
                                QueryRental.update(
                                        rental.getId(),
                                        rental.getCustomerId(),
                                        true,
                                        rental.getReturnedOn(),
                                        rental.getTotalDays(),
                                        rental.getTotalCost()
                                );
                                updateTable();
                            }
                        } catch (Exception err) {
                            err.printStackTrace();
                        }
                    }
                }
            }
        });

        updateTable();
    }

    public Rental updateRental(Rental rental) {
        Date rentedOn = rental.getRentedOn();
        Date returnedOn = Date.valueOf(LocalDate.now().toString());
        float cost = Details.getPrice(rental.getMedia());
        int totalDays = Details.inBetween(rentedOn, returnedOn);
        if (totalDays == 0) totalDays = 1;
        float totalCost = totalDays * cost;
        rental.setReturnedOn(returnedOn);
        rental.setTotalCost(totalCost);
        rental.setTotalDays(totalDays);
        rental.setReturned(true);
        rental.setHeld(false);
        return rental;
    }
}
