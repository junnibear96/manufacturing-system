# Stage 1: Build the WAR file
FROM eclipse-temurin:17-jdk-jammy AS build

# Install unzip for wallet handling
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Maven wrapper and configs
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Grant execute permission to mvnw
RUN chmod +x mvnw

# Download dependencies (go offline)
RUN ./mvnw dependency:go-offline -B

# Copy source code and wallet
COPY src src
COPY wallet wallet

# Build the WAR file (skip tests)
RUN ./mvnw clean package -DskipTests

# Stage 2: Run in external Tomcat
FROM tomcat:10.1-jdk17-temurin-jammy

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR file to the webapps directory as ROOT.war
COPY --from=build /app/target/TP.war /usr/local/tomcat/webapps/ROOT.war

# Copy wallet files (required for Oracle connection)
COPY --from=build /app/wallet /app/wallet

# Set environment variables for Oracle Wallet
ENV TNS_ADMIN=/app/wallet

# Set JVM options (for Railway Free Tier)
ENV JAVA_OPTS="-Xmx256m -Xms256m"

# Expose port 8080 (Tomcat default)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
