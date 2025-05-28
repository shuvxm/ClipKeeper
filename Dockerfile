# === Build Stage ===
FROM maven:3.9.3-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# === Runtime Stage ===
FROM openjdk:17-jdk-slim

WORKDIR /app

# Install dependencies required by Playwright browsers
RUN apt-get update && apt-get install -y \
    wget unzip gnupg curl \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libxss1 libasound2 \
    libx11-xcb1 libatk-bridge2.0-0 libgtk-3-0 libxcb-dri3-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the jar file
COPY --from=build /app/target/*.jar app.jar

# Set Playwright version (using the latest stable version as of May 2024)
ENV PLAYWRIGHT_VERSION=1.42.0

# Install Playwright browsers
RUN mkdir -p /root/.cache && \
    wget https://github.com/microsoft/playwright-java/releases/download/v${PLAYWRIGHT_VERSION}/playwright-java-${PLAYWRIGHT_VERSION}-linux.zip -O playwright-java.zip && \
    unzip playwright-java.zip -d /root/.cache && \
    rm playwright-java.zip && \
    /root/.cache/playwright-java-${PLAYWRIGHT_VERSION}-linux/playwright install --with-deps

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]