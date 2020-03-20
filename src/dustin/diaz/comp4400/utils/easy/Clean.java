package dustin.diaz.comp4400.utils.easy;

import java.io.*;

public class Clean {
    public static void main(String[] args) throws IOException {
        File fileName = new File("src/SQL/new.sql");
        String newText = txt(fileName.getAbsolutePath());
        System.out.println(newText
                .replaceAll("fk", "FK")
                .replaceAll("1", "")
                .replaceAll("_has_", "_")
                .replaceAll("45", "70")
        );
        //txt(fileName, newText);
    }

    public static String txt(String path) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        FileReader fr = new FileReader(path);
        BufferedReader br = new BufferedReader(fr);

        int i;
        while ((i = br.read()) != -1) stringBuilder.append((char) i);

        br.close();
        fr.close();

        return stringBuilder.toString();
    }

    public static void txt(File file, String text) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(file, "UTF-8");
        writer.println(text);
        writer.close();
    }
}