FROM openjdk:11-jre-slim
WORKDIR /app
COPY /app/my-app.jar /app/my-app.jar
CMD ["java", "-jar", "/app/my-app.jar"]