package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class Computer {
    public static String src;
    public static String pathChar;
    public static String movieImagePath;
    public static Connection connection;
    public static Customer customer;

    public static void closeProgram() {
        boolean answer = ConfirmBox.display("Close Application", "Are you sure you want to quit?");
        if (answer) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.exit(0);
        }
    }

    public static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(DustinDiazCOMP4400.class.getResource(fxml));
        return fxmlLoader.load();
    }

    public static void openImageFolder() throws IOException {
        Desktop.getDesktop().open(new File(Computer.movieImagePath));
    }
}
