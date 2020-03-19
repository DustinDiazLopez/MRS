package dustin.diaz.comp4400.model;

import java.sql.Date;
import java.util.Arrays;

public class Movie {
    private int id;
    String title;
    String[] directors;
    String[] writers;
    Date releaseDate;
    String genre;
    String runTime;
    String rated;
    String[] cast;
    String rating;
    String fileName;

    public Movie() {}

    public Movie(int id, String title, String[] directors, String[] writers, Date releaseDate, String genre,
                 String runTime, String rated, String[] cast, String rating, String fileName) {
        this.id = id;
        this.title = title;
        this.directors = directors;
        this.writers = writers;
        this.releaseDate = releaseDate;
        this.genre = genre;
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

    public String[] getDirectors() {
        return directors;
    }

    public void setDirectors(String[] directors) {
        this.directors = directors;
    }

    public String[] getWriters() {
        return writers;
    }

    public void setWriters(String[] writers) {
        this.writers = writers;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
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

    public String[] getCast() {
        return cast;
    }

    public void setCast(String[] cast) {
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
                ", directors=" + Arrays.toString(directors) +
                ", writers=" + Arrays.toString(writers) +
                ", releaseDate=" + releaseDate +
                ", genre='" + genre + '\'' +
                ", runTime='" + runTime + '\'' +
                ", rated='" + rated + '\'' +
                ", cast=" + Arrays.toString(cast) +
                ", rating='" + rating + '\'' +
                ", fileName='" + fileName + '\'' +
                '}';
    }
}
