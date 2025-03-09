package com.example.demo;

public class Payload {
  private String message;

  // Default constructor is needed for JSON deserialization
  public Payload() {}

  public Payload(String message) {
    this.message = message;
  }

  // Getter and Setter methods
  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }
}