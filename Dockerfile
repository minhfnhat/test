# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the executable JAR file into the container
COPY target/hello-world-spring-boot.jar /app/hello-world-spring-boot.jar

# Expose port 8080
EXPOSE 8080

# Set the entry point to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "hello-world-spring-boot.jar"]

# Note: To enforce the resource limits, use the following command when running the container:
# docker run -d -p 8080:8080 --cpus="1" --memory="2g" hello-world-spring-boot
