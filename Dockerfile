# === 1. Build Stage using Maven with Java 17 ===
FROM maven:3.9.3-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# === 2. Runtime Stage using Java 17 JDK ===
FROM eclipse-temurin:17-jdk AS runtime

WORKDIR /app

# === 3. Update and install dependencies required by Playwright to run headless Chromium ===
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget unzip gnupg curl \
  libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libxss1 libasound2 \
  libx11-xcb1 libatk-bridge2.0-0 libgtk-3-0 libxcb-dri3-0

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# === 4. Copy built app from build stage ===
COPY --from=build /app/target/*.jar app.jar

# === 5. Install Playwright Java runtime and Chromium ===
RUN mkdir -p /root/.cache && \
  wget https://github.com/microsoft/playwright-java/releases/download/v1.43.1/playwright-java-1.43.1.zip && \
  unzip playwright-java-1.43.1.zip -d /root/.cache && \
  rm playwright-java-1.43.1.zip && \
  /root/.cache/playwright-java-1.43.1/playwright install --with-deps

# === 6. Expose the port your Spring Boot app runs on ===
EXPOSE 8080

# === 7. Run the Spring Boot app ===
ENTRYPOINT ["java", "-jar", "app.jar"]
