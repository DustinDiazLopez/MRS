package dustin.diaz.comp4400.model;

public class Medias {
    public Media media;
    private int id;

    public Medias() {
    }

    public Medias(int id, Media media) {
        this.id = id;
        this.media = media;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Media getMedia() {
        return media;
    }

    public void setMedia(Media media) {
        this.media = media;
    }

    @Override
    public String toString() {
        return "Medias{" +
                "id=" + id +
                ", media=" + media +
                '}';
    }

    public enum Media {
        DVD,
        BLU_RAY
    }
}
