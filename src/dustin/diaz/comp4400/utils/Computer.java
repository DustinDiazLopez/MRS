package dustin.diaz.comp4400.utils;

import dustin.diaz.comp4400.DBINFO;
import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.concurrent.Service;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;

import java.awt.*;
import java.awt.event.InputEvent;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public abstract class Computer {
    public static String src;
    public static String fileSeparator;
    public static String movieImagePath;
    public static Connection connection;
    public static Customer customer;
    public static Customer editCustomer;
    public static Movie editMovie;
    public static Image loginImage;
    public static Image maskImage;
    public static Image chairImage;
    public static Image favicon;
    public static Image starImage;
    public static Image placeholderImage;

    public static void closeProgram() {
        if (ConfirmBox.display("Close Application", "Are you sure you want to quit?")) {
            try {
                connection.close();
            } catch (Exception ignored) {
                System.exit(1);
            }
            System.exit(0);
        }
    }

    public static Parent loadFXML(String fxml) throws IOException {
        return FXMLLoader.load(DustinDiazCOMP4400.class.getResource(fxml));
    }

    private static FXService<Void> fxService = new FXService<>();

    public static void sceneEscape() {
        DustinDiazCOMP4400.scene.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ESCAPE")) Computer.closeProgram();
        });
    }

    public static void changeScreen(BorderPane borderPane, String viewUserFilename) {
        Computer.sceneEscape();
        borderPane.getChildren().clear();
        try {
            viewUserFilename = viewUserFilename.endsWith(".fxml") ? viewUserFilename : viewUserFilename + ".fxml";
            Computer.setRoot("view/user/" + viewUserFilename);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }


    public static void changeScreen(AnchorPane anchorPane, String viewUserFilename) {
        try {
            anchorPane.getChildren().clear();
            viewUserFilename = viewUserFilename.endsWith(".fxml") ? viewUserFilename : viewUserFilename + ".fxml";
            Computer.setRoot("view/user/" + viewUserFilename);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    private static List<String> listFiles(File file) {
        if (file.isDirectory()) {
            try (Stream<Path> walk = Files.walk(Paths.get(file.getAbsolutePath()))) {
                return walk.filter(Files::isRegularFile).map(Path::toString).collect(Collectors.toList());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return null;
    }

    private static void copy(File src, File dest) throws IOException {
        try (InputStream is = new FileInputStream(src); OutputStream os = new FileOutputStream(dest)) {
            byte[] buf = new byte[1024];
            int bytesRead;
            while ((bytesRead = is.read(buf)) > 0) {
                os.write(buf, 0, bytesRead);
            }
        }
    }

    private static File copyFileToFolder(File src, File dest) throws IOException {
        if (src.isFile() && dest.isDirectory()) {
            String destination = dest.getAbsolutePath();
            List<String> files = listFiles(dest);
            String name = src.getName();

            if (files != null) {
                for (String s : files) {
                    if (new File(s).getName().equals(name)) {
                        name = UUID.randomUUID() + ".jpg";
                    }
                }
            }

            File location = new File(destination + Computer.fileSeparator + name);
            copy(src, location);
            return location;
        } else return null;
    }

    public static File copyFileToFolder(File src) throws IOException {
        return copyFileToFolder(src, new File(movieImagePath));
    }

    public static Service<Void> service = fxService.setAll(() -> {
        try {
            setRoot("view/user/login.fxml");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            fxService.countDown();
        }
    }, new CountDownLatch(1));

    public static void setRoot(String fxml) throws IOException {
        Parent page = Computer.loadFXML(fxml);
        DustinDiazCOMP4400.scene.setRoot(page);
    }

    public static void init() {
        new Thread(() -> {
            Computer.favicon = new Image(new File("src/Images/icons/favicon/favicon-32x32.png").toURI().toString());
            Computer.loginImage = new Image(new File("src/Images/icons/app/012-line.png").toURI().toString());
            Computer.starImage = new Image(new File("src/Images/icons/star.png").toURI().toString());
            Computer.placeholderImage = new Image(new File("src/Images/icons/placeholder.jpg").toURI().toString());
            Computer.maskImage = new Image(new File("src/Images/icons/app/010-mask.png").toURI().toString());
            Computer.chairImage = new Image(new File("src/Images/icons/app/015-chair.png").toURI().toString());
            Computer.src = new File("src").getAbsolutePath();
            Computer.fileSeparator = System.getProperty("file.separator");
            Computer.movieImagePath = Computer.src + Computer.fileSeparator + "Images" + Computer.fileSeparator + "movies" + Computer.fileSeparator;
        }).start();
    }

    private static void write(File file, String text) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(file, "UTF-8");
        writer.println(text);
        writer.close();
    }

    private static String read(String path) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        FileReader fr = new FileReader(path);
        BufferedReader br = new BufferedReader(fr);

        int i;
        while ((i = br.read()) != -1) stringBuilder.append((char) i);

        br.close();
        fr.close();

        return stringBuilder.toString();
    }

    private static String replace(String txt, String... args) {
        for (String arg : args) txt = txt.replaceFirst("\\{}", arg);
        return txt;
    }

    public static void click(int x, int y) throws AWTException {
        Robot bot = new Robot();
        bot.mouseMove(x, y);
        bot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
        bot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
    }
}
