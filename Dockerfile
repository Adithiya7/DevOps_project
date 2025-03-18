FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/demo-spring-boot-*.jar /app/my-app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/my-app.jar"]