package org.saas.downloader.controller;

import org.saas.downloader.service.InstagramService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class InstagramController {

    @Autowired
    private InstagramService instagramService;

    @PostMapping("/instagram")
    public ResponseEntity<?> getInstagramVideo(@RequestBody Map<String, String> request) {
        String url = request.get("url");

        if (url == null || !url.contains("instagram.com")) {
            return ResponseEntity.badRequest().body(Map.of("error", "Invalid or missing Instagram URL."));
        }

        try {
            String videoUrl = instagramService.fetchVideoUrl(url);
            return ResponseEntity.ok(Map.of("videoUrl", videoUrl));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Failed to fetch video URL.", "details", e.getMessage()));
        }
    }

    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadVideo(@RequestParam String url) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder(URI.create(url)).build();
            HttpResponse<byte[]> response = client.send(request, HttpResponse.BodyHandlers.ofByteArray());

            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=instagram-reel.mp4")
                    .header("Content-Type", "video/mp4")
                    .body(response.body());
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}
