package SQL.easy.MovieRelated;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

public class WritersTableToSQL {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/easy/movies.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();
        HashSet<String> set = new HashSet<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                String[] values = e.split(";")[2].split(","); //writers
                set.addAll(Arrays.asList(values));
            });
        }

        ArrayList<String> sorted = new ArrayList<>(set);
        Collections.sort(sorted);
        sorted.remove(2);
        for (String s : sorted) {
            if (s.equals("writers")) continue;
            arr.add(new String[] {
                    s.trim(), //directors
            });
        }


        //String query = "INSERT INTO Movie (Title, Directors, Writers, ReleaseDate, Genre, RunTime, Rated, Cast, Ratings, Filename) VALUES (";
        //                                      x0    x1            2     x 3          4       x5      x6      7      x8       x9
        String query = "INSERT INTO Writers (Name) VALUES (";
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

    public static <T> ArrayList<T> removeDuplicates(ArrayList<T> list)
    {

        // Create a new LinkedHashSet
        Set<T> set = new LinkedHashSet<>();

        // Add the elements to set
        set.addAll(list);

        // Clear the list
        list.clear();

        // add the elements of set
        // with no duplicates to the list
        list.addAll(set);

        // return the list
        return list;
    }
}
