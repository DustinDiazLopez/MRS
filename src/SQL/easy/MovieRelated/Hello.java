package SQL.easy.MovieRelated;

import SQL.easy.Download;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class Hello {
    public static void main(String[] args) throws IOException, InterruptedException {
        String fileName = new File("src/SQL/easy/movies2.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();
        ArrayList<String> urls = new ArrayList<>();
        ArrayList<String> lines = new ArrayList<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                lines.add(e);
                String[] row = e.substring(0, e.length() - 1).split(";");
                arr.add(row);
            });
        }

        for (String[] strings : arr) {
            urls.add(strings[strings.length - 1]);
        }

        ArrayList<String> paths = Download.getImages(urls);

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < lines.size(); i++) {
            builder.append(lines.get(i)).append(";").append(paths.get(i)).append(";");
        }

        String s = builder.toString();
        System.out.println(s);
        wq(new File("src/SQL/easy/MovieRelated/movies3.txt"), s);
    }

    public static void wq(File file, String text) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(file, "UTF-8");
        writer.println(text);
        writer.close();
    }
}
