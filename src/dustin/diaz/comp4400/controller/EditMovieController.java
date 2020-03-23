package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.child.Cast;
import dustin.diaz.comp4400.model.child.Directors;
import dustin.diaz.comp4400.model.child.Genres;
import dustin.diaz.comp4400.model.child.Writers;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.queries.child.QueryCast;
import dustin.diaz.comp4400.queries.child.QueryDirectors;
import dustin.diaz.comp4400.queries.child.QueryGenre;
import dustin.diaz.comp4400.queries.child.QueryWriters;
import dustin.diaz.comp4400.queries.connectors.QueryMovieCast;
import dustin.diaz.comp4400.queries.connectors.QueryMovieDirector;
import dustin.diaz.comp4400.queries.connectors.QueryMovieGenre;
import dustin.diaz.comp4400.queries.connectors.QueryMovieWriters;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
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
import javafx.scene.input.Dragboard;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.stage.FileChooser;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.ResourceBundle;

public class EditMovieController implements Initializable {

    private final String placeholderImage = Computer.movieImagePath + "placeholder.jpg";
    private final String[] formats = "png,jpg,jpeg,tiff,bmp,gif".toLowerCase().split(",");
    @FXML
    private Label manCast;
    @FXML
    private TextField directors;
    @FXML
    private Label manGenres;
    @FXML
    private Button chooseFileBtn;
    @FXML
    private TextField rating;
    @FXML
    private Label manRated;
    @FXML
    private Label manRating;
    @FXML
    private TextField title;
    @FXML
    private Button addBtn;
    @FXML
    private TextField cast;
    @FXML
    private TextField genres;
    @FXML
    private Label manReleaseDate;
    @FXML
    private VBox imageVBox;
    @FXML
    private Label warning;
    @FXML
    private TextField runTime;
    @FXML
    private Label manWriters;
    @FXML
    private Button cancelBtn;
    @FXML
    private DatePicker releaseDate;
    @FXML
    private Label manDirector;
    @FXML
    private TextField fileLocation;
    @FXML
    private Label manRunTime;
    @FXML
    private BorderPane borderPane;
    @FXML
    private TextField rated;
    @FXML
    private ImageView movieImage;
    @FXML
    private Label manTitle;
    @FXML
    private TextField writers;
    private File chosen;

