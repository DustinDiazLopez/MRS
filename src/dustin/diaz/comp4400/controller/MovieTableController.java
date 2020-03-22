package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
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
import java.util.ResourceBundle;

public class MovieTableController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private Button refreshBtn;

    @FXML
    private Button deleteButton;

    @FXML
    private Button editButton;

    @FXML
    private Button backBtn;

    @FXML
    private TableView tableView;

    @FXML
    private Button addBtn;

    @FXML
    private Label warning;

    private Movie selected = null;

    public void updateTable() {
        try {
            tableView.getItems().clear();
            tableView.getItems().addAll(QueryMovie.findAllMovies());
            warning.setText("");
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
                Movie c = selected;
                String name = c.getTitle();
                if (ConfirmBox.display(
                        "Delete " + name,
                        "Are you sure you want to DELETE movie '" + name + "' " + "(ID: " + c.getId() + ")")) {
                    try {
                        QueryMovie.delete(c.getId());
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

        editButton.setOnMousePressed(e -> {
            warning.setText("");
            tableView.setStyle("");

            if (selected == null) {
                warning.setText("Select a movie to EDIT its information.");
                tableView.setStyle(Styling.error);
            } else {
                try {
                    Computer.editMovie = QueryMovie.findMovie(selected.getId());
                    Computer.changeScreen(borderPane, "editmovie");
                } catch (SQLException ignored) {
                    ConfirmBox.display("An error occurred", "Couldn't execute query");
                }
            }
        });

        editButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) editButton.fire();
        });

        tableView.setOnMousePressed(e -> selected = (Movie) tableView.getSelectionModel().getSelectedItem());

        tableView.setOnMouseClicked(event -> {
            String e = event.toString();
            if (!e.contains("target = TableColumnHeader") && !e.contains("target = Label") && selected != null) {
                if (event.getButton().equals(MouseButton.SECONDARY)) {
                    String choice = ChooseBox.display(selected.getTitle(), "" + selected.getId());

                    if (choice != null) {
                        Movie c = selected;
                        String name = selected.getTitle();

                        if (choice.equals("Edit")) {
                            try {
                                Computer.editMovie = QueryMovie.findMovie(selected.getId());
                                Computer.changeScreen(borderPane, "editmovie");
                            } catch (SQLException ignored) {
                                ConfirmBox.display("An error occured", "Couldn't execute query");
                            }
                        } else if (choice.equals("Delete")) {
                            if (ConfirmBox.display(
                                    "Delete " + name,
                                    "Are you sure you want to DELETE movie '" + name + "' " + "(ID: " + c.getId() + ")?")) {
                                try {
                                    QueryMovie.delete(c.getId());
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
                    String name = selected.getTitle();
                    if (ConfirmBox.display("Edit " + name,
                            "Would you like to EDIT " + name + " (ID:" + selected.getId() + ")?")) {
                        try {
                            Computer.editMovie = QueryMovie.findMovie(selected.getId());
                            Computer.changeScreen(borderPane, "editmovie");
                        } catch (SQLException ignored) {
                            ConfirmBox.display("An error occured", "Couldn't execute query");
                        }
                    }
                }
            }
        });

        tableView.setPlaceholder(new Label("No customers to display."));

        TableColumn<String, Movie> id = new TableColumn<>("ID");
        id.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<String, Movie> title = new TableColumn<>("Title");
        title.setCellValueFactory(new PropertyValueFactory<>("title"));

        TableColumn<String, Movie> releaseDate = new TableColumn<>("Release Date");
        releaseDate.setCellValueFactory(new PropertyValueFactory<>("releaseDate"));

        TableColumn<String, Movie> genre = new TableColumn<>("Genres");
        genre.setCellValueFactory(new PropertyValueFactory<>("genres"));

        TableColumn<String, Movie> runTime = new TableColumn<>("Run Time");
        runTime.setCellValueFactory(new PropertyValueFactory<>("runTime"));

        TableColumn<String, Movie> rated = new TableColumn<>("Rated");
        rated.setCellValueFactory(new PropertyValueFactory<>("rated"));

        HBox.setHgrow(tableView, Priority.ALWAYS);


        tableView.getColumns().add(id);
        tableView.getColumns().add(title);
        tableView.getColumns().add(releaseDate);
        tableView.getColumns().add(genre);
        tableView.getColumns().add(runTime);
        tableView.getColumns().add(rated);


        updateTable();
    }
}
