# Use a minimal Java runtime (no build tools needed)
FROM eclipse-temurin:21-jre

# Create app directory
WORKDIR /app

# Copy your JAR from the target folder (that came from previous job)
COPY target/*.jar app.jar

# Expose the port your app runs on
EXPOSE 8080

# Run your JAR file
CMD ["java", "-jar", "app.jar"]