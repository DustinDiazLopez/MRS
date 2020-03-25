package dustin.diaz.comp4400;

import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.sql.DriverManager;

public class DustinDiazCOMP4400 extends Application {

    public static final String USERNAME = "root";
    public static final String PASSWORD = "s0m3t1m3s1h@t3p@ssw0rds";
    private static final int MIN_WIDTH = 1100;
    private static final int MIN_HEIGHT = 900;

    public DustinDiazCOMP4400() {
        Computer.favicon = new Image(new File("src/Images/icons/favicon/favicon-32x32.png").toURI().toString());
        Computer.src = new File("src").getAbsolutePath();
        Computer.pathChar = Computer.src.contains("\\") ? "\\" : "/";
        Computer.movieImagePath = Computer.src + Computer.pathChar + "Images" + Computer.pathChar + "movies" + Computer.pathChar;
    }

    public static Thread connect = new Thread(() -> {
        try {
            Class.forName(Database.DRIVER);
            Computer.connection = DriverManager.getConnection(Database.URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            ConfirmBox.display("DB Connection", "Could not establish connection to database.");
            e.printStackTrace();
        }
    });

    public static Scene scene;
    public static Stage stage;

    @Override
    public void start(Stage stage) throws Exception {
        connect.start();

        Parent root = FXMLLoader.load(getClass().getResource("view/user/login.fxml"));
        scene = new Scene(root);
        DustinDiazCOMP4400.stage = stage;
        stage.setScene(scene);
        stage.setTitle("Dustin Díaz (A00548394) COMP4400 - Movie Rental System");
        stage.getIcons().add(Computer.favicon);

        stage.setMinHeight(MIN_HEIGHT);
        stage.setMinWidth(MIN_WIDTH);

        if (Toolkit.getDefaultToolkit().getScreenSize().width > 1440) {
            stage.setWidth(MIN_WIDTH);
            stage.setHeight(MIN_HEIGHT);
        } else stage.setMaximized(true);

        stage.setOnCloseRequest(e -> {
            e.consume();
            Computer.closeProgram();
        });

        connect.join();
        stage.show();
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(Computer.loadFXML(fxml));
    }

    public static void main(String[] args) {
        launch(args);
    }
    
}
