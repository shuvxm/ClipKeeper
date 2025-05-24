package org.saas.downloader.util;

import com.microsoft.playwright.*;

import java.util.List;

public class InstagramScraper {

    public static String extractVideoUrl(String reelUrl) {
        try (Playwright playwright = Playwright.create()) {
            Browser browser = playwright.chromium().launch(
                    new BrowserType.LaunchOptions().setHeadless(true));
            Page page = browser.newPage();

            page.navigate(reelUrl);
            page.waitForTimeout(5000); // wait for content to load

            // 🔍 Debugging: print all video srcs on the page
//            List<Locator> videos = page.locator("video").all();
//            for (Locator video : videos) {
//                System.out.println("Video found: " + video.getAttribute("src"));
//            }

            // ✅ Try extracting the <video> tag instead
            Locator videoTag = page.locator("video");

            // Optional: wait until the video tag appears
            videoTag.waitFor(new Locator.WaitForOptions().setTimeout(10000));

            String videoUrl = videoTag.getAttribute("src");

            browser.close();

            if (videoUrl == null || videoUrl.isEmpty()) {
                throw new RuntimeException("Unable to extract video. The video may be private or restricted.");
            }

            return videoUrl;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Playwright scraping failed: " + e.getMessage());
        }
    }
}
