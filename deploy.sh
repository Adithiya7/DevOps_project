#!/bin/bash

BUCKET_NAME="spring-app-artifactory/JFrog_Artifacts"
JAR_PATH="/root/Spring-App/"
CONTAINER_NAME="spring-container"
IMAGE_NAME="spring-app"
JAR_FILE="demo-spring-boot-0.0.1-SNAPSHOT.jar"

cd /root/Spring-App/

download_latest_jar() {
  aws s3 cp s3://$BUCKET_NAME/$JAR_FILE $JAR_PATH
  ##mv $JAR_FILE app/my-app.jar
  mv /root/Spring-App/$JAR_FILE /app/my-app.jar
}

deploy_app() {

  # Stop the existing container
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping existing container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME

else
        echo "No existing container found"
fi

  # Build & Run a new container with the updated JAR file
  docker build -t $IMAGE_NAME .
  docker run -d --name $CONTAINER_NAME -p 8080:8080 $IMAGE_NAME
}

# Infinite loop to monitor S3 bucket
while true; do
  # Check if there is a new JAR file
  download_latest_jar

  # Deploy the application
  deploy_app

  # Sleep for a specified interval (e.g., 10 minutes)
  sleep 300
done
