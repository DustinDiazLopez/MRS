package SQL.easy.MovieRelated;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

public class MoviesTableToSQL {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/easy/movies3.txt").getAbsolutePath();
        System.out.println(movies(fileName));
    }

    public static String movies(String fileName) throws IOException {
        List<String[]> arr = new ArrayList<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                String[] values = e.split(";");
                arr.add(new String[]{
                        values[0].trim(), //title
                        values[3].trim(), //release date
                        values[5].trim(), //Runtime
                        values[6].trim(), //rated
                        values[8].trim().replace(",", "") + "/10", //Ratings
                        new File(values[9]).getName().trim(), //filename
                });
            });
        }

        //String query = "INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (";
        //                                      x0    1            2     x 3          4       x5      x6      7      x8       x9
        String query = "INSERT INTO Movies (Title,ReleaseDate,RunTime,Rated,Ratings,Filename) VALUES (";
        String end = ");";

        arr.remove(0);
        AtomicReference<StringBuilder> stringBuilder = new AtomicReference<>(new StringBuilder());

        StringBuilder sql = new StringBuilder();
        for (int i = 0; i < arr.size(); i++) {
            String[] e = arr.get(i);
            for (int j = 0; j < e.length; j++) {
                String attribute = e[j].trim();

                if (j == e.length - 1)
                    stringBuilder.get().append("'").append(attribute).append("'");
                else
                    stringBuilder.get().append("'").append(attribute).append("',");
            }

            sql.append(query).append(stringBuilder.toString()).append(end).append(" #").append(i + 1).append("\n");
            stringBuilder.set(new StringBuilder());
        }

        return sql.toString();
    }
}
