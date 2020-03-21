package dustin.diaz.comp4400.model.child;

public class Medias {
    public String type;
    private int id;

    public Medias() {
    }

    public Medias(String type, int id) {
        this.type = type;
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
                ", media=" + type +
                '}';
    }
}
