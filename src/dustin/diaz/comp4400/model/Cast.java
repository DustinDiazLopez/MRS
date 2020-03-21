package dustin.diaz.comp4400.model;

public class Cast {
    private int id;
    private String name;

    public Cast() {
    }

    public Cast(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Cast{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
