package dustin.diaz.comp4400.model;

public class Medias {
    public String media;
    private int id;

    public Medias() {
    }

    public Medias(String media, int id) {
        this.media = media;
        this.id = id;
    }

    public String getMedia() {
        return media;
    }

    public void setMedia(String media) {
        this.media = media;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Medias{" +
                "id=" + id +
                ", media=" + media +
                '}';
    }
}
