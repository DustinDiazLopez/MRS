package dustin.diaz.comp4400.controller;

import dustin.diaz.comp4400.DustinDiazCOMP4400;
import dustin.diaz.comp4400.model.parent.Customer;
import dustin.diaz.comp4400.queries.parent.QueryCustomer;
import dustin.diaz.comp4400.utils.Computer;
import dustin.diaz.comp4400.utils.Styling;
import dustin.diaz.comp4400.view.boxes.ChooseBox;
import dustin.diaz.comp4400.view.boxes.ConfirmBox;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.BorderPane;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class CustomerTableController implements Initializable {

    @FXML
    private BorderPane borderPane;

    @FXML
    private Button refreshBtn;

    @FXML
    private Button deleteButton;

    @FXML
    private Button editButton;

    @FXML
    private Button backBtn;

    @FXML
    private TableView tableView;

    @FXML
    private Button addBtn;

    @FXML
    private Label warning;

    private Customer selected = null;

    public void updateTable() {
        try {
            tableView.getItems().clear();
            tableView.getItems().addAll(QueryCustomer.findAll());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        try {
            Computer.customer = QueryCustomer.find(Computer.customer.getId());
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        borderPane.setMinSize(1100.0, 900.0);

        tableView.getColumns().clear();

        refreshBtn.setOnMousePressed(e -> updateTable());

        refreshBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) refreshBtn.fire();
        });

        backBtn.setOnMousePressed(e -> {
            borderPane.getChildren().clear();
            try {
                System.out.println(Computer.customer);
                Computer.customer = QueryCustomer.find(Computer.customer.getId());
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            try {
                DustinDiazCOMP4400.setRoot("view/user/adminhome.fxml");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });

        backBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) backBtn.fire();
        });

        addBtn.setOnMousePressed(e -> {
            try {
                Computer.customer = QueryCustomer.find(Computer.customer.getId());
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            try {
                borderPane.getChildren().clear();
                DustinDiazCOMP4400.setRoot("view/user/addaccount.fxml");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });

        addBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) addBtn.fire();
        });

        deleteButton.setOnMousePressed(e -> {
            warning.setText("");
            tableView.setStyle("");

            if (selected == null) {
                warning.setText("Select a user to delete them.");
                tableView.setStyle(Styling.error);
            } else {
                Customer c = selected;
                String name = Styling.formatNames(c.getFirstName(), c.getLastName());
                if (ConfirmBox.display(
                        "Delete " + name,
                        "Are you sure you want to delete user '" + name + "' " + "(ID: " + c.getId() + ")")) {
                    try {
                        QueryCustomer.delete(c.getId());
                        updateTable();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        });

        deleteButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) deleteButton.fire();
        });

        editButton.setOnMousePressed(e -> {
            warning.setText("");
            tableView.setStyle("");

            if (selected == null) {
                warning.setText("Select a user to edit their information.");
                tableView.setStyle(Styling.error);
            } else {
                Computer.editCustomer = selected;

                try {
                    borderPane.getChildren().clear();
                    DustinDiazCOMP4400.setRoot("view/user/editaccount.fxml");
                } catch (IOException ex) {
                    ex.printStackTrace();
                }

                updateTable();
            }
        });

        editButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) editButton.fire();
        });

        tableView.setOnMousePressed(e -> selected = (Customer) tableView.getSelectionModel().getSelectedItem());

        tableView.setOnMouseClicked(event -> {
            //TODO very click is inside table and check why this is not working
            if (event.getButton().equals(MouseButton.SECONDARY)) {
                String choice = ChooseBox.display(selected.getUsername());
                System.out.println(choice);
                if (choice.equals("Edit")) {
                    System.out.println("hello");
                    editButton.fire();
                } else if (choice.equals("Delete")) deleteButton.fire();
            } else if (event.getButton().equals(MouseButton.PRIMARY) && event.getClickCount() == 2) {
                System.out.println("hello");
                editButton.fire();
            }
        });

        tableView.setPlaceholder(new Label("No customers to display."));

        TableColumn<String, Customer> column = new TableColumn<>("ID");
        column.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<String, Customer> col = new TableColumn<>("Account Type");
        col.setCellValueFactory(new PropertyValueFactory<>("accountType"));

        TableColumn<String, Customer> column1 = new TableColumn<>("First Name");
        column1.setCellValueFactory(new PropertyValueFactory<>("firstName"));

        TableColumn<String, Customer> column2 = new TableColumn<>("Last Name");
        column2.setCellValueFactory(new PropertyValueFactory<>("lastName"));

        TableColumn<String, Customer> column3 = new TableColumn<>("Address");
        column3.setCellValueFactory(new PropertyValueFactory<>("address"));

        TableColumn<String, Customer> column4 = new TableColumn<>("City");
        column4.setCellValueFactory(new PropertyValueFactory<>("city"));

        TableColumn<String, Customer> column5 = new TableColumn<>("Zip Code");
        column5.setCellValueFactory(new PropertyValueFactory<>("zipCode"));

        TableColumn<String, Customer> column6 = new TableColumn<>("Phone");
        column6.setCellValueFactory(new PropertyValueFactory<>("phone"));


        tableView.getColumns().add(column);
        tableView.getColumns().add(column1);
        tableView.getColumns().add(column2);
        tableView.getColumns().add(column3);
        tableView.getColumns().add(column4);
        tableView.getColumns().add(column5);
        tableView.getColumns().add(column6);
        tableView.getColumns().add(col);

        updateTable();
    }
}
