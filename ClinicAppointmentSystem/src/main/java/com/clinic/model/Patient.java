package com.clinic.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model representing a registered Patient in the Clinic Appointment Scheduling System.
 * Developer: Hemalatha Ganji (Roll No: 24761A05S2)
 */
public class Patient implements Serializable {
    private static final long serialVersionUID = 1L;

    private String patientId;
    private String patientName;
    private Date dob;
    private String gender;
    private String phone;
    private String email;
    private String password;
    private String bloodGroup;
    private String address;
    private Timestamp createdAt;

    public Patient() {}

    public Patient(String patientId, String patientName, Date dob, String gender, 
                   String phone, String email, String password, String bloodGroup, String address) {
        this.patientId = patientId;
        this.patientName = patientName;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.bloodGroup = bloodGroup;
        this.address = address;
    }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
