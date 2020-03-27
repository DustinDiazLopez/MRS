package dustin.diaz.comp4400;

import dustin.diaz.comp4400.utils.Computer;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.awt.*;
import java.io.IOException;

public class DustinDiazCOMP4400 extends Application {
    public static Scene scene;
    public static Stage stage;
    public static boolean finished = false;

    public static void main(String[] args) {
        Computer.init();
        launch(args);
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(Computer.loadFXML(fxml));
    }

    @Override
    public void start(Stage stage) throws Exception {
        Parent root = FXMLLoader.load(getClass().getResource("view/user/login.fxml"));
        scene = new Scene(root);
        DustinDiazCOMP4400.stage = stage;
        stage.setScene(scene);
        stage.setTitle("Dustin Díaz (A00548394) COMP4400 - MANA - Movie Rental System");

        Dimension dimension = Toolkit.getDefaultToolkit().getScreenSize();
        if (dimension.height == scene.getHeight() && dimension.width == scene.getWidth()) {
            stage.setMaximized(true);
        }

        stage.setOnCloseRequest(e -> {
            e.consume();
            Computer.closeProgram();
        });

        //stage.initStyle(StageStyle.UNDECORATED);
        stage.getIcons().add(Computer.favicon);
        stage.show();
        finished = true;
    }
    
}
