package dustin.diaz.comp4400.model.child;

public class Directors {
    private int id;
    private String name;

    public Directors() {
    }

    public Directors(int id, String name) {
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
        return "Directors{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
