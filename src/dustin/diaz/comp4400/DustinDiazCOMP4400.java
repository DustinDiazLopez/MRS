package dustin.diaz.comp4400;

import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Query;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.io.File;
import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DustinDiazCOMP4400 extends Application {

    private static String url = "jdbc:mysql://localhost:3306/";
    private static String driver = "com.mysql.cj.jdbc.Driver";
    private static String dbName = "rental";
    private static String username = "root";
    private static String password = "s0m3t1m3s1h@t3p@ssw0rds";

    private Thread connect = new Thread(() -> {
        try {
            Class.forName(driver);
            Computer.connection = DriverManager.getConnection(url + dbName, username, password);
            Computer.src = new File("src").getAbsolutePath();
            Computer.pathChar = Computer.src.contains("\\") ? "\\" : "/";
            Computer.movieImagePath = Computer.src + Computer.pathChar + "Images" + Computer.pathChar + "movies" + Computer.pathChar;
        } catch (Exception e) {
            e.printStackTrace();
        }
    });

    public static Scene scene;

    @Override
    public void start(Stage stage) throws Exception {
        connect.start();

        Parent root = FXMLLoader.load(getClass().getResource("view/user/login.fxml"));
        scene = new Scene(root);
        stage.setScene(scene);
        stage.setTitle("Movie Rental System");
        stage.getIcons().add(new Image(new File("src/Images/icons/favicon/android-chrome-512x512.png").toURI().toString()));

        stage.setOnCloseRequest(e -> {
            e.consume();
            try {
                Computer.closeProgram();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        });

        connect.join();
        stage.show();

        System.out.println(Query.findUserByUsername("root"));
        System.out.println(Query.findUserByUsername("errt"));
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(Computer.loadFXML(fxml));
    }

    public static void main(String[] args) {
        launch(args);
    }
    
}
