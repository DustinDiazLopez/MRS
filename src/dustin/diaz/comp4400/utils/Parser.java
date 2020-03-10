package dustin.diaz.comp4400.utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

public class Parser {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/movies.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                arr.add(e.split(";"));
            });
        }

        String query = "INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (";
        String end = ");";

        arr.remove(0);
        AtomicReference<StringBuilder> stringBuilder = new AtomicReference<>(new StringBuilder());


        arr.forEach(e -> {
            for (int i = 0; i < e.length; i++) {
                String attribute = e[i].replaceAll("'", "");

                if (i == e.length - 1)
                    stringBuilder.get().append("'").append(attribute).append("'");
                 else
                    stringBuilder.get().append("'").append(attribute).append("',");
            }

            System.out.println(query + stringBuilder.toString() + end);
            stringBuilder.set(new StringBuilder());
        });
    }
}
