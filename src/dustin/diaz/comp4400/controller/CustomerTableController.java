package dustin.diaz.comp4400.controller;

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
            warning.setText("");
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

        tableView.getColumns().clear();

        refreshBtn.setOnMousePressed(e -> updateTable());

        refreshBtn.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) refreshBtn.fire();
        });

        backBtn.setOnMousePressed(e -> {
            try {
                Computer.customer = QueryCustomer.find(Computer.customer.getId());
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            Computer.changeScreen(borderPane, "adminhome");
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

            Computer.changeScreen(borderPane, "addaccount");
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

                Computer.changeScreen(borderPane, "editaccount");

                updateTable();
            }
        });

        editButton.setOnKeyPressed(e -> {
            if (e.getCode().toString().equals("ENTER")) editButton.fire();
        });

        tableView.setOnMousePressed(e -> selected = (Customer) tableView.getSelectionModel().getSelectedItem());

        tableView.setOnMouseClicked(event -> {
            String e = event.toString();
            if (!e.contains("target = TableColumnHeader") && !e.contains("target = Label") && selected != null) {
                if (event.getButton().equals(MouseButton.SECONDARY)) {
                    String choice = ChooseBox.display(
                            Styling.formatNames(selected.getFirstName(), selected.getLastName()),
                            "" + selected.getId()
                    );

                    if (choice != null) {
                        Customer c = selected;
                        String name = Styling.formatNames(c.getFirstName(), c.getLastName());

                        if (choice.equals("Edit")) {
                            Computer.editCustomer = c;
                            Computer.changeScreen(borderPane, "editaccount");
                            updateTable();
                        } else if (choice.equals("Delete")) {
                            if (ConfirmBox.display(
                                    "Delete " + name,
                                    "Are you sure you want to DELETE user '" + name + "' " + "(ID: " + c.getId() + ")?")) {
                                try {
                                    QueryCustomer.delete(c.getId());
                                    updateTable();
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }
                        } else {
                            ConfirmBox.display(
                                    "Unrecognized Command",
                                    "Please specify the command in the ChooseBox Class"
                            );
                        }
                    }

                } else if (event.getButton().equals(MouseButton.PRIMARY) && event.getClickCount() == 2) {
                    String name = Styling.formatNames(selected);
                    if (
                            ConfirmBox.display(
                                    "Edit " + name,
                                    "Would you like to EDIT " + name + " (ID:" + selected.getId() + ")?"
                            )
                    ) {
                        Computer.editCustomer = selected;
                        Computer.changeScreen(borderPane, "editaccount");
                        updateTable();
                    }
                }
            }
        });

        tableView.setPlaceholder(new Label("No customers to display."));

        TableColumn<String, Customer> id = new TableColumn<>("ID");
        id.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<String, Customer> accountType = new TableColumn<>("Account Type");
        accountType.setCellValueFactory(new PropertyValueFactory<>("accountType"));

        TableColumn<String, Customer> firstName = new TableColumn<>("First Name");
        firstName.setCellValueFactory(new PropertyValueFactory<>("firstName"));

        TableColumn<String, Customer> lastName = new TableColumn<>("Last Name");
        lastName.setCellValueFactory(new PropertyValueFactory<>("lastName"));

        TableColumn<String, Customer> address = new TableColumn<>("Address");
        address.setCellValueFactory(new PropertyValueFactory<>("address"));

        TableColumn<String, Customer> city = new TableColumn<>("City");
        city.setCellValueFactory(new PropertyValueFactory<>("city"));

        TableColumn<String, Customer> zipCode = new TableColumn<>("Zip Code");
        zipCode.setCellValueFactory(new PropertyValueFactory<>("zipCode"));

        TableColumn<String, Customer> phone = new TableColumn<>("Phone");
        phone.setCellValueFactory(new PropertyValueFactory<>("phone"));

        Styling.setTableConst(tableView);

        tableView.getColumns().add(id);
        tableView.getColumns().add(firstName);
        tableView.getColumns().add(lastName);
        tableView.getColumns().add(address);
        tableView.getColumns().add(city);
        tableView.getColumns().add(zipCode);
        tableView.getColumns().add(phone);
        tableView.getColumns().add(accountType);

        updateTable();
    }
}
