# ---------- Stage 1: Build ----------
FROM maven:3.8.1-jdk-8-slim AS build
WORKDIR /app

# Copy only pom.xml first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Now copy source code and build the WAR (skip tests for speed)
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Stage 2: Runtime ----------
FROM tomcat:9.0.53-jdk8
# Copy the built WAR into Tomcat webapps directory
COPY --from=build /app/target/helloworld-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/helloworld.war

# Optional: expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

