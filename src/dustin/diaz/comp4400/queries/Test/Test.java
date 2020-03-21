package dustin.diaz.comp4400.queries.Test;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.queries.*;
import dustin.diaz.comp4400.utils.Computer;

import java.sql.SQLException;

public class Test {
    public static void main(String[] args) throws InterruptedException, SQLException {
        DustinDiazCOMP4400.connect.start();
        DustinDiazCOMP4400.connect.join();
        System.out.println(QueryDirectors.test() ? "+ Query Table Directors Tests PASSED!" : "- Query Table Directors Tests FAILED!");
        System.out.println(QueryWriters.test() ? "+ Query Table Writers Tests PASSED!" : "- Query Table Writers Tests FAILED!");
        System.out.println(QueryCast.test() ? "+ Query Table Cast Tests PASSED!" : "- Query Table Cast Tests FAILED!");
        System.out.println(QueryGenre.test() ? "+ Query Table Genre Tests PASSED!" : "- Query Table Genre Tests FAILED!");
        System.out.println(QueryAccountType.test() ? "+ Query Table Account Type Tests PASSED!" : "- Query Table Account Type Tests FAILED!");
        Computer.connection.close();
    }
}
