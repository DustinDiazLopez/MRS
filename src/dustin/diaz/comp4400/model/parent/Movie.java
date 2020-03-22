package dustin.diaz.comp4400.model.parent;

import dustin.diaz.comp4400.model.child.Cast;
import dustin.diaz.comp4400.model.child.Directors;
import dustin.diaz.comp4400.model.child.Genres;
import dustin.diaz.comp4400.model.child.Writers;

import java.sql.Date;
import java.util.ArrayList;

public class Movie {
    private int id;
    String title;
    ArrayList<Directors> directors;
    ArrayList<Writers> writers;
    Date releaseDate;
    ArrayList<Genres> genres;
    String runTime;
    String rated;
    ArrayList<Cast> cast;
    String rating;
    String fileName;

    public Movie() {
    }

    public Movie(String title, Date releaseDate, String runTime, String rated, String rating, String fileName) {
        this.title = title;
        this.releaseDate = releaseDate;
        this.runTime = runTime;
        this.rated = rated;
        this.rating = rating;
        this.fileName = fileName;
    }

    public Movie(int id, String title, ArrayList<Directors> directors, ArrayList<Writers> writers, Date releaseDate,
                 ArrayList<Genres> genres, String runTime, String rated, ArrayList<Cast> cast, String rating,
                 String fileName) {
        this.id = id;
        this.title = title;
        this.directors = directors;
        this.writers = writers;
        this.releaseDate = releaseDate;
        this.genres = genres;
        this.runTime = runTime;
        this.rated = rated;
        this.cast = cast;
        this.rating = rating;
        this.fileName = fileName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public ArrayList<Directors> getDirectors() {
        return directors;
    }

    public void setDirectors(ArrayList<Directors> directors) {
        this.directors = directors;
    }

    public ArrayList<Writers> getWriters() {
        return writers;
    }

    public void setWriters(ArrayList<Writers> writers) {
        this.writers = writers;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getGenres() {
        return genres.toString().substring(1, genres.toString().length() - 1);
    }

    public void setGenres(ArrayList<Genres> genres) {
        this.genres = genres;
    }

    public String getRunTime() {
        return runTime;
    }

    public void setRunTime(String runTime) {
        this.runTime = runTime;
    }

    public String getRated() {
        return rated;
    }

    public void setRated(String rated) {
        this.rated = rated;
    }

    public ArrayList<Cast> getCast() {
        return cast;
    }

    public void setCast(ArrayList<Cast> cast) {
        this.cast = cast;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public String toString() {
        return "Movie{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", directors=" + directors +
                ", writers=" + writers +
                ", releaseDate=" + releaseDate +
                ", genres=" + genres +
                ", runTime='" + runTime + '\'' +
                ", rated='" + rated + '\'' +
                ", cast=" + cast +
                ", rating='" + rating + '\'' +
                ", fileName='" + fileName + '\'' +
                '}';
    }
}
