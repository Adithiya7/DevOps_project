package com.example.demo;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/status")
public class DemoController {

    // Define the expected payload message
    private final String defaultMessage = "Hello, Spring Boot! Version 1.1 Launched";

    // GET /status returns a 200 OK response with a simple message
    @GetMapping
    public ResponseEntity<String> getStatus() {
        return ResponseEntity.ok("Status: OK, Version 1.1 Verified Successfully!");
    }

    // POST /status validates the payload
    @PostMapping
    public ResponseEntity<String> verifyPayload(@RequestBody Payload payload) {
        if (defaultMessage.equals(payload.getMessage())) {
            return ResponseEntity.ok("Payload verified: OK, Version 1.1 Validated");
        } else {
            // When payload message is not as expected, return an error status code (400 Bad Request)
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                 .body("Error: Invalid payload, Please pass correct values to the application");
        }
    }
}