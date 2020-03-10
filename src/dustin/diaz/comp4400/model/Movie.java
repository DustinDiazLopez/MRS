package dustin.diaz.comp4400.model;

import java.sql.Date;

public class Movie {
    private int id;
    String title;
    String director;
    String writers;
    Date releaseDate;
    String genre;
    String runTime;
    String rated;
    String cast;

    public Movie(int id, String title, String director, String writers, Date releaseDate,
                 String genre, String runTime, String rated, String cast) {
        this.id = id;
        this.title = title;
        this.director = director;
        this.writers = writers;
        this.releaseDate = releaseDate;
        this.genre = genre;
        this.runTime = runTime;
        this.rated = rated;
        this.cast = cast;
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

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getWriters() {
        return writers;
    }

    public void setWriters(String writers) {
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

    public String getCast() {
        return cast;
    }

    public void setCast(String cast) {
        this.cast = cast;
    }

    @Override
    public String toString() {
        return "Movie{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", director='" + director + '\'' +
                ", writers='" + writers + '\'' +
                ", releaseDate=" + releaseDate +
                ", genre='" + genre + '\'' +
                ", runTime='" + runTime + '\'' +
                ", rated='" + rated + '\'' +
                ", cast='" + cast + '\'' +
                '}';
    }
}
