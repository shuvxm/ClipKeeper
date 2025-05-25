# === 1. Build Stage ===
FROM maven:3.9.3-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# === 2. Runtime Stage with APT Support ===
FROM openjdk:17-jdk-slim-bullseye AS runtime

WORKDIR /app

# === 3. Install dependencies for Playwright headless browser support ===
RUN apt-get update && apt-get install -y \
  wget unzip gnupg curl \
  libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libxss1 libasound2 \
  libx11-xcb1 libatk-bridge2.0-0 libgtk-3-0 libxcb-dri3-0 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# === 4. Copy built app ===
COPY --from=build /app/target/*.jar app.jar

# === 5. Install Playwright ===
RUN mkdir -p /root/.cache && \
  wget https://github.com/microsoft/playwright-java/releases/download/v1.43.0/playwright-java-1.43.0.zip && \
  unzip playwright-java-1.43.0.zip -d /root/.cache && \
  rm playwright-java-1.43.0.zip && \
  /root/.cache/playwright-java-1.43.0/playwright install --with-deps


EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
