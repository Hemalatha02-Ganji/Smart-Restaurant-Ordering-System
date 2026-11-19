package com.clinic.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model representing an Appointment schedule.
 */
public class Appointment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int appointmentId;
    private String appointmentToken;
    private String patientId;
    private int doctorId;
    private Date appointmentDate;
    private String timeSlot;
    private String reason;
    private String status; // 'Pending', 'Confirmed', 'Cancelled', 'Completed'
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined Doctor details for view rendering
    private String doctorName;
    private String doctorSpecialization;
    private String doctorRoom;
    private BigDecimal consultationFee;

    // Joined Patient details for receptionist view & slip
    private String patientName;
    private String patientPhone;
    private String patientEmail;
    private String patientGender;
    private Date patientDob;

    public Appointment() {}

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getAppointmentToken() { return appointmentToken; }
    public void setAppointmentToken(String appointmentToken) { this.appointmentToken = appointmentToken; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Joined Getters and Setters
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDoctorSpecialization() { return doctorSpecialization; }
    public void setDoctorSpecialization(String doctorSpecialization) { this.doctorSpecialization = doctorSpecialization; }

    public String getDoctorRoom() { return doctorRoom; }
    public void setDoctorRoom(String doctorRoom) { this.doctorRoom = doctorRoom; }

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientPhone() { return patientPhone; }
    public void setPatientPhone(String patientPhone) { this.patientPhone = patientPhone; }

    public String getPatientEmail() { return patientEmail; }
    public void setPatientEmail(String patientEmail) { this.patientEmail = patientEmail; }

    public String getPatientGender() { return patientGender; }
    public void setPatientGender(String patientGender) { this.patientGender = patientGender; }

    public Date getPatientDob() { return patientDob; }
    public void setPatientDob(Date patientDob) { this.patientDob = patientDob; }
}
