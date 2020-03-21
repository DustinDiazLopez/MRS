package SQL.easy.MovieRelated;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

public class CastTableToSQL {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/easy/movies.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();
        HashSet<String> set = new HashSet<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                String[] values = e.split(";")[7].split(","); //cast
                set.addAll(Arrays.asList(values));
            });
        }

        List<String> sorted = new ArrayList<>(set);
        Collections.sort(sorted);

        for (String s : sorted) {
            if (s.equals("cast")) continue;
            arr.add(new String[] {
                    s.trim(),
            });
        }

        //String query = "INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (";
        //                                      x0    x1            2     x 3          4       x5      x6      7      x8       x9
        String query = "INSERT INTO Cast (Name) VALUES (";
        String end = ");";

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
