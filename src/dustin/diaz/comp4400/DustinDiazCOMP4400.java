package dustin.diaz.comp4400;

import dustin.diaz.comp4400.model.User;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Query;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DustinDiazCOMP4400 extends Application {

    public static Connection connection;
    private static String url = "jdbc:mysql://localhost:3306/";
    private static String driver = "com.mysql.cj.jdbc.Driver";
    private static String dbName = "rental";
    private static String username = "root";
    private static String password = "s0m3t1m3s1h@t3p@ssw0rds";

    private Thread initDB = new Thread(() -> {
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(url + dbName, username, password);

            PreparedStatement preparedStatement = connection.prepareStatement(Query.allUsers);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<User> users = new ArrayList<>();

            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("ID"));
                user.setFirstName(resultSet.getString("FirstName"));
                user.setLastName(resultSet.getString("LastName"));
                users.add(user);
            }

            users.forEach(System.out::println);

            preparedStatement = connection.prepareStatement(Query.userByID);
            preparedStatement.setInt(1, 1);
            resultSet = preparedStatement.executeQuery();
            users = new ArrayList<>();


            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("ID"));
                user.setFirstName(resultSet.getString("FirstName"));
                user.setLastName(resultSet.getString("LastName"));
                users.add(user);
            }

            System.out.println("Found" + users.get(0));

            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    });

    @Override
    public void start(Stage stage) throws Exception {
        initDB.start();
        Computer.src = new File("src").getAbsolutePath();
        Computer.pathChar = Computer.src.contains("\\") ? "\\" : "/";
        System.out.println(Computer.src);
        System.out.println(Computer.pathChar);
        Parent root = FXMLLoader.load(getClass().getResource("view/sample.fxml"));
        Scene scene = new Scene(root);
        stage.setScene(scene);
        initDB.join();
        stage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
    
}
