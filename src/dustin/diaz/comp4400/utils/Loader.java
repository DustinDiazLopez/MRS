package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.Pane;

import java.io.IOException;
import java.net.URL;

public class Loader {
    private Pane view;

    public Pane getFXML(String filename) throws IOException {
        URL fileUrl = DustinDiazCOMP4400.class.getResource("src/view/" + filename);

        if (fileUrl == null) {
            throw new java.io.FileNotFoundException(filename + " was not found.");
        }

        view = FXMLLoader.load(fileUrl);

        return view;
    }
}
