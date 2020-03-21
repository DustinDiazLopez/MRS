package dustin.diaz.comp4400.queries;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.queries.child.*;
import dustin.diaz.comp4400.queries.connectors.*;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.queries.parent.QueryMovie;
import dustin.diaz.comp4400.queries.parent.QueryRental;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.DriverManager;
import java.sql.SQLException;

public class Test {
    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        run();
    }

    public static void run() throws SQLException, ClassNotFoundException {
        Class.forName(Database.DRIVER);
        Computer.connection = DriverManager.getConnection(Database.URL, DustinDiazCOMP4400.USERNAME, DustinDiazCOMP4400.PASSWORD);
        System.out.println("Connected to Database: " + Database.DB);
        System.out.println("With driver: " + Database.DRIVER);
        System.out.println("URL: " + Database.URL);
        System.out.println("RUNNING Tests on Database {");
        System.out.println(QueryDirectors.test() ? "\t+ Query Table Directors Tests: OK" : "\t\t- Query Table Directors Tests FAILED!");
        System.out.println(QueryWriters.test() ? "\t+ Query Table Writers Tests: OK" : "\t\t- Query Table Writers Tests FAILED!");
        System.out.println(QueryCast.test() ? "\t+ Query Table Cast Tests: OK" : "\t\t- Query Table Cast Tests FAILED!");
        System.out.println(QueryGenre.test() ? "\t+ Query Table Genre Tests: OK" : "\t\t- Query Table Genre Tests FAILED!");
        System.out.println(QueryAccountType.test() ? "\t+ Query Table Account Type Tests: OK" : "\t\t- Query Table Account Type Tests FAILED!");
        System.out.println(QueryMedias.test() ? "\t+ Query Table Media Tests: OK" : "\t\t- Query Table Media Tests FAILED!");
        System.out.println(QueryMovieDirector.test() ? "\t+ Query Table Movie-Director Tests: OK" : "\t\t- Query Table Movie-Director Tests FAILED!");
        System.out.println(QueryMovieWriters.test() ? "\t+ Query Table Movie-Writers Tests: OK" : "\t\t- Query Table Movie-Writers Tests FAILED!");
        System.out.println(QueryMovieCast.test() ? "\t+ Query Table Movie-Cast Tests: OK" : "\t\t- Query Table Movie-Cast Tests FAILED!");
        System.out.println(QueryMovieGenre.test() ? "\t+ Query Table Movie-Genre Tests: OK" : "\t\t- Query Table Movie-Genre Tests FAILED!");
        System.out.println(QueryMovieRental.test() ? "\t+ Query Table Movie-Rental Tests: OK" : "\t\t- Query Table Movie-Rental Tests FAILED!");
        System.out.println(QueryMovie.test() ? "\t+ Query Table Movie Tests: OK" : "\t\t- Query Table Movie Tests FAILED!");
        System.out.println(QueryRental.test() ? "\t+ Query Table Rental Tests: OK" : "\t\t- Query Table Rental Tests FAILED!");
        System.out.println(QueryCustomer.test() ? "\t+ Query Table Customer Tests: OK" : "\t\t- Query Table Customer Tests FAILED!");
        System.out.println("}");
        System.out.println("If tests fail reset database");
        Computer.connection.close();
        System.out.println("Testing was completed and the connection was closed.");
    }
}
