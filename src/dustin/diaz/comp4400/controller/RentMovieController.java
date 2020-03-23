package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.model.child.Cast;
import dustin.diaz.comp4400.model.child.Directors;
import dustin.diaz.comp4400.model.child.Genres;
import dustin.diaz.comp4400.model.child.Writers;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.model.parent.Rental;
import dustin.diaz.comp4400.queries.child.QueryGenre;
import dustin.diaz.comp4400.queries.child.QueryMedias;
import dustin.diaz.comp4400.queries.connectors.QueryMovieRental;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.ScrollPane;
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
    private BorderPane borderPane;

    @FXML
    private ImageView movieImage;

    @FXML
    private VBox leftVBox;

    @FXML
    private Label informationLabel;

    @FXML
    private TextFlow writersTextFlow;

    private Movie selected;

    @FXML
    private ComboBox<String> sortByGenre;


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
        Customer customer = Computer.customer;
        Movie movie = selected;
        int mediaId = QueryMedias.findMedia(media).getId();
        Rental rental = QueryRental.insertAndReturn(customer.getId(), mediaId, Date.valueOf(LocalDate.now()), false);
        QueryRental.updateHeld(rental.getId(), rental.getCustomerId(), true);
        QueryMovieRental.insert(movie.getId(), rental.getId());
        //TODO confirmation
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        Image star = new Image(new File("src/Images/icons/star.png").toURI().toString());
        Image placeholder = new Image(new File("src/Images/icons/placeholder.jpg").toURI().toString());
        starImage.setImage(star);
        movieImage.setImage(placeholder);

        try {
            ArrayList<Movie> movies = QueryMovie.findAllMovies();
            ArrayList<String> genres = asArray(QueryGenre.findAllGenres());
            sortByGenre.setItems(FXCollections.observableArrayList(genres));

            sortByGenre.setOnAction(e -> {
                try {
                    ArrayList<Movie> all = QueryMovie.findAllMovies();
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
                } catch (Exception i) {
                    i.printStackTrace();
                }
            });

            display(movies.get(0));
            selected = movies.get(0);
            updateMovieList(movies);
        } catch (Exception e) {
            System.out.println(e.getLocalizedMessage());
        }
    }

    private ArrayList<String> asArray(ArrayList<Genres> genres) {
        ArrayList<String> list = new ArrayList<>();
        list.add("All");
        for (Genres g : genres) list.add(g.getGenre());
        return list;
    }

    private void updateMovieList(ArrayList<Movie> movies) {
        leftVBox.getChildren().clear();
        leftVBox.getChildren().addAll(generateView(movies));
    }

    private ScrollPane generateView(ArrayList<Movie> movies) {
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
    }

    private HBox generateRow(Movie... movies) {
        HBox hBox = new HBox(10);
        for (Movie movie : movies) {
            hBox.getChildren().add(generateElement(movie));
        }
        return hBox;
    }

    private VBox generateElement(Movie movie) {
        int width = 182;
        int height = 268;
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
        if (!movie.getRating().contains("/10")) starImage.setOpacity(.25);
        else starImage.setOpacity(1);
        informationLabel.setText(movie.getRated() + " | " + movie.getRunTime() + " | " + movie.getGenres() + " | " + movie.getReleaseDate());
    }

    private void setDWCText(Movie movie) {
        Text directors = new Text(directorsAsString(movie.getDirectors()) + "\n");
        Text writers = new Text(writersAsString(movie.getWriters()) + "\n");
        Text cast = new Text(castsAsString(movie.getCast()) + "\n");
        directorsTextFlow.getChildren().clear();
        directorsTextFlow.getChildren().addAll(directors);
        writersTextFlow.getChildren().clear();
        writersTextFlow.getChildren().addAll(writers);
        castTextFlow.getChildren().clear();
        castTextFlow.getChildren().addAll(cast);
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
}
