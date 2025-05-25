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

# Install Playwright browsers
RUN wget https://github.com/microsoft/playwright-java/releases/download/v1.52.0/playwright-java-1.52.0.zip && \
    unzip playwright-java-1.52.0.zip -d /root/.cache && \
    rm playwright-java-1.52.0.zip && \
    /root/.cache/playwright-java-1.52.0/playwright install --with-deps

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
