FROM openjdk:11-jre-slim
WORKDIR /app
COPY demo-spring-boot-0.0.1-SNAPSHOT.jar /app/my-app.jar
CMD ["java", "-jar", "/app/my-app.jar"]