# Use a newer Maven image for better TLS stability
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Preload dependencies (cached layer)
COPY pom.xml .
RUN mvn -B dependency:go-offline -DskipTests

# Copy source and build
COPY src ./src
RUN mvn -B clean package -DskipTests

# Use Tomcat to deploy WAR
FROM tomcat:9.0.85-jdk17
COPY --from=build /app/target/helloworld-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/helloworld.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
