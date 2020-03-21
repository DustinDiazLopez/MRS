package dustin.diaz.comp4400.queries.Test;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.queries.*;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.DriverManager;
import java.sql.SQLException;

public class Test {
    public static void main(String[] args) throws InterruptedException, SQLException, ClassNotFoundException {
        run();
    }

    public static void run() throws InterruptedException, SQLException, ClassNotFoundException {
        Class.forName(Database.DRIVER);
        Computer.connection = DriverManager.getConnection(Database.URL, DustinDiazCOMP4400.USERNAME, DustinDiazCOMP4400.PASSWORD);
        System.out.println("Connected to Database: " + Database.DB);
        System.out.println("With driver: " + Database.DRIVER);
        System.out.println("On URL: " + Database.URL);
        System.out.println("RUNNING Tests on Database {");
        System.out.println(QueryDirectors.test() ? "\t+ Query Table Directors Tests PASSED!" : "\t\t- Query Table Directors Tests FAILED!");
        System.out.println(QueryWriters.test() ? "\t+ Query Table Writers Tests PASSED!" : "\t\t- Query Table Writers Tests FAILED!");
        System.out.println(QueryCast.test() ? "\t+ Query Table Cast Tests PASSED!" : "\t\t- Query Table Cast Tests FAILED!");
        System.out.println(QueryGenre.test() ? "\t+ Query Table Genre Tests PASSED!" : "\t\t- Query Table Genre Tests FAILED!");
        System.out.println(QueryAccountType.test() ? "\t+ Query Table Account Type Tests PASSED!" : "\t\t- Query Table Account Type Tests FAILED!");
        System.out.println(QueryMedias.test() ? "\t+ Query Table Media Tests PASSED!" : "\t\t- Query Table Media Tests FAILED!");
        System.out.println("}");
        Computer.connection.close();
        System.out.println("Testing was completed and the connection was closed.");
    }
}
