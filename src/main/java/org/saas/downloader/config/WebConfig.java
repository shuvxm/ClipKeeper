package org.saas.downloader.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // Apply CORS rules to all endpoints (/**)
                registry.addMapping("/**")
//                        .allowedOrigins("http://localhost:5173")  // Your frontend URL
                        .allowedOrigins("https://clipkeepervd.vercel.app")
                        .allowedMethods("GET", "POST", "PUT", "DELETE") // allowed HTTP methods
                        .allowedHeaders("*");  // allow all request headers
            }
        };
    }
}
