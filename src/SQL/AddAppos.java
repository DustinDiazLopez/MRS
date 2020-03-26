package SQL;

import java.io.*;

public class AddAppos {
    public static void main(String[] args) throws IOException {
        File file = new File("src/SQL/easy/movies3.txt");
        String s = r(file.getAbsolutePath()).replaceAll(" \\([a-zA-Z ]\\)", "");
        w(file, s);
    }

    public static void w(File file, String text) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(file, "UTF-8");
        writer.println(text);
        writer.close();
    }

    public static String r(String path) throws IOException {
        StringBuilder stringBuilder = new StringBuilder();
        FileReader fr = new FileReader(path);
        BufferedReader br = new BufferedReader(fr);

        int i;
        while ((i = br.read()) != -1) stringBuilder.append((char) i);

        br.close();
        fr.close();

        return stringBuilder.toString();
    }
}
