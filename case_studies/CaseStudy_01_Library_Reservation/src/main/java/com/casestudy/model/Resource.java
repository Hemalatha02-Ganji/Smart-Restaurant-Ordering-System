package com.casestudy.model;

public class Resource {
    private int resourceId;
    private String title;
    private String author;
    private String category;
    private String status;

    public Resource() {}
    public Resource(int resourceId, String title, String author, String category, String status) {
        this.resourceId = resourceId;
        this.title = title;
        this.author = author;
        this.category = category;
        this.status = status;
    }

    public int getResourceId() { return resourceId; }
    public void setResourceId(int resourceId) { this.resourceId = resourceId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
