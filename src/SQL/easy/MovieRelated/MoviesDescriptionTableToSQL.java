package SQL.easy.MovieRelated;

import dustin.diaz.comp4400.model.parent.Movie;
import dustin.diaz.comp4400.queries.parent.QueryMovie;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class MoviesDescriptionTableToSQL {
    public static String movies(String tPath, String dPath) throws IOException, SQLException, InterruptedException {
        List<String[]> description = new ArrayList<>();
        List<String[]> titles = new ArrayList<>();

        try (Stream<String> stream = Files.lines(Paths.get(tPath))) {
            stream.forEach(e -> {
                String[] values = e.split(";");
                titles.add(new String[]{
                        values[0].trim().replaceAll("\"", "").replaceAll("'", "\\'"), //
                });
            });
        }

        try (Stream<String> stream = Files.lines(Paths.get(dPath))) {
            stream.forEach(e -> {
                String[] values = e.split(";");
                description.add(new String[]{
                        values[0].trim().replaceAll("\"", "").replaceAll("'", "\\'"), //
                });
            });
        }

        ArrayList<String> td = new ArrayList<>();
        ArrayList<String> notFound = new ArrayList<>();
        String query = "UPDATE Movies SET Description = '{}' WHERE ID = {};";

        for (int i = 0; i < titles.size(); i++) {
            Movie m = QueryMovie.findMovie(titles.get(i)[0]);

            if (m != null) {
                td.add(format(query, description.get(i)[0].replace("'", "\\'"), QueryMovie.findMovie(titles.get(i)[0]).getId() + ""));
            } else {
                System.out.println(titles.get(i)[0] + ";" + description.get(i)[0].replace("'", "\\'"));
            }
        }

        StringBuilder builder = new StringBuilder();

//        for (String s : td) {
//            builder.append(s).append("\n");
//        }

        return "";
    }

    private static String format(String txt, String... args) {
        for (String arg : args) txt = txt.replaceFirst("\\{}", arg);
        return txt;
    }
}
