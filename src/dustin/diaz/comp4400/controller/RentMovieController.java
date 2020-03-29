package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.child.*;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.queries.child.QueryGenre;
import dustin.diaz.comp4400.queries.child.QueryMedias;
import dustin.diaz.comp4400.queries.connectors.QueryMovieRental;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.FXService;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import dustin.diaz.comp4400.view.boxes.ShowPickupDetailsBox;
import javafx.collections.FXCollections;
import javafx.concurrent.Service;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;

import java.io.File;
import java.net.URL;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.ResourceBundle;
import java.util.concurrent.CountDownLatch;

public class RentMovieController implements Initializable {

    @FXML
    private Label ratingLabel;

    @FXML
    private Label titleLabel;

    @FXML
    private TextFlow castTextFlow;

    @FXML
    private ImageView starImage;

    @FXML
    private TextFlow directorsTextFlow;

    @FXML
    private TextFlow descriptionTextFlow;

    @FXML
    private BorderPane borderPane;

    @FXML
    private ImageView movieImage;

    @FXML
    private VBox leftVBox;

    @FXML
    private HBox rightHBox;

    @FXML
    private Label informationLabel;

    @FXML
    private TextFlow writersTextFlow;

    private Movie selected;

    @FXML
    private ComboBox<String> sortByGenre;

    @FXML
    private DatePicker reservationDate;

    @FXML
    void home(ActionEvent event) {
        Computer.changeScreen(borderPane, "userhome");
    }

    @FXML
    void holdDVD(ActionEvent event) throws SQLException {
        holdForPickup("DVD");
    }

    @FXML
    void holdBluRay(ActionEvent event) throws SQLException {
        holdForPickup("BLU-RAY");
    }

    private void holdForPickup(String media) throws SQLException {
        LocalDate date = reservationDate.getValue();
        if (date == null) {
            reservationDate.setStyle(Styling.error);
            boolean today = ConfirmBox.display(
                    "Provide Reservation Date",
                    "Please provide the date you will like to pick up the movie.",
                    "Pickup Today", "Ok", true);
            if (!today) {
                return;
            } else {
                date = LocalDate.now();
            }
        }
        Date resDate = Date.valueOf(date);
        Customer customer = Computer.customer;
        Movie movie = selected;
        Medias medias = QueryMedias.findMedia(media);
        Rental rental = new Rental();
        rental.setCustomerId(customer.getId());
        rental.setMovie(movie);
        rental.setMedia(medias);
        rental.setRentedOn(resDate);

        if (ShowPickupDetailsBox.display(rental)) {
            int mediaId = medias.getId();
            rental = QueryRental.insertAndReturn(customer.getId(), mediaId, resDate, false);
            QueryRental.updateHeld(rental.getId(), rental.getCustomerId(), true);
            QueryMovieRental.insert(movie.getId(), rental.getId());
        }
    }

    ArrayList<Movie> movies = new ArrayList<>();
    FXService<Void> fxService = new FXService<>();
    Service<Void> service = fxService.setAll(() -> {
        try {
            movies = QueryMovie.findAllMovies();
            updateMovieList(generateView(movies));
        } catch (SQLException e) {
            Computer.changeScreen(borderPane, "nomoviesfound");
            e.printStackTrace();
        } finally {
            fxService.countDown();
        }
    }, new CountDownLatch(1));

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        service.start();
        starImage.setImage(Computer.starImage);
        movieImage.setImage(Computer.placeholderImage);
        reservationDate.setDayCellFactory(picker -> new DateCell() {
            public void updateItem(LocalDate date, boolean empty) {
                super.updateItem(date, empty);
                LocalDate today = LocalDate.now();
                setDisable(empty || date.compareTo(today) < 0);
            }
        });

        reservationDate.setOnMouseClicked(e -> reservationDate.setStyle(""));

