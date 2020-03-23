package dustin.diaz.comp4400;

import dustin.diaz.comp4400.queries.Database;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import dustin.diaz.comp4400.view.boxes.NewRentalBox;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.File;
import java.io.IOException;
import java.sql.DriverManager;
import java.util.Arrays;

public class DustinDiazCOMP4400 extends Application {

    public static final String USERNAME = "root";
    public static final String PASSWORD = "s0m3t1m3s1h@t3p@ssw0rds";

    public static Thread connect = new Thread(() -> {
        try {
            Class.forName(Database.DRIVER);
            Computer.connection = DriverManager.getConnection(Database.URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            ConfirmBox.display("DB Connection", "Could not establish connection to database.");
            e.printStackTrace();
        }

        Computer.src = new File("src").getAbsolutePath();
        Computer.pathChar = Computer.src.contains("\\") ? "\\" : "/";
        Computer.movieImagePath = Computer.src + Computer.pathChar + "Images" + Computer.pathChar + "movies" + Computer.pathChar;
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
        stage.setTitle("Movie Rental System");
        stage.getIcons().add(Computer.favicon);

        stage.setMinHeight(900);
        stage.setMinWidth(1100);

        stage.setHeight(900);
        stage.setWidth(1100);

        stage.setOnCloseRequest(e -> {
            e.consume();
            Computer.closeProgram();
        });

        connect.join();
        stage.show();

        System.out.println(Arrays.toString(NewRentalBox.display()));
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(Computer.loadFXML(fxml));
    }

    public static void main(String[] args) {
        launch(args);
    }
    
}
