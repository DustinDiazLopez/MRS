package SQL.easy;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class Clean {
    public static void main(String[] args) throws IOException {
        File fileName = new File("src/SQL/new.sql");
        String newText = txt(fileName.getAbsolutePath())
                .replaceAll("fk", "FK")
                .replaceAll("_has_", "_")
                .replaceAll("45", "70")
                .replaceAll("`", "")
                .replaceAll("MovieRentalSystem\\.", "")
                .replaceAll("ENGINE = InnoDB", "")
                .replaceAll(" ;", ";")
                .replaceAll("-- -----------------------------------------------------", "")
                .replaceAll("--", "####################################################################################"
                .replaceAll("1", ""));
        System.out.println(newText);
        //txt(fileName, newText);
    }

    public static String txt(String path) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();

        try (Stream<String> stream = Files.lines(Paths.get(path))) {

            for (Object s : stream.toArray()) {
                if (s.toString().contains("# SCHEMA END")) {
                    stringBuilder.append(s.toString()).append("\n");
                    break;
                }
                stringBuilder.append(s.toString()).append("\n");
            }
        }

        return stringBuilder.toString();
    }

    public static void txt(File file, String text) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(file, "UTF-8");
        writer.println(text);
        writer.close();
    }
}
