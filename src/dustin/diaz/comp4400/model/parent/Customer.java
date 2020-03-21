package dustin.diaz.comp4400.model.parent;

import java.sql.Date;
import java.util.Arrays;

public class Customer {
    private int id;
    private String username;
    private String accountPassword;
    private String firstName;
    private String middleName;
    private String lastName;
    private Date dateOfBirth;
    private String address;
    private String city;
    private String zipCode;
    private String phone;
    private String accountType;
    private String[] rentedHistory;

    public Customer() {}

    public Customer(int id, String username, String accountPassword, String firstName, String middleName, String lastName,
                    Date dateOfBirth, String address, String city, String zipCode, String phone, String accountType,
                    String[] rentedHistory) {
        this.id = id;
        this.username = username;
        this.accountPassword = accountPassword;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.city = city;
        this.zipCode = zipCode;
        this.phone = phone;
        this.accountType = accountType;
        this.rentedHistory = rentedHistory;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAccountPassword() {
        return accountPassword;
    }

    public void setAccountPassword(String accountPassword) {
        this.accountPassword = accountPassword;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String[] getRentedHistory() {
        return rentedHistory;
    }

    public void setRentedHistory(String[] rentedHistory) {
        this.rentedHistory = rentedHistory;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + accountPassword + '\'' +
                ", firstName='" + firstName + '\'' +
                ", middleName='" + middleName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", dateOfBirth=" + dateOfBirth +
                ", address='" + address + '\'' +
                ", city='" + city + '\'' +
                ", zipCode='" + zipCode + '\'' +
                ", phone='" + phone + '\'' +
                ", role='" + accountType + '\'' +
                ", rented=" + Arrays.toString(rentedHistory) +
                '}';
    }
}

