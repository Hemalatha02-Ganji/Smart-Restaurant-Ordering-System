package com.casestudy.model;

public class Course {
    private int courseId;
    private String title;
    private String duration;
    private double fee;
    private int totalSeats;
    private int availableSeats;

    public Course() {}
    public Course(int courseId, String title, String duration, double fee, int totalSeats, int availableSeats) {
        this.courseId = courseId;
        this.title = title;
        this.duration = duration;
        this.fee = fee;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
    }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public double getFee() { return fee; }
    public void setFee(double fee) { this.fee = fee; }
    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
}
