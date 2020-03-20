package SQL.easy.MovieRelated;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

public class MoviesTableToSQL {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/easy/movies.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                String[] values = e.split(";");
                arr.add(new String[] {
                        values[0], //title
                        values[3], //release date
                        values[5], //Runtime
                        values[6], //rated
                        values[8], //Ratings
                        values[9], //filename
                });
            });
        }

        //String query = "INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (";
        //                                      x0    1            2     x 3          4       x5      x6      7      x8       x9
        String query = "INSERT INTO Movies (Title, ReleaseDate, RunTime, Rated, Ratings, Filename) VALUES (";
        String end = ");";

        arr.remove(0);
        AtomicReference<StringBuilder> stringBuilder = new AtomicReference<>(new StringBuilder());


        for (int i = 0; i < arr.size(); i++) {
            String[] e = arr.get(i);
            for (int j = 0; j < e.length; j++) {
                String attribute = e[j];

                if (j == e.length - 1)
                    stringBuilder.get().append("'").append(attribute).append("'");
                 else
                    stringBuilder.get().append("'").append(attribute).append("',");
            }

            System.out.println(query + stringBuilder.toString() + end + " #" + (i + 1));
            stringBuilder.set(new StringBuilder());
        }
    }
}
