package SQL.easy;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.UUID;

public class Download {
    public static ArrayList<String> getImages(ArrayList<String> urls) throws InterruptedException {
        ArrayList<String> paths = new ArrayList<>();
        String path = "C:\\Users\\dudia\\Desktop\\University\\Year 3\\Ene - May 2020\\2 COMP4400 System Development and Implementation\\Dustin-Diaz-COMP4400\\src\\Images\\icons\\download\\";
        String name;
        for (int i = 0; i < urls.size(); i++) {
            name = path + UUID.randomUUID().toString() + ".jpg";
            image(urls.get(i), name);
            paths.add(new File(name).getAbsolutePath());
            System.out.println((i + 1) + " of " + urls.size());
            if ((i + 1) == urls.size()) break;
            Thread.sleep(5000);
        }

        return paths;
    }

    private static void image(String url, String path) {
        try (InputStream in = new URL(url).openStream()) {
            Files.copy(in, Paths.get(path));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
