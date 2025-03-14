#!/bin/bash

BUCKET_NAME="spring-app-artifactory/JFrog_Artifacts"
JAR_PATH="/root/Spring-App/"
CONTAINER_NAME="spring-container"
IMAGE_NAME="spring-app"
JAR_FILE="demo-spring-boot-0.0.1-SNAPSHOT.jar"

cd /root/Spring-App/

download_latest_jar() {

  echo "Removing old JAR..."
  rm -f $JAR_PATH/my-app.jar $JAR_PATH/$JAR_FILE

  echo "Downloading latest JAR from S3..."
  aws s3 cp --no-progress --force s3://$BUCKET_NAME/$JAR_FILE $JAR_PATH
  ##mv $JAR_FILE app/my-app.jar
  ##mv /root/Spring-App/$JAR_FILE /app/my-app.jar
  mv $JAR_PATH/$JAR_FILE $JAR_PATH/my-app.jar
  rm -f app/my-app.jar
  cp $JAR_PATH/my-app.jar app/my-app.jar
}

deploy_app() {

  # Stop the existing container
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping & Removing existing container..."
  docker stop $CONTAINER_NAME
  docker rm -f $CONTAINER_NAME

else
        echo "No existing container found"
fi

  echo "Removing old untagged images..."
  docker rmi -f $(docker images -f "dangling=true" -q) 2>/dev/null

  # Build & Run a new container with the updated JAR file
  docker build --no-cache -t $IMAGE_NAME:latest .
  docker run -d --name $CONTAINER_NAME -p 8080:8080 $IMAGE_NAME
}

# Infinite loop to monitor S3 bucket
while true; do
  # Check if there is a new JAR file
  download_latest_jar

  # Deploy the application
  deploy_app

  # Sleep for 10mins
  sleep 600
done