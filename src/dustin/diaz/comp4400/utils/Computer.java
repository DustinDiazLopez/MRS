package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;

import java.io.IOException;

public abstract class Computer {
    public static String src;
    public static String pathChar;

    public static void closeProgram() {
        boolean answer = ConfirmBox.display("Close Application", "Are you sure you want to quit?");
        if (answer) System.exit(0);
    }

    public static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(DustinDiazCOMP4400.class.getResource(fxml));
        return fxmlLoader.load();
    }
}
