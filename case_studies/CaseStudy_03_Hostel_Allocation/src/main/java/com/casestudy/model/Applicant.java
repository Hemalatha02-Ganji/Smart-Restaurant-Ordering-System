package com.casestudy.model;

public class Applicant {
    private String rollNumber;
    private String applicationNumber;
    private String studentName;
    private String year;
    private String branch;
    private String phone;
    private String preferredHostel;
    private String password;

    public Applicant() {}
    public Applicant(String rollNumber, String applicationNumber, String studentName, String year, String branch, String phone, String preferredHostel, String password) {
        this.rollNumber = rollNumber;
        this.applicationNumber = applicationNumber;
        this.studentName = studentName;
        this.year = year;
        this.branch = branch;
        this.phone = phone;
        this.preferredHostel = preferredHostel;
        this.password = password;
    }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public String getApplicationNumber() { return applicationNumber; }
    public void setApplicationNumber(String applicationNumber) { this.applicationNumber = applicationNumber; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getYear() { return year; }
    public void setYear(String year) { this.year = year; }
    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getPreferredHostel() { return preferredHostel; }
    public void setPreferredHostel(String preferredHostel) { this.preferredHostel = preferredHostel; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
