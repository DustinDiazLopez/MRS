package dustin.diaz.comp4400;

import dustin.diaz.comp4400.utils.Computer;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.awt.*;

public class DustinDiazCOMP4400 extends Application {
    public static Scene scene;
    public static Stage stage;
    public static boolean finished = false;

    public static void main(String[] args) {
        Computer.init();
        launch(args);
    }

    @Override
    public void start(Stage stage) throws Exception {
        DustinDiazCOMP4400.scene = new Scene(Computer.loadFXML("view/user/login.fxml"));
        stage.setScene(scene);
        stage.setHeight(744);
        stage.setWidth(1040);

        Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
        if (d.width <= 1024 && d.height <= 768) stage.setMaximized(true);

        stage.setTitle("COMP4400: Dustin Díaz (A00548394) - MANA - Movie Rental System");

        stage.setOnCloseRequest(e -> {
            e.consume();
            Computer.closeProgram();
        });

        stage.getIcons().add(Computer.favicon);
        DustinDiazCOMP4400.stage = stage;
        stage.show();
        finished = true;
        System.out.println(stage.getWidth() + "," + stage.getHeight());
    }
}
