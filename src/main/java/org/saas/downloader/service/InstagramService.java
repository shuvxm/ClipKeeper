package org.saas.downloader.service;


import org.saas.downloader.util.InstagramScraper;
import org.springframework.stereotype.Service;

@Service
public class InstagramService {

    public String fetchVideoUrl(String reelUrl) {
        return InstagramScraper.extractVideoUrl(reelUrl);
    }
}