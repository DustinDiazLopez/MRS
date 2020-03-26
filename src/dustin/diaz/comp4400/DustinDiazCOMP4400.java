package dustin.diaz.comp4400;

import dustin.diaz.comp4400.utils.Computer;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.io.File;
import java.io.IOException;

public class DustinDiazCOMP4400 extends Application {

    public static final String USERNAME = "root";
    public static final String PASSWORD = "s0m3t1m3s1h@t3p@ssw0rds";
    public static Scene scene;
    public static Stage stage;
    public static boolean finished = false;

    public DustinDiazCOMP4400() {
        new Thread(() -> {
            Computer.favicon = new Image(new File("src/Images/icons/favicon/favicon-32x32.png").toURI().toString());
            Computer.starImage = new Image(new File("src/Images/icons/star.png").toURI().toString());
            Computer.placeholderImage = new Image(new File("src/Images/icons/placeholder.jpg").toURI().toString());
            Computer.loginImage = new Image(new File("src/Images/icons/app/012-line.png").toURI().toString());
            Computer.maskImage = new Image(new File("src/Images/icons/app/010-mask.png").toURI().toString());
            Computer.chairImage = new Image(new File("src/Images/icons/app/015-chair.png").toURI().toString());
            Computer.src = new File("src").getAbsolutePath();
            Computer.pathChar = Computer.src.contains("\\") ? "\\" : "/";
            Computer.movieImagePath = Computer.src + Computer.pathChar + "Images" + Computer.pathChar + "movies" + Computer.pathChar;
        }).start();
    }

    @Override
    public void start(Stage stage) throws Exception {
        Parent root = FXMLLoader.load(getClass().getResource("view/user/login.fxml"));
        scene = new Scene(root);
        DustinDiazCOMP4400.stage = stage;
        stage.setScene(scene);
        stage.setTitle("Dustin Díaz (A00548394) COMP4400 - Movie Rental System");
        stage.getIcons().add(Computer.favicon);

        stage.setOnCloseRequest(e -> {
            e.consume();
            Computer.closeProgram();
        });
        stage.show();
        finished = true;
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(Computer.loadFXML(fxml));
    }

    public static void main(String[] args) {
        launch(args);
    }
    
}