        try {
            movies = QueryMovie.findAllLimit();
            ArrayList<String> genres = asArray(QueryGenre.findAllGenres());
            sortByGenre.setItems(FXCollections.observableArrayList(genres));

            sortByGenre.setOnAction(e -> {
                try {
                    ArrayList<Movie> all = movies;

                    if (all != null) {
                        ArrayList<Movie> moviesGenre = new ArrayList<>();

                        if (!sortByGenre.getValue().equals("All")) {
                            for (Movie m : all) {
                                if (m.getGenres().contains(sortByGenre.getValue())) {
                                    moviesGenre.add(m);
                                }
                            }

                            updateMovieList(moviesGenre);
                        } else {
                            updateMovieList(all);
                        }
                    }
                } catch (Exception ignored) {
                    Computer.changeScreen(borderPane, "nomoviesfound");
                }
            });

            rightHBox.managedProperty().bind(rightHBox.visibleProperty());
            if (movies != null && movies.size() != 0) {
                try {
                    Movie m = movies.get(0);
                    display(m);
                    selected = m;
                    updateMovieList(movies);
                } catch (Exception e) {
                    e.printStackTrace();
                    Computer.changeScreen(borderPane, "nomoviesfound");
                }
            } else {
                rightHBox.setVisible(false);
            }
        } catch (Exception e) {
            System.out.println(e.getLocalizedMessage());
        } finally {
            fxService.countDown();
        }
    }

    private ArrayList<String> asArray(ArrayList<Genres> genres) {
        ArrayList<String> list = new ArrayList<>();
        list.add("All");
        for (Genres g : genres) list.add(g.getGenre().trim());
        return list;
    }

    private void updateMovieList(ScrollPane scrollPane) {
        leftVBox.getChildren().clear();
        leftVBox.getChildren().addAll(scrollPane);
    }

    private void updateMovieList(ArrayList<Movie> movies) {
        leftVBox.getChildren().clear();
        leftVBox.getChildren().addAll(generateView(movies));
    }

    private ScrollPane generateView(ArrayList<Movie> movies) {
        try {
            ScrollPane scroll = new ScrollPane();
            VBox vBox = new VBox();
            int size = movies.size();
            boolean add = false;

            if (size % 2 != 0) {
                size--;
                add = true;
            }

            for (int i = 0; i < size; i++) {
                vBox.getChildren().addAll(generateRow(movies.get(i), movies.get(++i)));
            }

            if (add) {
                vBox.getChildren().addAll(generateRow(movies.get(size)));
            }
            scroll.setContent(vBox);
            return scroll;
        } catch (Exception ignored) {
            Computer.changeScreen(borderPane, "nomoviesfound");
            return new ScrollPane();
        }
    }

    private HBox generateRow(Movie... movies) {
        HBox hBox = new HBox(10);
        for (Movie movie : movies) hBox.getChildren().add(generateElement(movie));
        return hBox;
    }

    private VBox generateElement(Movie movie) {
        int width = (int) (182 * Styling.imageFactor);
        int height = (int) (268 * Styling.imageFactor);
        double opacity = 0.85;
        VBox vBox = new VBox(10);
        Button details = new Button("Details");
        details.setPrefWidth(width);
        final ImageView image = new ImageView();
        image.setImage(image(Computer.movieImagePath + movie.getFileName()));
        image.setFitWidth(width);
        image.setFitHeight(height);
        image.setOnMouseClicked(e -> details.fire());
        vBox.setAlignment(Pos.CENTER);
        vBox.getChildren().addAll(image, details);
        vBox.setPadding(new Insets(5, 5, 5, 5));

        vBox.setStyle(Styling.homeStyle);
        vBox.opacityProperty().setValue(opacity);

        vBox.setOnMouseEntered(e -> {
            vBox.opacityProperty().setValue(1);
            vBox.setStyle(Styling.homeStyleHover);
        });

        vBox.setOnMouseExited(e -> {
            vBox.opacityProperty().setValue(opacity);
            vBox.setStyle(Styling.homeStyle);
        });

        vBox.setOnMouseClicked(e -> details.fire());

        details.setOnAction(e -> {
            selected = movie;
            display(movie);
        });
        return vBox;
    }

    private void display(Movie movie) {
        setInformationText(movie);
        setDWCText(movie);
    }

    private Image image(String path) {
        return new Image(new File(path).toURI().toString());
    }

    private void setInformationText(Movie movie) {
        titleLabel.setText(movie.getTitle());
        Image poster = image(Computer.movieImagePath + movie.getFileName());
        movieImage.setImage(poster);
        ratingLabel.setText(movie.getRating());
        starImage.setOpacity(ratingPercent(movie));
        informationLabel.setText(movie.getRated() + " | " + movie.getRunTime() + " | " + movie.getGenres() + " | " + movie.getReleaseDate());
    }

    private void setDWCText(Movie movie) {
        reservationDate.setStyle("");
        directorsTextFlow.getChildren().clear();
        directorsTextFlow.getChildren().addAll(new Text(directorsAsString(movie.getDirectors()) + "\n"));
        descriptionTextFlow.getChildren().clear();
        descriptionTextFlow.getChildren().addAll(new Text(movie.getDescription() + "\n"));
        writersTextFlow.getChildren().clear();
        writersTextFlow.getChildren().addAll(new Text(writersAsString(movie.getWriters()) + "\n"));
        castTextFlow.getChildren().clear();
        castTextFlow.getChildren().addAll(new Text(castsAsString(movie.getCast()) + "\n"));
    }

    private String directorsAsString(ArrayList<Directors> directors) {
        StringBuilder builder = new StringBuilder();
        for (Directors c : directors) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        s = s.substring(0, s.length() - 1).replaceAll(",", ", ");
        return repChar(s);
    }

    private String writersAsString(ArrayList<Writers> writers) {
        StringBuilder builder = new StringBuilder();
        for (Writers c : writers) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        s = s.substring(0, s.length() - 1).replaceAll(",", ", ");
        return repChar(s);
    }

    private String castsAsString(ArrayList<Cast> casts) {
        StringBuilder builder = new StringBuilder();
        for (Cast c : casts) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        s = s.substring(0, s.length() - 1).replaceAll(",", ", ");
        return repChar(s);
    }

    private String repChar(String s) {
        int idx = lastCharIdx(s.toCharArray());
        if (idx != -1) {
            return s.substring(0, idx + 1) + " and" + s.substring(idx + 1);
        }
        return s;
    }

    private int lastCharIdx(char[] array) {
        for (int counter = array.length - 1; counter >= 0; counter--) {
            if (array[counter] == ',') return counter;
        }

        return -1;
    }

    private double ratingPercent(Movie movie) {
        String rating = movie.getRating().trim();
        String str = rating.replace("/10", "");
        if (!rating.isEmpty() && rating.endsWith("/10") && str.replace(".", "").length() <= 2) {
            return Double.parseDouble(str) / 10d;
        }

        return 0;
    }
}