    @FXML
    void addMovie(ActionEvent event) throws SQLException, IOException {
        setTextBlank(manTitle, manWriters, manDirector, manGenres, manRunTime, manRated, manRating, manReleaseDate, manCast);
        setStyleBlank(title, writers, directors, genres, runTime, rated, cast, rating);
        releaseDate.setStyle("");

        String t = title.getText();
        String d = directors.getText();
        LocalDate rd = releaseDate.getValue();
        String g = genres.getText();
        String w = writers.getText();
        String rt = runTime.getText();
        String ate = rated.getText();
        String c = cast.getText();
        String ting = rating.getText();
        File src = chosen;

        boolean valid = true;

        if (isEmpty(t)) {
            title.setStyle(Styling.error);
            manTitle.setText("*");
            valid = false;
        }

        if (isEmpty(d)) {
            directors.setStyle(Styling.error);
            manDirector.setText("*");
            valid = false;
        }

        if (isEmpty(w)) {
            writers.setStyle(Styling.error);
            manWriters.setText("*");
            valid = false;
        }

        if (rd == null) {
            releaseDate.setStyle(Styling.error);
            manReleaseDate.setText("*");
            valid = false;
        }

        if (isEmpty(g)) {
            genres.setStyle(Styling.error);
            manGenres.setText("*");
            valid = false;
        }

        if (isEmpty(rt)) {
            runTime.setStyle(Styling.error);
            manRunTime.setText("*");
            valid = false;
        }

        if (isEmpty(ate)) {
            rated.setStyle(Styling.error);
            manRated.setText("*");
            valid = false;
        }

        if (isEmpty(c)) {
            cast.setStyle(Styling.error);
            manCast.setText("*");
            valid = false;
        }

        if (isEmpty(ting)) {
            rating.setStyle(Styling.error);
            manRating.setText("*");
            valid = false;
        }

        String oldTitle = Computer.editMovie.getTitle();
        int id = Computer.editMovie.getId();


        if (isEmpty(fileLocation.getText())) {
            fileLocation.setPromptText("The default image will be used");
            src = new File(placeholderImage);
        } else {
            File newFilePath = new File(fileLocation.getText());
            src = Computer.copyFileToFolder(newFilePath);
            File old = new File(Computer.movieImagePath + Computer.editMovie.getFileName());
            if (!old.getAbsolutePath().equals(placeholderImage)) {
                if (old.delete()) System.out.println("Deleted old image file");
            }
        }

        if (valid) {
            boolean same = t.equals(oldTitle);
            boolean exists = QueryMovie.findMovie(t) != null;

            String filename = src.getName();

            if (same || !exists) {
                if (QueryMovie.update(id, t, Date.valueOf(rd.toString()), rt, ate, ting, filename) == 1) {
                    int movieId = QueryMovie.findMovieID(t);
                    //Genres
                    String[] genres = g.split(",");
                    ArrayList<Genres> movieGenres = new ArrayList<>();
                    for (String s : genres) {
                        try {
                            QueryGenre.insertGenre(s);                  //inserts
                            movieGenres.add(QueryGenre.findGenre(s));   //finds inserted
                        } catch (Exception e) {
                            System.out.println("Genre '" + s + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    for (Genres gens : movieGenres) {
                        try {
                            QueryMovieGenre.insert(movieId, gens.getId()); //Creates the relationship
                        } catch (Exception e) {
                            System.out.println("MovieGenre '" + movieId + "-" + gens + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    //Cast
                    String[] cast = c.split(",");
                    ArrayList<Cast> movieCast = new ArrayList<>();
                    for (String s : cast) {
                        try {
                            QueryCast.insertCast(s);                  //inserts
                            movieCast.add(QueryCast.findCast(s));    //finds inserted
                        } catch (Exception e) {
                            System.out.println("Cast '" + s + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    for (Cast cas : movieCast) {
                        try {
                            QueryMovieCast.insert(movieId, cas.getId()); //Creates the relationship
                        } catch (Exception e) {
                            System.out.println("MovieCast '" + movieId + "-" + cas + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    //Writers
                    String[] writers = w.split(",");
                    ArrayList<Writers> movieWriters = new ArrayList<>();
                    for (String s : writers) {
                        try {
                            QueryWriters.insertWriter(s);                  //inserts
                            movieWriters.add(QueryWriters.findWriter(s));    //finds inserted
                        } catch (Exception e) {
                            System.out.println("Writer '" + s + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    for (Writers wri : movieWriters) {
                        try {
                            QueryMovieWriters.insert(movieId, wri.getId()); //Creates the relationship
                        } catch (Exception e) {
                            System.out.println("MovieWriter '" + movieId + "-" + wri + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    //Directors
                    String[] directors = d.split(",");
                    ArrayList<Directors> movieDirectors = new ArrayList<>();
                    for (String s : directors) {
                        try {
                            QueryDirectors.insertDirector(s);                  //inserts
                            movieDirectors.add(QueryDirectors.findDirector(s));    //finds inserted
                        } catch (Exception e) {
                            System.out.println("Director '" + s + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    for (Directors di : movieDirectors) {
                        try {
                            QueryMovieDirector.insert(movieId, di.getId()); //Creates the relationship
                        } catch (Exception e) {
                            System.out.println("MovieDirector '" + movieId + "-" + di + "' already exists. Skipping... \n\tMessage: " + e.getMessage());
                        }
                    }

                    cancelBtn.fire();
                } else {
                    cancelBtn.fire();
                    ConfirmBox.display("Insert Failed", "Failed to create movie.");
                }
            } else {
                warning.setText("* A movie with this title already exists. Try adding the year next to it.");
                title.setStyle(Styling.error);
                manTitle.setText("*");
            }
        } else {
            warning.setText("* These are mandatory fields");
        }
    }

    private void setTextBlank(Label... labels) {
        for (Label label : labels) label.setText("");
    }

    private void setStyleBlank(TextField... fields) {
        for (TextField field : fields) field.setStyle("");
    }

    private boolean isEmpty(String string) {
        return string.trim().isEmpty();
    }

    @FXML
    void cancel(ActionEvent event) {
        Computer.changeScreen(borderPane, "movietable");
    }

    @FXML
    void findFile(ActionEvent event) {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Select Movie Poster");
        fileChooser.setInitialDirectory(new File(Computer.movieImagePath));
        chosen = fileChooser.showOpenDialog(DustinDiazCOMP4400.stage);
        validateFile();
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        Movie movie = Computer.editMovie;
        setImage(placeholderImage);

        imageVBox.setOnDragOver(event -> {
            if (event.getGestureSource() != imageVBox && event.getDragboard().hasFiles()) {
                event.acceptTransferModes(TransferMode.COPY_OR_MOVE);
            }
            event.consume();
        });

        imageVBox.setOnDragDropped(e -> {
            Dragboard db = e.getDragboard();
            boolean success = false;
            if (db.hasFiles()) {
                chosen = db.getFiles().get(0);
                validateFile();
                success = true;
            }

            e.setDropCompleted(success);
            e.consume();
        });

        EventHandler<KeyEvent> enterKey = e -> {
            if (e.getCode().toString().equals("ENTER")) addBtn.fire();
        };

        title.setOnKeyPressed(enterKey);
        title.setText(movie.getTitle());

        directors.setOnKeyPressed(enterKey);
        System.out.println(movie.getDirectors());
        directors.setText(directorsAsString(movie.getDirectors()));

        writers.setOnKeyPressed(enterKey);
        writers.setText(writersAsString(movie.getWriters()));

        releaseDate.setOnKeyPressed(enterKey);
        releaseDate.setValue(movie.getReleaseDate().toLocalDate());

        genres.setOnKeyPressed(enterKey);
        genres.setText(movie.getGenres());

        runTime.setOnKeyPressed(enterKey);
        runTime.setText(movie.getRunTime());

        rated.setOnKeyPressed(enterKey);
        rated.setText(movie.getRated());

        cast.setOnKeyPressed(enterKey);
        cast.setText(castsAsString(movie.getCast()));

        rating.setOnKeyPressed(enterKey);
        rating.setText(movie.getRating());

        fileLocation.setOnKeyPressed(enterKey);
        fileLocation.setText(Computer.movieImagePath + movie.getFileName());
        setImage(Computer.movieImagePath + movie.getFileName());

        addBtn.setOnKeyPressed(enterKey);
        cancelBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) cancelBtn.fire();
        });
        chooseFileBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) chooseFileBtn.fire();
        });

    }

    private String directorsAsString(ArrayList<Directors> directors) {
        StringBuilder builder = new StringBuilder();
        for (Directors c : directors) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        return s.substring(0, s.length() - 1);
    }

    private String writersAsString(ArrayList<Writers> writers) {
        StringBuilder builder = new StringBuilder();
        for (Writers c : writers) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        return s.substring(0, s.length() - 1);
    }

    private String castsAsString(ArrayList<Cast> casts) {
        StringBuilder builder = new StringBuilder();
        for (Cast c : casts) {
            builder.append(c.getName()).append(",");
        }
        String s = builder.toString();
        return s.substring(0, s.length() - 1);
    }

    public void validateFile() {
        if (chosen != null) {
            if (chosen.isFile()) {
                if (isImage(chosen)) {
                    fileLocation.setText(chosen.getAbsolutePath());
                    setImage(chosen.getAbsolutePath());
                } else {
                    chosen = new File(placeholderImage);
                    setImage(placeholderImage);
                    int index = chosen.getAbsolutePath().indexOf('.') + 1;
                    String ends = chosen.getAbsolutePath().substring(index);
                    warning.setText("Not a supported file. Input: [" + ends + "] Expected: " + Arrays.toString(formats));
                }
            } else chosen = new File(placeholderImage);
        } else chosen = new File(placeholderImage);
    }

    public void setImage(String path) {
        movieImage.setImage(new Image(new File(path).toURI().toString()));
        movieImage.setPreserveRatio(true);
    }

    private boolean isImage(File file) {
        if (file.isFile()) {
            for (String extension : formats) {
                if (file.getAbsolutePath().endsWith("." + extension)) {
                    return true;
                }
            }
        }
        return false;
    }
}
