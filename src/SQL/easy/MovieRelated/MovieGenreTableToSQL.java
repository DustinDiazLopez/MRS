package SQL.easy.MovieRelated;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Stream;

public class MovieGenreTableToSQL {
    public static void main(String[] args) throws IOException {
        String fileName = new File("src/SQL/easy/movies3.txt").getAbsolutePath();
        List<String[]> arr = new ArrayList<>();
        HashSet<String> set = new HashSet<>();

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            stream.forEach(e -> {
                String[] values = e.split(";")[4].split(","); //genre
                for (String s : values) set.add(s.trim());
            });
        }

        List<String> sorted = new ArrayList<>(set);
        Collections.sort(sorted);

        for (String s : sorted) {
            if (s.equals("genre")) continue;
            arr.add(new String[] {
                    s.trim(), //directors
            });
        }

        String query = "INSERT INTO MovieGenres (MovieID,GenreID) VALUES (";
        String end = ");";

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            Object[] o = stream.toArray();
            for (int i = 0; i < o.length; i++) {
                if (o[i].toString().contains("genre;")) continue;
                for (int j = 0; j < sorted.size(); j++) {
                    if (o[i].toString().contains(sorted.get(j))) {
                        int director = (j + 1);
                        System.out.println(query + i + "," + director + end + " # " + o[i].toString().split(";")[0] + " is " + sorted.get(j));
                    }
                }
            }
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
